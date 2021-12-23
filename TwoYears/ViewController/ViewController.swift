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
    var outMemo: [OutMemo] = []
    var teamInfo : [Team] = []
    var userName: String? = "unKnown"
    var userImage: String? = ""
    let db = Firestore.firestore()
//    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    //    navigationvarのやつ
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet weak var sendImageView: UIImageView!
    
    @IBAction func tappedBubuButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storyboard = UIStoryboard.init(name: "sinkitoukou", bundle: nil)
        let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "sinkitoukou")
        self.present(sinkitoukou, animated: true, completion: nil)
        Firestore.firestore().collection("users").document(uid).setData(["nowjikan": FieldValue.serverTimestamp()], merge: true)
        //        try? Auth.auth().signOut()
    }
    
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
        if presentIndexPath.row >= outMemo.count - 6 { return }
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
        fetchFireStore(userId: uid)
//        getAlloutMemo()
        chatListTableView.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
    }

    //Pull to Refresh
    @objc func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.chatListTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func fetchFireStore(userId:String) {
        db.collection("users").document(userId).collection("TimeLine").whereField("anonymous", isEqualTo: false).whereField("userId", isEqualTo: userId).addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarabai = OutMemo(dic: dic)
                    
                    let date: Date = rarabai.createdAt.dateValue()
                    let momentType = moment(date)
                    
                    if blockList[rarabai.userId] == true {
                    } else {
                        //                        if momentType >= moment() - 14.days {
                        //                            if rarabai.admin == true {
                        //                            }
                        self.outMemo.append(rarabai)
                    }
                    self.outMemo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                case .modified, .removed:
                    print("noproblem")
                }
                self.chatListTableView.reloadData()
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
        return outMemo.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        
        let storyboard = UIStoryboard.init(name: "Reaction", bundle: nil)
        let ReactionVC = storyboard.instantiateViewController(withIdentifier: "ReactionVC") as! ReactionVC
        
        cell.messageLabel.text = outMemo[indexPath.row].message
        cell.backBack.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        let date: Date = outMemo[indexPath.row].createdAt.dateValue()
        
        print("デート！！",date)
        let momentType = moment(date)
        
        
        print(momentType)
        
        cell.flagButton.tag = indexPath.row
        cell.flagButton.addTarget(self, action: #selector(buttonEvemt), for: UIControl.Event.touchUpInside)
//        addbutton.frame = CGRect(x:0, y:0, width:50, height: 5)
                                 
        cell.userImageView.image = nil
//        cell.IndividualImageView.image = nil
        fetchUserProfile(userId: outMemo[indexPath.row].userId, cell: cell)
        
        print(cell.outMemo?.userId ?? "")
        
        let comentjidate = outMemo[indexPath.row].createdAt.dateValue()
        let comentjimoment = moment(comentjidate)
        let dateformatted2 = comentjimoment.format("MM/dd")
        let comentjiLatestdate = outMemo[indexPath.row].createdAt.dateValue()
        let comentjiLatestmoment = moment(comentjiLatestdate)
        let dateformattedLatest = comentjiLatestmoment.format("MM/dd")
                
        cell.userImageView.layer.cornerRadius = 25
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.outMemo = outMemo[indexPath.row]
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 10
        return cell
    }
    
    @objc func buttonEvemt(_ sender: UIButton){
        //アラート生成
        //UIAlertControllerのスタイルがactionSheet
        let actionSheet = UIAlertController(title: "report", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let uid = Auth.auth().currentUser?.uid
        let report = [
            "reporter": uid,
            "documentId": outMemo[sender.tag].documentId,
            "問題のコメント": outMemo[sender.tag].message,
            "問題と思われるユーザー": outMemo[sender.tag].userId,
            "createdAt": FieldValue.serverTimestamp(),
        ] as [String: Any]


        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        let action1 = UIAlertAction(title: "このユーザーを非表示にする", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            let dialog = UIAlertController(title: "本当に非表示にしますか？", message: "ブロックしたユーザーのあらゆる投稿が非表示になります。", preferredStyle: .alert)
            // 選択肢(ボタン)を2つ(OKとCancel)追加します
            //   titleには、選択肢として表示される文字列を指定します
            //   styleには、通常は「.default」、キャンセルなど操作を無効にするものは「.cancel」、削除など注意して選択すべきものは「.destructive」を指定します
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  { [self] action in
                
                if UserDefaults.standard.object(forKey: "blocked") == nil{
                    let XXX = ["XX" : true]
                    UserDefaults.standard.set(XXX, forKey: "blocked")
                }
                var blockDic:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String: Bool]
                
                print("あいえいえいいえいえ",outMemo[sender.tag].userId)
                blockDic[outMemo[sender.tag].userId] = true
                UserDefaults.standard.set(blockDic, forKey: "blocked")
//                let uid = Auth.auth().currentUser?.uid
                
                
                
                print("tapped: \([sender.tag])番目のcell")
                
                

                self.outMemo.remove(at: sender.tag)
                self.chatListTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
                self.db.collection("Report").document(self.outMemo[sender.tag].userId).collection("reported").document().setData(report, merge: true)
                self.db.collection("Report").document(self.outMemo[sender.tag].userId).setData(["reportedCount": FieldValue.increment(1.0),"createdAt":FieldValue.serverTimestamp()] as [String : Any])
            }))
            dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // 生成したダイアログを実際に表示します
            self.present(dialog, animated: true, completion: nil)
            print("このユーザーを非表示にする")
        })
        // 表示させたいタイトル2ボタンが押された時の処理をクロージャ実装する
        let action2 = UIAlertAction(title: "このユーザーを報告する", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            
            self.db.collection("Report").document(self.outMemo[sender.tag].userId).collection("reported").document().setData(report, merge: true)
            self.db.collection("Report").document(self.outMemo[sender.tag].userId).setData(["reportedCount": FieldValue.increment(1.0),"createdAt":FieldValue.serverTimestamp()] as [String : Any])
            print("このユーザーを報告する")

        })
        // 閉じるボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let close = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            print("キャンセル")
        })
        //UIAlertControllerにタイトル1ボタンとタイトル2ボタンと閉じるボタンをActionを追加
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(close)

        actionSheet.popoverPresentationController?.sourceView = self.view

        let screenSize = UIScreen.main.bounds
        actionSheet.popoverPresentationController?.sourceRect=CGRect(x:screenSize.size.width/2,y:screenSize.size.height,width:0,height:0)
        //実際にAlertを表示する
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storyboard = UIStoryboard.init(name: "Reaction", bundle: nil)
        let ReactionVC = storyboard.instantiateViewController(withIdentifier: "ReactionVC") as! ReactionVC
        
        ReactionVC.message = outMemo[indexPath.row].message
        ReactionVC.userId = outMemo[indexPath.row].userId
        
        self.present(ReactionVC, animated: true, completion: nil)

    }

    
    func fetchUserProfile(userId:String,cell:ChatListTableViewCell){

        db.collection("users").document(userId).collection("Profile").document("profile")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                let userId = document["userId"] as? String ?? "unKnown"
                userName = document["userName"] as? String ?? "unKnown"
                userImage = document["userImage"] as? String ?? ""
                
                
                cell.nameLabel.text = userName
//                getUserTeamInfo(userId: userId, cell: cell)
                
                if let url = URL(string:userImage ?? "") {
                    Nuke.loadImage(with: url, into: cell.userImageView)
                } else {
                    cell.userImageView?.image = nil
                }
            }
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

extension UIView {
    func ViewController() -> UIViewController? {
        var ChatRoomtableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomtableViewCellResponder = ChatRoomtableViewResponder?.next else { return nil }
            if let viewController = ChatRoomtableViewCellResponder as? UIViewController {
                return viewController
            }
            ChatRoomtableViewResponder = ChatRoomtableViewCellResponder
        }
    }
    func ViewController<T: UIView>(type: T.Type) -> T? {
        var ChatRoomTableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomTableViewCellResponder = ChatRoomTableViewResponder?.next else { return nil }
            if let view = ChatRoomTableViewCellResponder as? T {
                return view
            }
            ChatRoomTableViewResponder = ChatRoomTableViewCellResponder
        }
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
    
    
    let db = Firestore.firestore()
    var teamInfo : [Team] = []
    var outMemo : OutMemo?
    var indexPath : [Int] = []
    

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.backgroundColor = .clear
    }
    
    
    
    
    
    @IBOutlet weak var backBack: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
        

    @IBOutlet weak var flagButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
//
//        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
//        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
//
//        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
//
//        safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
//
//        collectionViewConstraint.constant = safeArea/4
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 0.1秒後に実行したい処理（あとで変えるこれは良くない)
            self.getUserTeamInfo(userId: self.outMemo?.userId ?? "")
        }
    }

    
    
    func fetchUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").document("teamId")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                let teamIdArray = data["teamId"] as! Array<String>
                print(teamIdArray)
                print(teamIdArray[0])
                
                teamIdArray.forEach{
                    self.getTeamInfo(teamId: $0)
                    
                }
            }
        
    }
    
    func getUserTeamInfo(userId:String){
        db.collection("users").document(userId).collection("belong_Team").document("teamId").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")

                let teamIdArray = document.data()!["teamId"] as! Array<String>
                print(teamIdArray)
                print(teamIdArray[0])
                
                print("カカかっかっっっカカかかかあいあいいあいいえいえいえおをを")

                teamIdArray.forEach{
                    self.getTeamInfo(teamId: $0)

                }

            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getTeamInfo(teamId:String){
        db.collection("Team").document(teamId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let teamDic = Team(dic: document.data()!)
                self.teamInfo.append(teamDic)
                print("翼をください！",teamId)
                print("翼をください！",document.data()!)
                print("asefiosejof",teamDic)
                
                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = outMemo?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
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

extension ChatListTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!  VCteamCollectionViewCell
        
        cell.teamImageView.clipsToBounds = true
        cell.teamImageView.layer.cornerRadius = 10
        
        if let url = URL(string: teamInfo[indexPath.row].teamImage) {
            Nuke.loadImage(with: url, into: cell.teamImageView)
        } else {
            cell.teamImageView?.image = nil
        }
        
//        getTeamInfo(teamId: outMemo?.userId ?? "")
        return cell
    }
    
}
class VCteamCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            }
}



