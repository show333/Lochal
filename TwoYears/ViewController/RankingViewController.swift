//
//  RankingViewController.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/02.
//

import UIKit
import Firebase
import GuillotineMenu
import FirebaseFirestore
import SwiftMoment

class RankingViewController: UIViewController {

    var animals: [Animal] = []
    let DBZ = Firestore.firestore().collection("Rooms").document("karano")
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    private let headerMoveHeight: CGFloat = 5

    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let teamName = UserDefaults.standard.string(forKey: "color")
        print("aaa",teamName!)

        tabBarController?.tabBar.isHidden = false
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension

//        navigationbarのやつ
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)

        
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)

        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.separatorStyle = .none
        chatListTableView.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
//            #colorLiteral(red: 0.7238116197, green: 0.6172274334, blue: 0.5, alpha: 1)

        lalaBai(teamname: teamName!)
//        self.chatListTableView.reloadData()

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
//    order(by: "goodcount" ,descending: true).

    private func lalaBai(teamname: String) {
        DBZ.collection("kokoniireru").order(by: "goodcount" ,descending: true).order(by: "createdLatestAt" ,descending: true).addSnapshotListener { [self] ( snapshots, err) in
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
                        if momentType >= moment() - 14.days {
                            if rarabai.admin == true {
                            }
                            self.animals.append(rarabai)
                        }
                    }
                    
                    print("でぃく",dic)
                    print("ららばい",rarabai)
                    
                    
                    print("でぃく",dic)
                    print("ららばい",rarabai)
                    self.animals.sort { (m1, m2) -> Bool in
                        let m1View = m1.viewCount
                        let m2View = m2.viewCount
                        return m1View > m2View
                    }
                    
                    self.chatListTableView.reloadData()
                    
                case .modified, .removed:
                    
                    
                    print("noproblem")
                }
            })
        }
    }
}
extension RankingViewController: UITableViewDelegate, UITableViewDataSource {

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
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRankingTableViewCell
        

        cell.messageLabel.text = animals[indexPath.row].nameJP
        
//        if animals[indexPath.row].teamname == "yellow" {
//            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0.992557539, blue: 0.3090870815, alpha: 1)
//            if animals[indexPath.row].membersCount >= 2{
//                cell.messageLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9482958753, blue: 0, alpha: 0.3933758803)
//            }
//        } else if animals[indexPath.row].teamname == "red" {
//            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
//            if animals[indexPath.row].membersCount >= 2{
//                cell.messageLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3906800176)
//            }
//        } else if animals[indexPath.row].teamname == "purple" {
//            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.8918020612, green: 0.7076364437, blue: 1, alpha: 1)
//            if animals[indexPath.row].membersCount >= 2{
//                cell.messageLabel.backgroundColor = #colorLiteral(red: 0.769806338, green: 0.4922828673, blue: 1, alpha: 0.4026463468)
//            }
//        } else if animals[indexPath.row].teamname == "blue" {
//            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//            if animals[indexPath.row].membersCount >= 2{
//                cell.messageLabel.backgroundColor = #colorLiteral(red: 0.3348371479, green: 0.9356233796, blue: 1, alpha: 0.4039117518)
//            }
//        }
        
        if animals[indexPath.row].teamname == "yellow" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0.4894049657, blue: 0, alpha: 1)
        } else if animals[indexPath.row].teamname == "red" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        } else if animals[indexPath.row].teamname == "purple" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.7632168728, green: 0.6191839608, blue: 1, alpha: 1)
        } else if animals[indexPath.row].teamname == "blue" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.7632168728, green: 0.6191839608, blue: 1, alpha: 1)
        } else if animals[indexPath.row].teamname == "green" {
            cell.shadowLayer.layer.shadowColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
        
        

        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.backback.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
//        #colorLiteral(red: 0.7238116197, green: 0.6172274334, blue: 0.5, alpha: 1)
//        #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
        
        
   
        
        headerLabel.text = "Ranking"
        if animals[0].teamname == "yellow" {
            headerLabel.tintColor = #colorLiteral(red: 1, green: 0.992557539, blue: 0.3090870815, alpha: 1)
        } else if animals[0].teamname == "red" {
            headerLabel.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
        } else if animals[0].teamname == "blue" {
            headerLabel.tintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        } else if animals[0].teamname == "purple" {
            headerLabel.tintColor = #colorLiteral(red: 0.8918020612, green: 0.7076364437, blue: 1, alpha: 1)
        }
        cell.shadowLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8583047945)
//        #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 0.7282213185)
        cell.rankingnumber.text = (String(indexPath.row + 1))
        print(animals[indexPath.row].zikokudosei)
        
        let date: Date = animals[indexPath.row].zikokudosei.dateValue()
        
        print("デート！！",date)
        
        let momentType = moment(date)

        
        
        if momentType < moment() - 15.days {
            cell.aftertime.text = "削除済みです"
        } else if momentType < moment() - 14.days - 23.hours - 30.minutes{
            cell.aftertime.text = "もうすぐ消えます"
        } else if momentType < moment() - 14.days - 23.hours{
            cell.aftertime.text = "1時間以内に消えます"
        } else if momentType < moment() - 14.days - 18.hours{
            cell.aftertime.text = "数時間後に消えます"
        } else if momentType < moment() - 14.days - 12.hours{
            cell.aftertime.text = "半日後に消えます"
        } else if momentType < moment() - 14.days{
            cell.aftertime.text = "1日後に消えます"
        } else if momentType < moment() - 13.days{
            cell.aftertime.text = "2日後に消えます"
        } else if momentType < moment() - 12.days{
            cell.aftertime.text = "3日後に消えます"
        } else if momentType < moment() - 11.days{
            cell.aftertime.text = "4日後に消えます"
        } else if momentType < moment() - 10.days{
            cell.aftertime.text = "5日後に消えます"
        } else {
            cell.aftertime.text = ""
        }
        
//        if momentType < moment() - 5.days {
//            cell.aftertime.text = "削除済みです"
//        } else if momentType < moment() - 4.days - 23.hours - 30.minutes{
//            cell.aftertime.text = "もうすぐ消えます"
//        } else if momentType < moment() - 4.days - 23.hours{
//            cell.aftertime.text = "1時間以内に消えます"
//        } else if momentType < moment() - 4.days - 18.hours{
//            cell.aftertime.text = "数時間後に消えます"
//        } else if momentType < moment() - 4.days - 12.hours{
//            cell.aftertime.text = "半日後に消えます"
//        } else if momentType < moment() - 4.days{
//            cell.aftertime.text = "1日後に消えます"
//        } else if momentType < moment() - 3.days{
//            cell.aftertime.text = "2日後に消えます"
//        } else if momentType < moment() - 2.days{
//            cell.aftertime.text = "3日後に消えます"
//        } else if momentType < moment() - 1.days{
//            cell.aftertime.text = "4日後に消えます"
//        } else if momentType < moment(){
//            cell.aftertime.text = "5日後に消えます"
//        }
        
        
        
        let comentjiLatestdate = animals[indexPath.row].latestAt.dateValue()
        let comentjiLatestmoment = moment(comentjiLatestdate)

//        let dateformatted1 = comentjimoment.format("hh:mm")
        let dateformattedLatest = comentjiLatestmoment.format("MM/dd")
        cell.latestdateLabel.text = dateformattedLatest
        
        
        
        cell.messageCountLabel.text = String(animals[indexPath.row].messageCount)
        cell.goodCountLabel.text = String(animals[indexPath.row].GoodmanCount - 1)
        cell.viewCountLabel.text = String(animals[indexPath.row].viewCount)

        
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
        

        cell.userImageView.layer.cornerRadius = 22


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



class ShadowRankingView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale


    }
}



class ChatRankingTableViewCell: UITableViewCell {

    
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
    @IBOutlet weak var aftertime: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var rankingnumber: UILabel!
    @IBOutlet weak var backback: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var IndividualImageView: UIImageView!
    @IBOutlet weak var latestdateLabel: UILabel!
    
    
    
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

extension RankingViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}


