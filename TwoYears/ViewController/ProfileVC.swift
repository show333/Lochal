//
//  ProfileVC.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/02.
//

import UIKit
import Firebase
import GuillotineMenu
import FirebaseFirestore
import SwiftMoment
import Nuke
import DZNEmptyDataSet

class ProfileVC: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var outMemo: [OutMemo] = []
    var teamInfo : [Team] = []
    var safeArea : CGFloat = 0
    var headerHigh : CGFloat = 0
    var userId: String? = UserDefaults.standard.string(forKey:"userId") ?? "" //あとで調整する
    var userName: String? =  UserDefaults.standard.string(forKey: "userName")
    var userImage: String? = UserDefaults.standard.string(forKey: "userImage")
    var userFrontId: String? = UserDefaults.standard.string(forKey: "userFrontId")
    
    var followBool : Bool = false
    var cellImageTap : Bool = false
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    private let headerMoveHeight: CGFloat = 7
    
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var userFrontIdLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImagehighConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var headerhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headertopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var collectionHighConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionBottom: NSLayoutConstraint!
    @IBOutlet weak var collectionLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionRight: NSLayoutConstraint!
    
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followTappedButton(_ sender: Any) {
        if followBool == false {
            followButton.backgroundColor = .yellow
            followButton.setTitle("フォロー中", for: .normal)
            follow()
            followBool = true
        } else {
            followButton.backgroundColor = .gray
            followButton.setTitle("フォローする", for: .normal)
            unFollow()
            followBool = false
        }
    }
    
    
    
    @IBOutlet weak var followerButton: UIButton!
    @IBAction func followerTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Followers", bundle: nil)
        let FollowersVC = storyboard.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        navigationController?.pushViewController(FollowersVC, animated: true)
    }
    
    @IBOutlet weak var followingButton: UIButton!
    
    @IBAction func followingTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Followings", bundle: nil)
        let FollowingsVC = storyboard.instantiateViewController(withIdentifier: "FollowingsVC") as! FollowingsVC
        navigationController?.pushViewController(FollowingsVC, animated: true)
    }
    @IBOutlet weak var fButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let SettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        navigationController?.pushViewController(SettingsVC, animated: true)
    }
    
    func follow(){
        db.collection("users").document(uid ?? "").collection("Following").document("following_Id").setData([
            "userId": FieldValue.arrayUnion([userId ?? ""]) ], merge: true)
        db.collection("users").document(userId ?? "").collection("Follower").document("follower_Id").setData([
            "userId": FieldValue.arrayUnion([uid ?? ""]) ], merge: true)
        
        let docData = [
            "createdAt": FieldValue.serverTimestamp(),
            "userId": uid ?? "",
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFtontId":userFrontId ?? "",
            "documentId" : uid ?? "",
            "reactionImage": "",
            "reactionMessage":"さんがフォローしました",
            "theMessage":"",
            "anonymous":false,
            "admin": false,
        ] as [String: Any]
        
        db.collection("users").document(userId ?? "").collection("Notification").document(uid ?? "").setData(docData)
        
    }
    
    func unFollow(){
        db.collection("users").document(uid ?? "").collection("Following").document("following_Id").setData([
            "userId": FieldValue.arrayRemove([userId ?? ""]) ], merge: true)
        db.collection("users").document(userId ?? "").collection("Follower").document("follower_Id").setData([
            "userId": FieldValue.arrayRemove([uid ?? ""]) ], merge: true)
        
        db.collection("users").document(userId ?? "").collection("Notification").document(uid ?? "").delete()
        
    }
    
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        chatListTableView.register(UINib(nibName: "OutMemoCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
        
        fButtonWidthConstraint.constant = safeAreaWidth/3
        fButtonHeightConstraint.constant = safeAreaWidth/12
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followButton.clipsToBounds = true
        followButton.layer.cornerRadius = safeAreaWidth/24
        
        followingButton.titleLabel?.numberOfLines = 2
        followingButton.titleLabel?.textAlignment = NSTextAlignment.center
        followingButton.titleLabel?.baselineAdjustment = .alignCenters
        followingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followingButton.setTitle("1111", for: .normal)
        
        followerButton.titleLabel?.numberOfLines = 2
        followerButton.titleLabel?.textAlignment = NSTextAlignment.center
        followerButton.titleLabel?.baselineAdjustment = .alignCenters
        followerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followerButton.setTitle("1111", for: .normal)

        

    
        getFollowId(userId:userId ?? "",uid:uid)
        
        headerHigh = safeAreaHeight/3.5
        headerhightConstraint.constant = headerHigh
        userImageView.isUserInteractionEnabled = true
        
        userImagehighConstraint.constant = headerHigh/2
        userImageTopConstraint.constant = headerHigh/20
        userImageLeftConstraint.constant = headerHigh/20
        
        
        
        //        userImageView.image = UIImage(named:"TG1")!
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = headerHigh/4
        
        collectionHighConstraint.constant = headerHigh/4
        collectionBottom.constant = headerHigh/20
        collectionLeft.constant = headerHigh/20
        collectionRight.constant = headerHigh/20
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setSwipeBack()
        
        
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        
        //        navigationbarのやつ
        //        let navBar = self.navigationController?.navigationBar
        //        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
        
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: headerHigh/4, height: headerHigh/4)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
        
        
        teamCollectionView.reloadData()
        
        
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.emptyDataSetDelegate = self
        chatListTableView.emptyDataSetSource = self
        chatListTableView.separatorStyle = .none
        chatListTableView.backgroundColor = .clear
        //            #colorLiteral(red: 0.7238116197, green: 0.6172274334, blue: 0.5, alpha: 1)
        
        fetchFireStore(userId: userId ?? "unKnown",uid: uid)
        fetchUserProfile(userId: userId ?? "unKnown")
        fetchUserTeamInfo(userId: userId ?? "unKnown")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userId == uid {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
            followButton.alpha = 0
            settingsButton.alpha = 1
            followingButton.alpha = 1
            followerButton.alpha = 1
            followLabel.alpha = 1
            followerLabel.alpha = 1
            settingsLabel.alpha = 1
        } else {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
            followButton.alpha = 1
            settingsButton.alpha = 0
            followingButton.alpha = 0
            followerButton.alpha = 0
            followLabel.alpha = 0
            followerLabel.alpha = 0
            settingsLabel.alpha = 0
        }
    }
    
    func getFollowId(userId:String,uid:String){
        db.collection("users").document(uid).collection("Following").document("following_Id").getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let userIdArray = document["userId"] as? Array<String>
//                let userFrontId = document["userFrontId"] as? String ?? ""
                
                let userIdBool = userIdArray?.contains(userId)
                
                if userIdBool == false {
                    followBool = false
                    followButton.backgroundColor = .gray
                    followButton.setTitle("フォローする", for: .normal)
                    
                } else {
                    followBool = true
                    followButton.backgroundColor = .yellow
                    followButton.setTitle("フォロー中", for: .normal)
                    
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    //Pull to Refresh
    @objc private func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.chatListTableView.reloadData()
            self?.chatListTableView.refreshControl?.endRefreshing()
            
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
    
    private func fetchFireStore(userId:String,uid:String) {
        db.collection("users").document(userId).collection("TimeLine").whereField("anonymous", isEqualTo: false).whereField("userId", isEqualTo: userId).whereField("admin", isEqualTo: false).addSnapshotListener { [self] ( snapshots, err) in
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
                        
                        if uid == userId {
                            
                            if rarabai.delete == true {
                            } else{
                                self.outMemo.append(rarabai)
                            }
                            
                        } else {
                            if rarabai.delete == true {
                            } else{
                                if momentType >= moment() - 2.days {
                                    self.outMemo.append(rarabai)
                                }
                            }
                        }
                                
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
    
    
    func fetchUserProfile(userId:String){
        
        self.db.collection("users").document(userId).collection("Profile").document("profile")
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
                let userName = document["userName"] as? String ?? "unKnown"
                let userImage = document["userImage"] as? String ?? "unKnown"
                let userFrontId = document["userFrontId"] as? String ?? "unKnown"
                
                userFrontIdLabel.text = "ID: "+userFrontId
                userNameLabel.text = userName
                if let url = URL(string:userImage) {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView?.image = nil
                }
            }
    }
    
    func fetchUserTeamInfo(userId:String){
        
        
        self.db.collection("users").document(userId).collection("belong_Team").document("teamId")
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
                
                self.teamInfo.removeAll()
                self.teamCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    teamIdArray.forEach{
                        self.getTeamInfo(teamId: $0)
                        
                    }
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
  
                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension ProfileVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 50
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as!  profileCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        cell.backView.clipsToBounds = true
        cell.backView.layer.cornerRadius = headerHigh/16
        if let url = URL(string:teamInfo[indexPath.row].teamImage) {
            Nuke.loadImage(with: url, into: cell.teamImageView!)
        } else {
            cell.teamImageView?.image = nil
        }
        return cell
    }
    
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outMemo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OutmMemoCellVC
        
        cell.userFrontIdLabel.text = outMemo[indexPath.row].userFrontId
        cell.messageLabel.text = outMemo[indexPath.row].message
        cell.backBack.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        cell.coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

        if  outMemo[indexPath.row].readLog == true {
            cell.coverView.backgroundColor = .clear
            cell.coverViewConstraint.constant = 0
            cell.messageBottomConstraint.constant = 30
            cell.messageLabel.numberOfLines = 0
            cell.coverImageView.alpha = 0
            cell.textMaskLabel.alpha = 0
            
        } else {
            cell.coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            cell.coverViewConstraint.constant = 100
            cell.messageBottomConstraint.constant =  105
            cell.messageLabel.numberOfLines = 1
            cell.coverImageView.alpha = 0.8
            cell.textMaskLabel.alpha = 1
            
            
        }
        
        if let url = URL(string:outMemo[indexPath.row].textMask) {
            Nuke.loadImage(with: url, into: cell.coverImageView)
        } else {
            cell.coverImageView?.image = nil
        }
        
        if uid == outMemo[indexPath.row].userId {
            cell.flagButton.isHidden = true
        }
        cell.flagButton.tag = indexPath.row
        cell.flagButton.addTarget(self, action: #selector(buttonEvemt), for: UIControl.Event.touchUpInside)
        //        addbutton.frame = CGRect(x:0, y:0, width:50, height: 5)
        
        cell.userImageView.image = nil
        //        cell.IndividualImageView.image = nil
        fetchDocContents(userId: outMemo[indexPath.row].userId, cell: cell,documentId: outMemo[indexPath.row].documentId)
        
        print(cell.outMemo?.userId ?? "")
        
        let date: Date = outMemo[indexPath.row].createdAt.dateValue()
        
        cell.dateLabel.text = date.agoText()
        
        cell.userImageView.layer.cornerRadius = 30
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.outMemo = outMemo[indexPath.row]
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.chatListTableView.cellForRow(at:indexPath) as! OutmMemoCellVC
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        if outMemo[indexPath.row].readLog == true{
            
            if outMemo[indexPath.row].userId != uid {
                
                let storyboard = UIStoryboard.init(name: "Reaction", bundle: nil)
                let ReactionVC = storyboard.instantiateViewController(withIdentifier: "ReactionVC") as! ReactionVC
                
                ReactionVC.message = outMemo[indexPath.row].message
                ReactionVC.userId = outMemo[indexPath.row].userId
                self.present(ReactionVC, animated: true, completion: nil)
            } else {
                
                let storyboard = UIStoryboard.init(name: "ReadLog", bundle: nil)
                let ReadLogVC = storyboard.instantiateViewController(withIdentifier: "ReadLogVC") as! ReadLogVC
                
                ReadLogVC.documentId=outMemo[indexPath.row].documentId
                
                self.present(ReadLogVC, animated: true, completion: nil)
            }
            
        } else {
            let readLogDic = [
                "userId":uid,
                "userName":userName ?? "unKnown",
                "userImage":userImage ?? "",
                "userFrontId":userFrontId ?? "unKnown",
                "createdAt": FieldValue.serverTimestamp(),
            ] as [String:Any]
            
            outMemo[indexPath.row].readLog = true
            db.collection("users").document(uid).collection("TimeLine").document(outMemo[indexPath.row].documentId).setData(["readLog":true],merge: true)
            db.collection("users").document(outMemo[indexPath.row].userId).collection("MyPost").document(outMemo[indexPath.row].documentId).collection("Readlog").document(uid).setData(readLogDic)
            cell.coverView.backgroundColor = .clear
            cell.coverImageView.alpha = 0
            cell.textMaskLabel.alpha = 0
            cell.messageLabel.numberOfLines = 0
            
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
            
        }
        
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
    
    
    func fetchDocContents(userId:String,cell:OutmMemoCellVC,documentId:String){
        
        db.collection("users").document(userId).collection("MyPost").document(documentId)
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                //                print("Current data: \(data)")
                //                let userId = document["userId"] as? String ?? "unKnown"
                //                userName = document["userName"] as? String ?? "unKnown"
                let userImage = document["userImage"] as? String ?? ""
                let userFrontId = document["userFrontId"] as? String ?? ""
                //                let message = document["message"] as? String ?? ""
                let delete = document["delete"] as! Bool
                
                print("デリート！！！",delete)
                
                if delete == true {
                    cell.messageLabel.text = "この投稿は削除されました"
                    db.collection("users").document(uid ?? "").collection("TimeLine").document(documentId).setData(["delete":true],merge: true)
                } else {
                    //                    cell.messageLabel.text = message
                }
                
                cell.userFrontIdLabel.text = userFrontId
                
                
                //                cell.nameLabel.text = userName
                //                getUserTeamInfo(userId: userId, cell: cell)
                
                if let url = URL(string:userImage) {
                    Nuke.loadImage(with: url, into: cell.userImageView)
                } else {
                    cell.userImageView?.image = nil
                }
            }
    }
}


class profileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
