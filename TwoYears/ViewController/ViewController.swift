//
//  ViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import BATabBarController
import GuillotineMenu
import SwiftMoment
import Nuke

class ViewController: UIViewController{
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 5
    
    var temes : [Team] = []
    var animals: [Animal] = []
    var newColor : String?
    let DBZ = Firestore.firestore().collection("Rooms").document("karano")
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    //    navigationvarのやつ
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet weak var sendImageView: UIImageView!
    
    @IBAction func tappedBubuButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "sinkitoukou", bundle: nil)
        let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "sinkitoukou")
        self.present(sinkitoukou, animated: true, completion: nil)
        Firestore.firestore().collection("users").document(uid!).setData(["nowjikan": FieldValue.serverTimestamp()], merge: true)
        //        try? Auth.auth().signOut()
    }
    
    @IBOutlet weak var headerColorLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headertopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        guard let presentIndexPath = chatListTableView.indexPathForRow(at: scrollView.contentOffset) else { return }
        if scrollView.contentOffset.y < 0 { return }
        if presentIndexPath.row >= animals.count - 6 { return }
        
        let alphaRatio = 1 / headerhightConstraint.constant
        
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headertopConstraint.constant <= -headerhightConstraint.constant { return }
            headertopConstraint.constant -= headerMoveHeight
            headerView.alpha -= alphaRatio * headerMoveHeight
        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if headertopConstraint.constant >= 0 {return}
            headertopConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
        
        print(self.prevContentOffset)
        print("えええ",scrollView.contentOffset)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            headerViewEndAnimation()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    private func headerViewEndAnimation() {
        if headertopConstraint.constant < -headerhightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations:{ [self] in
                headertopConstraint.constant = -headerhightConstraint.constant
                headerView.alpha = 0
                view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations:{ [self] in
                headertopConstraint.constant = 0
                headerView.alpha = 1
                view.layoutIfNeeded()
            })
        }
    }
    @IBOutlet weak var bubuButton: UIButton!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        //navigationbarのやつ
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)

        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        chatListTableView.separatorStyle = .none
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        bubuButton.layer.cornerRadius = 30
        bubuButton.clipsToBounds = true
        bubuButton.layer.masksToBounds = false
        bubuButton.layer.shadowColor = UIColor.black.cgColor
        bubuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        bubuButton.layer.shadowOpacity = 1
        bubuButton.layer.shadowRadius = 5
        fetchFireStore()
        chatListTableView.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
    }
    //うえのモーションするやつ
    @IBAction func GuillotineTappedButton(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ShoutaiHakkou", bundle: nil)//遷移先のStoryboardを設定
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "ShoutaiHakkou")
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
            self?.chatListTableView.reloadData()
            self?.chatListTableView.refreshControl?.endRefreshing()
        }
    }
    private func fetchFireStore() {
        DBZ.collection("kokoniireru").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarabai = Animal(dic: dic)
                    
//                    let date: Date = rarabai.zikokudosei.dateValue()
//                    let momentType = moment(date)
                    
//                    if blockList[rarabai.userId] == true {
//
//                    } else {
//                        if momentType >= moment() - 14.days {
//                            if rarabai.admin == true {
//                            }
//                            self.animals.append(rarabai)
//                        }
//                    }
                    
                    self.animals.append(rarabai)
                    
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.animals.sort { (m1, m2) -> Bool in
                        let m1Date = m1.latestAt.dateValue()
                        let m2Date = m2.latestAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.chatListTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell

        print("アニマルズ！！",animals[1])
        
        if animals[indexPath.row].company1 != ""{
            firebaseCompany.document(animals[indexPath.row].company1).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    let companyLogoImage = document.data()?["companyLogoImage"]as? String?
                    if let url = URL(string: companyLogoImage!!) {
                        Nuke.loadImage(with: url, into: cell.companyImageView!)
                    }
                }
            }
        }
        cell.messageLabel.text = animals[indexPath.row].nameJP
        cell.backBack.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        let date: Date = animals[indexPath.row].zikokudosei.dateValue()
        print("デート！！",date)
        let momentType = moment(date)
        if momentType < moment() - 15.days {
            cell.dateLabel.text = "削除済みです"
        } else if momentType < moment() - 14.days - 23.hours - 30.minutes{
            cell.dateLabel.text = "もうすぐ消えます"
        } else if momentType < moment() - 14.days - 23.hours{
            cell.dateLabel.text = "1時間以内に消えます"
        } else if momentType < moment() - 14.days - 18.hours{
            cell.dateLabel.text = "数時間後に消えます"
        } else if momentType < moment() - 14.days - 12.hours{
            cell.dateLabel.text = "半日後に消えます"
        } else if momentType < moment() - 14.days{
            cell.dateLabel.text = "1日後に消えます"
        } else if momentType < moment() - 13.days{
            cell.dateLabel.text = "2日後に消えます"
        } else if momentType < moment() - 12.days{
            cell.dateLabel.text = "3日後に消えます"
        } else if momentType < moment() - 11.days{
            cell.dateLabel.text = "4日後に消えます"
        } else if momentType < moment() - 10.days{
            cell.dateLabel.text = "5日後に消えます"
        } else {
            cell.dateLabel.text = ""
        }
        if animals[indexPath.row].teamname == "yellow" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            bubuButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8800139127)
        } else if animals[indexPath.row].teamname == "red" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            bubuButton.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9297410103)
        } else if animals[indexPath.row].teamname == "purple" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            bubuButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.91)
        } else if animals[indexPath.row].teamname == "blue" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 1, alpha: 1)
            bubuButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 1, alpha: 1)
            cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.91)
        }
        cell.userImageView.image = nil
        cell.companyImageView.image = nil
        cell.IndividualImageView.image = nil
        if animals[indexPath.row].userBrands == "TG1" {
            cell.userImageView.image = UIImage(named:"TG1")!
            
        } else if animals[indexPath.row].userBrands == "TG2" {
            cell.userImageView.image = UIImage(named:"TG2")!
            
        } else if animals[indexPath.row].userBrands == "TG3" {
            cell.userImageView.image = UIImage(named:"TG3")!
            
        } else if animals[indexPath.row].userBrands == "TG4" {
            cell.userImageView.image = UIImage(named:"TG4")!
            
        } else if animals[indexPath.row].userBrands == "TG5" {
            cell.userImageView.image = UIImage(named:"TG5")!
        }
        let comentjidate = animals[indexPath.row].zikokudosei.dateValue()
        let comentjimoment = moment(comentjidate)
        let dateformatted2 = comentjimoment.format("MM/dd")
        let comentjiLatestdate = animals[indexPath.row].latestAt.dateValue()
        let comentjiLatestmoment = moment(comentjiLatestdate)
        let dateformattedLatest = comentjiLatestmoment.format("MM/dd")
        cell.firstdateLabel.text = dateformatted2
        cell.latestdateLabel.text = dateformattedLatest
        cell.messageCountLabel.text = String(animals[indexPath.row].messageCount)
        cell.goodCountLabel.text = String(animals[indexPath.row].GoodmanCount - 1)
        cell.viewCountLabel.text = String(animals[indexPath.row].viewCount)
        cell.userImageView.layer.cornerRadius = 22
        cell.companyImageView.layer.cornerRadius = 22
        cell.IndividualImageView.layer.cornerRadius = 22
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.animals = animals[indexPath.row]
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        chatRoomViewController.dragons = animals[indexPath.row]
        print("ああああああああああああ",
              chatRoomViewController.dragons as Any)
        print(animals[indexPath.row])
        chatRoomViewController.hidesBottomBarWhenPushed = true
        let aaaaa = animals[indexPath.row].zikokudosei.dateValue()
        print(aaaaa)
        
        if animals[indexPath.row].userId != uid {
            DBU.document(animals[indexPath.row].userId).updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
            
            DBZ.collection("kokoniireru").document(animals[indexPath.row].documentId).updateData([
                "viewcount": FieldValue.increment(Int64(1))
            ])
        } else {
        }
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
class ChatListTableViewCell: UITableViewCell {
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
    @IBOutlet weak var backBack: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var goodCountLabel: UILabel!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latestdateLabel: UILabel!
    @IBOutlet weak var firstdateLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var IndividualImageView: UIImageView!
    @IBOutlet weak var companywidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var individualwidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageiconView: UIImageView!
    @IBOutlet weak var goodiconView: UIImageView!
    @IBOutlet weak var viewiconView: UIImageView!
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
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
