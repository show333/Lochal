//
//  UserCommentViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/25.
//


import Firebase
import GuillotineMenu
import FirebaseFirestore
import SwiftMoment
import Nuke

class UserCommentViewController: UIViewController {
    
    var animals: [Animal] = []
    let DBZ = Firestore.firestore().collection("Rooms").document("karano")
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    private let cellId = "cellId"
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet weak var yourLabel: UILabel!
    @IBOutlet weak var userBackImageView: UIImageView!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var userUIView: UIView!
    @IBOutlet weak var toukouLabel: UILabel!
    @IBOutlet weak var userViewCountLabel: UILabel!
    @IBOutlet weak var userGoodCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let teamName = UserDefaults.standard.string(forKey: "color")
        let goodcount = UserDefaults.standard.integer(forKey: "goodcount")
        let viewcount = UserDefaults.standard.integer(forKey: "viewcount")
        if teamName == "red" {
            yourLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3906800176)
            userGoodCountLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3906800176)
            userViewCountLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3906800176)
        } else if teamName == "yellow" {
            yourLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9482958753, blue: 0, alpha: 0.3933758803)
            userGoodCountLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9482958753, blue: 0, alpha: 0.3933758803)
            userViewCountLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9482958753, blue: 0, alpha: 0.3933758803)
        } else if teamName == "blue" {
            yourLabel.backgroundColor = #colorLiteral(red: 0.3348371479, green: 0.9356233796, blue: 1, alpha: 0.4039117518)
            userGoodCountLabel.backgroundColor = #colorLiteral(red: 0.3348371479, green: 0.9356233796, blue: 1, alpha: 0.4039117518)
            userViewCountLabel.backgroundColor = #colorLiteral(red: 0.3348371479, green: 0.9356233796, blue: 1, alpha: 0.4039117518)
        } else if teamName == "purple" {
            yourLabel.backgroundColor = #colorLiteral(red: 0.769806338, green: 0.4922828673, blue: 1, alpha: 0.4026463468)
            userGoodCountLabel.backgroundColor = #colorLiteral(red: 0.769806338, green: 0.4922828673, blue: 1, alpha: 0.4026463468)
            userViewCountLabel.backgroundColor = #colorLiteral(red: 0.769806338, green: 0.4922828673, blue: 1, alpha: 0.4026463468)
        }
        userGoodCountLabel.clipsToBounds = true
        yourLabel.clipsToBounds = true
        userViewCountLabel.clipsToBounds = true
        yourLabel.layer.cornerRadius = 5
        userGoodCountLabel.layer.cornerRadius = 5
        userViewCountLabel.layer .cornerRadius = 15
        print("グッドカウント!!",goodcount)
        print("viewカウント!!",viewcount)
        userViewCountLabel.text = String(viewcount) + "PV"
        userGoodCountLabel.text = "And " + String(goodcount) + " Good"
        tabBarController?.tabBar.isHidden = false
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.separatorStyle = .none
        chatListTableView.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
        lalaBai(teamname: teamName!)
        if teamName == "red" {
            navBar?.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)]
        } else if teamName == "blue" {
            navBar?.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.4093301235, green: 0.9249009683, blue: 1, alpha: 1)]
            
        } else if teamName == "yellow" {
            navBar?.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 0.992557539, blue: 0.3090870815, alpha: 1)]
            
        } else if teamName == "purple" {
            navBar?.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.8918020612, green: 0.7076364437, blue: 1, alpha: 1)]
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func GuillotineTappedButton(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ShoutaiHakkou", bundle: nil)//遷移先のStoryboardを設定
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "ShoutaiHakkou") //遷移先のTabbarController指定とIDをここに入力
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender
        present(menuViewController, animated: true, completion: nil)
    }
    //Pull to Refresh
    @objc private func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.chatListTableView.refreshControl?.endRefreshing()
        }
    }
    private func lalaBai(teamname: String) {
        DBZ.collection("kokoniireru").whereField(uid!, isEqualTo: true).addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarabai = Animal(dic: dic,user:teamname)
                    
                    let date: Date = rarabai.zikokudosei.dateValue()
                    let momentType = moment(date)
                    
                    if blockList[rarabai.userId] == true {
                        
                    } else {
                        if momentType >= moment() - 5.days {
                            if rarabai.admin == true {
                            }
                            self.animals.append(rarabai)
                        }
                    }
                    self.animals.sort { (m1, m2) -> Bool in
                        let m1Date = m1.zikokudosei.dateValue()
                        let m2Date = m2.zikokudosei.dateValue()
                        return m1Date < m2Date
                    }
                    self.chatListTableView.reloadData()
                    
                    if animals.count < 1 {
                        toukouLabel.alpha = 1
                    } else {
                        toukouLabel.alpha = 0
                    }
                    
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
}
extension UserCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if animals.count < 100 {
            return animals.count
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCommentTableViewCell
        if animals[indexPath.row].teamname == "yellow" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            
            if animals[indexPath.row].userId == uid {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            } else {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8800139127)
            }
            
        } else if animals[indexPath.row].teamname == "red" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            
            if animals[indexPath.row].userId == uid {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            } else {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8800139127)
            }
        } else if animals[indexPath.row].teamname == "purple" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            
            if animals[indexPath.row].userId == uid {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            } else {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8800139127)
            }
        } else if animals[indexPath.row].teamname == "blue" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 1, alpha: 1)
            
            if animals[indexPath.row].userId == uid {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            } else {
                cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8800139127)
            }
        }
        cell.messageLabel.text = animals[indexPath.row].nameJP
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.backback.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
        print(animals[indexPath.row].zikokudosei)
        let date: Date = animals[indexPath.row].zikokudosei.dateValue()
        print("デート！！",date)
        let momentType = moment(date)
        if momentType < moment() - 5.days {
            cell.aftertime.text = "削除済みです"
        } else if momentType < moment() - 4.days - 23.hours - 30.minutes{
            cell.aftertime.text = "もうすぐ消えます"
        } else if momentType < moment() - 4.days - 23.hours{
            cell.aftertime.text = "1時間以内に消えます"
        } else if momentType < moment() - 4.days - 18.hours{
            cell.aftertime.text = "数時間後に消えます"
        } else if momentType < moment() - 4.days - 12.hours{
            cell.aftertime.text = "半日後に消えます"
        } else if momentType < moment() - 4.days{
            cell.aftertime.text = "1日後に消えます"
        } else if momentType < moment() - 3.days{
            cell.aftertime.text = "2日後に消えます"
        } else if momentType < moment() - 2.days{
            cell.aftertime.text = "3日後に消えます"
        } else if momentType < moment() - 1.days{
            cell.aftertime.text = "4日後に消えます"
        } else if momentType < moment(){
            cell.aftertime.text = "5日後に消えます"
        }
        cell.userImageView.image = nil
        
        if animals[indexPath.row].userBrands == "TG1" {
            cell.userImageView.image = UIImage(named:"TG1")!
            cell.userImageView.alpha = 1
            
        } else if animals[indexPath.row].userBrands == "TG2" {
            cell.userImageView.image = UIImage(named:"TG2")!
            cell.userImageView.alpha = 1
            
        } else if animals[indexPath.row].userBrands == "TG3" {
            cell.userImageView.image = UIImage(named:"TG3")!
            cell.userImageView.alpha = 1
            
        } else if animals[indexPath.row].userBrands == "TG4" {
            cell.userImageView.image = UIImage(named:"TG4")!
            cell.userImageView.alpha = 1
            
        } else if animals[indexPath.row].userBrands == "TG5" {
            cell.userImageView.image = UIImage(named:"TG5")!
            cell.userImageView.alpha = 1
        }
        
        cell.messageCountLabel.text = String(animals[indexPath.row].messageCount) + "メッセージ"
        cell.goodCountLabel.text = String(animals[indexPath.row].GoodmanCount - 1) + "いいね！"
        cell.viewCountLabel.text = String(animals[indexPath.row].viewCount) + "PV"
        cell.userImageView.layer.cornerRadius = 20
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        
        chatRoomViewController.dragons = animals[indexPath.row]
        print("チャットランキング",
              chatRoomViewController.dragons as Any)
        print(animals[indexPath.row])
        
        if animals[indexPath.row].userId != uid {
            DBU.document(animals[indexPath.row].userId).updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
            
            DBZ.collection("kokoniireru").document(animals[indexPath.row].documentId).updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
            
        } else {
        }
        
        if animals[indexPath.row].teamname == "red" || animals[indexPath.row].teamname == "yellow"{
            Firestore.firestore().collection("teams").document("orange").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        } else if animals[indexPath.row].teamname == "blue" || animals[indexPath.row].teamname == "purple" {
            Firestore.firestore().collection("teams").document("violet").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        }
        
        
        if animals[indexPath.row].teamname == "red" {
            Firestore.firestore().collection("teams").document("red").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        } else if animals[indexPath.row].teamname == "blue" {
            Firestore.firestore().collection("teams").document("blue").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        } else if animals[indexPath.row].teamname == "yellow" {
            Firestore.firestore().collection("teams").document("yellow").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        } else if animals[indexPath.row].teamname == "purple" {
            Firestore.firestore().collection("teams").document("purple").updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        }
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        chatListTableView.deselectRow(at: indexPath, animated: true)
    }
}

class ShadowMyCommentView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

class UserCommentTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.backgroundColor = .clear
    }
    
    var animals : Animal? {
        didSet{
            if let animals = animals {
                messageLabel.text = animals.nameJP
            }
        }
    }
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var goodCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var aftertime: UILabel!
    @IBOutlet weak var backback: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

extension UserCommentViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
