//
//  ProfileVC.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/02.
//

import UIKit
import Firebase
import GuillotineMenu
import FirebaseAuth
import FirebaseFirestore

import SwiftMoment
import Nuke
import DZNEmptyDataSet
import ImageViewer
import Instructions

class ProfileVC: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    var outMemo: [OutMemo] = []
    var teamInfo : [Team] = []
    var galleyItem: GalleryItem!
    var postInfo: [PostInfo] = []
    var statusChain : String?
    
    var safeArea : CGFloat = 0
    var headerHigh : CGFloat = 0
    var userId: String? = UserDefaults.standard.string(forKey:"userId") ?? "" //あとで調整する
    var userName: String? =  UserDefaults.standard.string(forKey: "userName")
    var userImage: String? = UserDefaults.standard.string(forKey: "userImage")
    var userFrontId: String? = UserDefaults.standard.string(forKey: "userFrontId")
    var dismissBool: Bool = false
    var matchUserId:[String] = []
    var areaName:String?
    
    
    var cellImageTap : Bool = false
    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    let coachMarksController = CoachMarksController()
    let coachMarksControllerSecond = CoachMarksController()
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    private let headerMoveHeight: CGFloat = 7
    
    
    @IBOutlet weak var postCompleteLabel: UILabel!
    @IBOutlet weak var secondPostCompleteLabel: UILabel!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImagehighConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfIntroductionLabel: UILabel!
    
    @IBOutlet weak var matchUserLabel: UILabel!
    
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBAction func matchUserTapGesture(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Connection", bundle: nil)
        let ConnectionVC = storyboard.instantiateViewController(withIdentifier: "ConnectionVC") as! ConnectionVC
        ConnectionVC.matchUserId = self.matchUserId
        navigationController?.pushViewController(ConnectionVC, animated: true)
    }
    
    //    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    
    
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var headerhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headertopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var collectionHighConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionBottom: NSLayoutConstraint!
    @IBOutlet weak var collectionLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionRight: NSLayoutConstraint!
    
    
    @IBOutlet weak var explainButton: UIButton!
    
    
    @IBAction func explainTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
        let ExplainVC = storyboard.instantiateViewController(withIdentifier: "ExplainVC") as! ExplainVC
        
        //        CollectionPostVC.postDocString = userId
        self.present(ExplainVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var postBackGroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postBackGroundWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var postBackGroundView: UIView!
    
    @IBOutlet weak var postBackImageView: UIImageView!
    @IBOutlet weak var postOtherLabel: UILabel!
    
    @IBAction func postTappedButton(_ sender: Any) {
        
        if statusChain == "accept" {
            let storyboard = UIStoryboard.init(name: "CollectionPost", bundle: nil)
            let CollectionPostVC = storyboard.instantiateViewController(withIdentifier: "CollectionPostVC") as! CollectionPostVC
            CollectionPostVC.presentationController?.delegate = self
            CollectionPostVC.postDocString = userId
            self.present(CollectionPostVC, animated: true, completion: nil)
            
        } else if uid == userId{
            let storyboard = UIStoryboard.init(name: "CollectionPost", bundle: nil)
            let CollectionPostVC = storyboard.instantiateViewController(withIdentifier: "CollectionPostVC") as! CollectionPostVC
            CollectionPostVC.presentationController?.delegate = self
            CollectionPostVC.postDocString = userId
            self.present(CollectionPostVC, animated: true, completion: nil)
        } else {
            postAlert()
        }
        
    }
    
    @IBOutlet weak var rakugakiLabel: UILabel!
    @IBOutlet weak var chainCountLabel: UILabel!
    
    
    @IBOutlet weak var transitionChainButton: UIButton!
    
    @IBAction func transitionTappedChainButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Connection", bundle: nil)
        let ConnectionVC = storyboard.instantiateViewController(withIdentifier: "ConnectionVC") as! ConnectionVC
        ConnectionVC.userId = userId
        navigationController?.pushViewController(ConnectionVC, animated: true)
    }
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followTappedButton(_ sender: Any) {
        
        
        db.collection("users").document(uid ?? "").collection("Connections").document(userId ?? "").getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                
                statusChain = document["status"] as? String ?? ""
                
                
                if statusChain == "sendRequest" {
                    followButton.setTitle("コネクトする", for: .normal)
                    followButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
                    followButton.setTitleColor(UIColor.darkGray, for: .normal)
                    unChain()
                    statusChain = ""
                    
                } else if statusChain == "accept" {
                    confirmationAlert()
                } else if statusChain == "gotRequest" {
                    
                    followButton.backgroundColor = .darkGray
                    followButton.setTitle("コネクト中", for: .normal)
                    followButton.setTitleColor(UIColor.white, for: .normal)
                    followButton.setTitleColor(UIColor{_ in return #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)}, for: .normal)
                    doChain()
                    postBackGroundView.alpha = 1
                    postOtherLabel.alpha = 0
                    statusChain = "accept"
                }
                
            } else {
                print("Document does not exist")
                
                followButton.backgroundColor = .darkGray
                followButton.setTitle("リクエスト済み", for: .normal)
                followButton.setTitleColor(UIColor.white, for: .normal)
                chainRequest()
                statusChain = "sendRequest"
                
            }
        }
    }
    
    
    
    
    
    
    @IBOutlet weak var connectLabel: UILabel!
    
    
    @IBOutlet weak var fButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let SettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        navigationController?.pushViewController(SettingsVC, animated: true)
    }
    
    func postAlert() {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "コネクトしてください", message: "コネクト(相互フォロー)後に\nラクガキ投稿が可能になります", preferredStyle: .alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        // キャンセルボタン
        
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func confirmationAlert() {
        let alert = UIAlertController(title: "コネクト解除", message: "コネクトを解除してもよろしいですか？", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "解除", style: .default, handler: { [self] (action) -> Void in
            print("Delete button tapped")
            
            followButton.setTitle("コネクトする", for: .normal)
            followButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            followButton.setTitleColor(UIColor.darkGray, for: .normal)
            unChain()
            db.collection("users").document(uid ?? "").setData(["ConnectionsCount": FieldValue.increment(-1.0)], merge: true)
            db.collection("users").document(userId ?? "").setData(["ConnectionsCount": FieldValue.increment(-1.0)], merge: true)
            statusChain = ""
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func doChain(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = userId else {return}
        
        db.collection("users").document(userId).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0
                let acceptNotification = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": uid,
                    "userName":userName ?? "",
                    "userImage":userImage ?? "",
                    "userFrontId":userFrontId ?? "",
                    "documentId" : "Connecting" + uid,
                    "reactionImage": "",
                    "reactionMessage":"さんとコネクトしました",
                    "theMessage": "",
                    "notificationNum":notificationNum+1,
                    "dataType": "accepted",
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                db.collection("users").document(userId).collection("Notification").document("Connecting"+uid).setData(acceptNotification, merge: true)
                db.collection("users").document(userId).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
        
        
        db.collection("users").document(uid).collection("Notification").document("Connecting\(userId)").setData(["reactionMessage":"さんとコネクトしました","acceptBool":true], merge: true)
        db.collection("users").document(userId).collection("Connections").document(uid).setData(["status":"accept"], merge: true)
        db.collection("users").document(uid).collection("Connections").document(userId).setData(["status":"accept"], merge: true)
        db.collection("users").document(userId).setData(["ConnectionsCount": FieldValue.increment(1.0)], merge: true)
        db.collection("users").document(uid).setData(["ConnectionsCount": FieldValue.increment(1.0)], merge: true)
        PostGet(uid:uid,userId:userId)
        PostGet(uid:userId,userId:uid)
        
        
        
    }
    
    func chainRequest(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = userId else {return}
        
        db.collection("users").document(uid).collection("Connections").document(userId).setData(["createdAt": FieldValue.serverTimestamp(),"userId":userId,"status":"sendRequest"], merge: true)
        
        db.collection("users").document(userId).collection("Connections").document(uid).setData(["createdAt": FieldValue.serverTimestamp(),"userId":uid ,"status":"gotRequest"], merge: true)
        
        
        
        db.collection("users").document(userId).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0
                let docData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": uid,
                    "userName":UserDefaults.standard.string(forKey: "userName") ?? "unKnown",
                    "userImage":UserDefaults.standard.string(forKey: "userImage") ?? "unKnown",
                    "userFrontId":UserDefaults.standard.string(forKey: "userFrontId") ?? "unKnown",
                    "documentId" : "Chaining"+uid,
                    "reactionImage": "",
                    "reactionMessage":"さんからコネクト申請です",
                    "theMessage":"",
                    "dataType": "acceptingConnect",
                    "notificationNum":notificationNum+1,
                    "acceptBool":false,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                
                db.collection("users").document(userId).collection("Notification").document("Connecting"+uid).setData(docData)
                db.collection("users").document(userId).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func unChain(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("Connections").document(userId ?? "").delete()
        db.collection("users").document(userId ?? "").collection("Connections").document(uid).delete()
        db.collection("users").document(userId ?? "").collection("Notification").document("Connecting"+uid).delete()
    }
    
    
    func PostGet(uid:String,userId:String){
        db.collection("users").document(uid).collection("MyPost").whereField("anonymous", isEqualTo: false).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        
                        print("\(document.documentID) => \(document.data())")
                        let dic = document.data()
                        let outMemoDic = OutMemo(dic: dic)
                        PostSet(userId:userId ,outMemo: outMemoDic)
                    }
                }
            }
        }
        
    }
    
    func PostSet(userId:String,outMemo:OutMemo){
        
        let memoInfoDic = [
            "message" : outMemo.message,
            "sendImageURL": outMemo.sendImageURL,
            "documentId": outMemo.documentId,
            "createdAt": outMemo.createdAt,
            "textMask":outMemo.textMask,
            "userId":outMemo.userId,
            "userName":outMemo.userName,
            "userFrontId":outMemo.userFrontId,
            "readLog": false,
            "anonymous":outMemo.anonymous,
            "admin": outMemo.admin,
            "delete": outMemo.delete,
            
        ] as [String: Any]
        
        db.collection("users").document(userId).collection("TimeLine").document(outMemo.documentId).setData(memoInfoDic,merge: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let safeAreaWidth = UIScreen.main.bounds.size.width
        let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
        
        postCollectionView.emptyDataSetDelegate = self
        postCollectionView.emptyDataSetSource = self
        
        postButton.alpha = 0.8
        
        connectLabel.font = UIFont(name:"03SmartFontUI", size:12)
        settingsLabel.font = UIFont(name:"03SmartFontUI", size:12)
        postOtherLabel.font = UIFont(name:"03SmartFontUI", size:14)
        rakugakiLabel.font = UIFont(name:"03SmartFontUI", size:17)
        
        followButton.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 17)
        areaNameLabel.font = UIFont(name: "03SmartFontUI", size: 14)
        
        backGroundImageView.alpha = 0.1
        headerView.alpha = 1
        postCollectionView.alpha = 1
        
        
        postCompleteLabel.alpha = 0
        postCompleteLabel.font =  UIFont(name:"03SmartFontUI", size:safeAreaWidth/20)
        postCompleteLabel.text = "ラクがきを送信しました！"
        
        secondPostCompleteLabel.alpha = 0
        secondPostCompleteLabel.font =  UIFont(name:"03SmartFontUI", size:safeAreaWidth/25)
        secondPostCompleteLabel.text = "相手の許可を得た後,公開されます"
        
        
        self.coachMarksController.dataSource = self
        self.coachMarksControllerSecond.dataSource = self
        
        postBackGroundView.clipsToBounds = true
        postBackGroundView.layer.cornerRadius = 10
        postBackGroundView.layer.masksToBounds = false
        postBackGroundView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        postBackGroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        postBackGroundView.layer.shadowOpacity = 0.7
        postBackGroundView.layer.shadowRadius = 5
        
        
        postButton.layer.cornerRadius = 30
        postButton.clipsToBounds = true
        postButton.layer.masksToBounds = false
        postButton.layer.shadowColor = UIColor.black.cgColor
        postButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        postButton.layer.shadowOpacity = 1
        postButton.layer.shadowRadius = 5
        
        
        postBackImageView.clipsToBounds = true
        postBackImageView.layer.cornerRadius = 10
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FfollowsPostImages.png?alt=media&token=bb9320cc-e79e-4f28-a23a-5573da02b5f3") {
            Nuke.loadImage(with: url, into: postBackImageView)
        } else {
            postBackImageView.image = nil
        }
        
        
        
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followButton.clipsToBounds = true
        followButton.layer.cornerRadius = safeAreaWidth/24
        
        if let layout = postCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        headerHigh = safeAreaHeight/3.5
        
        userImageView.isUserInteractionEnabled = true
        
        userNameLabelTopConstraint.constant = headerHigh/5 - 15
        userImagehighConstraint.constant = headerHigh/2.5
        userImageTopConstraint.constant = headerHigh/20
        userImageLeftConstraint.constant = headerHigh/18
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = headerHigh/5
        
        collectionHighConstraint.constant = headerHigh/4
        collectionBottom.constant = headerHigh/20
        collectionLeft.constant = headerHigh/20
        collectionRight.constant = headerHigh/20
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
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
        
        
        //Pull To Refresh
        postCollectionView.refreshControl = UIRefreshControl()
        postCollectionView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
        
        
        fetchNotification(userId:uid)
        if userId == "" {
            fetchUserProfile(userId: uid)
            fetchPostInfo(userId: uid)
        } else {
            fetchUserProfile(userId: userId ?? "unKnown")
            fetchPostInfo(userId: userId ?? "unKnown")
        }
        self.postCollectionView.reloadData()
    }
    
    //Pull to Refresh
    @objc func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.postInfo.removeAll()
            self?.postCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒後に実行したい処理
                self?.fetchPostInfo(userId: self?.userId ?? "unKnown")
            }
            
            self?.postCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        getFollowId(userId:userId ?? "",uid:uid)
        
        let customLayout = PinterestLayout()
        customLayout.delegate = self
        postCollectionView.collectionViewLayout = customLayout
        
        if let pinterestLayout = postCollectionView.collectionViewLayout as? PinterestLayout {
            pinterestLayout.delegate = self
        }
        
        
        //        ここを変える
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
        let safeAreaWidth = UIScreen.main.bounds.size.width
        headerHigh = safeAreaHeight/3.5
        headerhightConstraint.constant = headerHigh/1.5
        
        
        if cellImageTap == true {
            setSwipeBack()
        }
        
        if userId == uid {
            
            headerhightConstraint.constant = headerHigh/1.5
            followButton.alpha = 0
            settingsButton.alpha = 1
            settingsLabel.alpha = 1
        } else {
            headerhightConstraint.constant = headerHigh
            postBackGroundHeightConstraint.constant = headerHigh/4
            postBackGroundWidthConstraint.constant = safeAreaWidth/2.8
            
            fButtonHeightConstraint.constant = headerHigh/5
            fButtonWidthConstraint.constant = safeAreaWidth/2.8
            
            followButton.alpha = 1
            settingsButton.alpha = 0
            settingsLabel.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if userId == uid {
            self.tabBarController?.tabBar.isHidden = false
            followButton.alpha = 0
            settingsButton.alpha = 1
            settingsLabel.alpha = 1
        } else {
            
            
            self.tabBarController?.tabBar.isHidden = false
            followButton.alpha = 1
            settingsButton.alpha = 0
            settingsLabel.alpha = 0
        }
        
        if UserDefaults.standard.bool(forKey: "ProfileInstract") != true{
            UserDefaults.standard.set(true, forKey: "ProfileInstract")
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
    }
    
    func fetchPostInfo(userId:String){
        
        db.collection("users").document(userId).collection("SendedPost").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let sendedPostInfoDic = PostInfo(dic: dic)
                    
                    if sendedPostInfoDic.releaseBool != false {
                        self.postInfo.append(sendedPostInfoDic)
                    } else {
                        
                    }
                    
                    self.postInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    
                case .modified, .removed:
                    print("noproblem")
                }
            })
            postCollectionView.reloadData()
        }
    }
    
    func getFollowId(userId:String,uid:String){
        var sendArray : Array<String>? = []
        var gotArray : Array<String>? = []
        var acceptArray : Array<String>? = []
        db.collection("users").document(uid).collection("Connections").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let status = document.data()["status"] as? String ?? ""
                    let getUserId = document.data()["userId"] as? String ?? ""
                    
                    if status == "sendRequest"{
                        sendArray?.append(getUserId)
                    }else if status == "gotRequest"{
                        gotArray?.append(getUserId)
                    }else if status == "accept"{
                        acceptArray?.append(getUserId)
                    } 
                }
                let sendBool = sendArray?.contains(userId)
                let gotBool = gotArray?.contains(userId)
                let acceptBool = acceptArray?.contains(userId)
                
                
                
                
                if sendBool == true {
                    statusChain = "sendRequest"
                    followButton.backgroundColor = .darkGray
                    followButton.setTitle("リクエスト済み", for: .normal)
                    followButton.setTitleColor(UIColor.white, for: .normal)
                    postOtherLabel.alpha = 1
                    postBackGroundView.alpha = 0
                    postOtherLabel.text = "相手のコネクト待ちです\n少々お待ちください"
                    
                    
                } else if gotBool == true {
                    statusChain = "gotRequest"
                    followButton.backgroundColor = .darkGray
                    followButton.setTitle("コネクトする", for: .normal)
                    followButton.setTitleColor(UIColor{_ in return #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)}, for: .normal)
                    postOtherLabel.text = "申請を受けています\n←タップでコネクトをします"
                    
                    if uid == userId {
                        postOtherLabel.alpha = 0
                    } else {
                        postOtherLabel.alpha = 1
                    }
                    
                    
                    
                } else if acceptBool == true {
                    statusChain = "accept"
                    followButton.backgroundColor = .darkGray
                    followButton.setTitle("コネクト中", for: .normal)
                    followButton.setTitleColor(UIColor{_ in return #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)}, for: .normal)
                    postOtherLabel.alpha = 1
                    postBackGroundView.alpha = 0
                    
                    postOtherLabel.text = "画面右下のボタンから\nラクがき投稿ができます"
                    
                }else {
                    followButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
                    followButton.setTitle("コネクトする", for: .normal)
                    followButton.setTitleColor(UIColor.darkGray, for: .normal)
                    postBackGroundView.alpha = 0
                    postOtherLabel.text = "←のボタンから\nコネクトを申請します"
                    
                    if uid == userId {
                        postOtherLabel.alpha = 0
                    } else {
                        postOtherLabel.alpha = 1
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "ラクがきを受けてみよう！")
    }
    
    
    func fetchUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let teamInfoDic = Team(dic: dic)
                    
                    self.teamInfo.append(teamInfoDic)
                    self.teamInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                case .modified, .removed:
                    print("noproblem")
                }
            })
            self.teamCollectionView.reloadData()
            postCollectionView.reloadData()
            
        }
    }
    
    func fetchNotification(userId:String){
        
        db.collection("users").document(userId).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            let notificationNum = data["notificationNum"] as? Int ?? 0
            let messageNum = data["messageNum"] as? Int ?? 0
            
            print(notificationNum)
            
            if notificationNum >= 1 {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = String(notificationNum)
            } else {
            }
            
            
            if messageNum >= 1 {
                self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = String(messageNum)
                
            } else {
            }
        }
    }
    
    
    func fetchUserProfile(userId:String){
        
        self.db.collection("users").document(userId).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            
            let backGroundString = "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/backGroound%2Fsplashbackground.jpeg?alt=media&token=4c2fd869-a146-4182-83aa-47dd396f1ad6"
            
            let userName = document["userName"] as? String ?? "unKnown"
            let userImage = document["userImage"] as? String ?? "unKnown"
            let userFrontId = document["userFrontId"] as? String ?? "unKnown"
            let userBackGround = document["userBackGround"] as? String ?? backGroundString
            let Prefectures = document["areaNameJa"] as? String ?? ""
            let PrefecturesEn = document["areaNameEn"] as? String ?? ""
            let kantoArray =  ["saitama","chiba","tokyo","kanagawa"]
            areaName = PrefecturesEn
            if kantoArray.contains(PrefecturesEn) == true {
                
                areaNameLabel.isUserInteractionEnabled = true
                areaNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(areaNameLabelTapped(_:))))
                
            }
            
            
            let areaBlock = document["areaBlock"] as? String ?? ""
            if areaBlock != "" {
                let areaBlockPlus = areaBlock+"エリア"
                areaNameLabel.text = Prefectures+areaBlockPlus
            } else {
                areaNameLabel.text = Prefectures+areaBlock
            }
            
            let connectingUserId = document["connectingUserId"] as? [String] ?? []
                        
            let selfConnectingUserId:[String] = UserDefaults.standard.array(forKey: "connectingUserId") as? [String] ?? [""]
            
            
            let myUsersCount = selfConnectingUserId.count
            let friendUsersCount = connectingUserId.count
            
            
            
            matchUserId.removeAll()
            
            
            if friendUsersCount <= myUsersCount {
                selfConnectingUserId.forEach{
                    print("せfせ",$0)
                    if connectingUserId.contains($0) == true {
                        print("いえいえいえいえ",$0)
                        matchUserId.append($0)
                    }
                    if userId != uid {
                        
                        if matchUserId.count > 0 {
                            matchUserLabel.isUserInteractionEnabled = true
                            matchUserLabel.text = String(matchUserId.count) + "人の共通の友達がいます"
                        } else {
                            matchUserLabel.isUserInteractionEnabled = false
                            matchUserLabel.text = ""
                        }
                    }
                }
                
            } else {
                connectingUserId.forEach{
                    if selfConnectingUserId.contains($0) == true {
                        matchUserId.append($0)
                    }
                    if userId != uid {
                        
                        if matchUserId.count > 0 {
                            matchUserLabel.isUserInteractionEnabled = true
                            matchUserLabel.text = String(matchUserId.count) + "人の共通の友達がいます"
                        } else {
                            matchUserLabel.isUserInteractionEnabled = false
                            matchUserLabel.text = ""
                        }
                    }
                }
            }
            let ConnectionsCount = document["ConnectionsCount"] as? Int ?? 0
            chainCountLabel.text = String(ConnectionsCount)
            
            let image:UIImage = UIImage(url: userImage)
            galleyItem = GalleryItem.image{ $0(image) }
            
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(didTap(_:)))
            userImageView.addGestureRecognizer(tapGesture)
            userImageView.isUserInteractionEnabled = true
            
            
            navigationItem.title = userFrontId
            selfIntroductionLabel.text = ""
            userNameLabel.text = userName
            if let url = URL(string:userImage) {
                Nuke.loadImage(with: url, into: userImageView)
            } else {
                userImageView?.image = nil
            }
            
            if let url = URL(string:userBackGround) {
                Nuke.loadImage(with: url, into: backGroundImageView)
            } else {
                backGroundImageView?.image = nil
            }
        }
    }
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
        presentImageGallery(viewController)
    }
    @objc func areaNameLabelTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "AreaExplain", bundle: nil)
        let AreaExplainVC = storyboard.instantiateViewController(withIdentifier: "AreaExplainVC") as! AreaExplainVC
        AreaExplainVC.areaName = areaName
        self.present(AreaExplainVC, animated: true, completion: nil)
        
    }
    
}

extension ProfileVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PinterestLayoutDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.teamCollectionView {
            return teamInfo.count
        }
        
        return postInfo.count
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.teamCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as!  profileCollectionViewCell
            cell.backView.clipsToBounds = true
            cell.backView.layer.cornerRadius = headerHigh/16
            if let url = URL(string:teamInfo[indexPath.row].teamImage) {
                Nuke.loadImage(with: url, into: cell.teamImageView!)
            } else {
                cell.teamImageView?.image = nil
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as!  postCollectionViewCell
            
            let safeAreaWidth = UIScreen.main.bounds.size.width
            
            cell.postImageView.image = nil
            
            print(postInfo[indexPath.row])
            
            cell.postImageView.alpha = 0
            let storyboard = UIStoryboard.init(name: "FontCollection", bundle: nil)
            
            let FontCollectionVC = storyboard.instantiateViewController(withIdentifier: "FontCollectionVC") as! FontCollectionVC
            
            let fontName = postInfo[indexPath.row].textFontName
            let hexColor = postInfo[indexPath.row].hexColor
            let titleComment = postInfo[indexPath.row].titleComment
            
            let fontBool = FontCollectionVC.fontArray.contains(fontName)
            
            if fontBool == false {
                cell.collectionPostLabel.font = UIFont(name:"Southpaw", size:safeAreaWidth/10)
            } else {
                cell.collectionPostLabel.font = UIFont(name:fontName, size:safeAreaWidth/10)
            }
            
            if hexColor == "" {
                cell.collectionPostLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            } else {
                let UITextColor = UIColor(hex: hexColor)
                cell.collectionPostLabel.textColor = UITextColor
            }
            
            
            
            cell.collectionPostLabel.text = postInfo[indexPath.row].titleComment
            let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
            cell.collectionPostLabel.transform = transScale
            
            
            if postInfo[indexPath.row].postImage != "" {
                cell.collectionPostLabel.alpha = 0
                cell.postImageView.alpha = 1
                if let url = URL(string:postInfo[indexPath.row].postImage) {
                    Nuke.loadImage(with: url, into: cell.postImageView!)
                } else {
                    cell.postImageView?.image = nil
                }
            } else {
                cell.postImageView.alpha = 0
                cell.collectionPostLabel.alpha = 1
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.teamCollectionView {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
            let storyboard = UIStoryboard.init(name: "UnitHome", bundle: nil)
            let UnitHomeVC = storyboard.instantiateViewController(withIdentifier: "UnitHomeVC") as! UnitHomeVC
            UnitHomeVC.teamInfo = teamInfo[indexPath.row]
            navigationController?.pushViewController(UnitHomeVC, animated: true)
        } else {
            //        self.tabBarController?.tabBar.isHidden = true
            let storyboard = UIStoryboard.init(name: "detailPost", bundle: nil)
            let detailPostVC = storyboard.instantiateViewController(withIdentifier: "detailPostVC") as! detailPostVC
            self.navigationController?.navigationBar.isHidden = false
            //        detailPostVC.navigationController?.navigationBar.isHidden = false
            detailPostVC.profileUserId = userId
            detailPostVC.postUserId = postInfo[indexPath.row].userId
            detailPostVC.postInfoTitle = postInfo[indexPath.row].titleComment
            detailPostVC.postInfoImage = postInfo[indexPath.row].postImage
            detailPostVC.postInfoDoc = postInfo[indexPath.row].documentId
            detailPostVC.postHexColor = postInfo[indexPath.row].hexColor
            detailPostVC.postTextFontName = postInfo[indexPath.row].textFontName
            detailPostVC.imageAddress = postInfo[indexPath.row].imageAddress
            navigationController?.pushViewController(detailPostVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let postImage = postInfo[indexPath.row].postImage
        let titleCount = postInfo[indexPath.row].titleComment.count
        
        
        
        
        let cellSize : CGFloat = self.view.bounds.width / 3 * 2 - 12
        
        if postImage == "" {
            if titleCount < 6 {
                return cellSize/3
            } else if titleCount < 10 {
                return cellSize/2.7
            } else if titleCount < 15 {
                return cellSize/2.5
            } else if titleCount < 20 {
                return cellSize/2.2
            } else if titleCount < 25 {
                return cellSize/2
            } else {
                return cellSize/1.5
            }
        } else {
            if indexPath.row % 2 == 1 {
                return cellSize/1.5
            } else {
                return cellSize/1.2
            }
        }
        
    }
    
}

//MARK: Instructions

extension ProfileVC: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [postButton,transitionChainButton]
        
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "ここでラクがき投稿を\n行うことができます!"
            coachViews.bodyView.nextLabel.text = "次へ"
            
        case 1:
            coachViews.bodyView.hintLabel.text = "ここから他のユーザーを\n見ることができます"
            coachViews.bodyView.nextLabel.text = "OK"
            
            
            
        default:
            break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

class profileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ProfileVC: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.userImageView.image!) }
    }
}

// MARK: GalleryDisplacedViewsDataSource
extension ProfileVC: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return userImageView
    }
}

class postCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var collectionPostLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        
        self.layer.borderWidth = 6
        
        self.layer.borderColor = UIColor.clear.cgColor
        
        // cellを丸くする
        self.layer.cornerRadius = safeAreaWidth/18
    }
}
extension ProfileVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        if dismissBool != false {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            
            UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
                self.postCompleteLabel.alpha = 1
                self.secondPostCompleteLabel.alpha = 1
                let ConstraintCGfloat:CGFloat = 85
                self.postCompleteLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
                self.secondPostCompleteLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.5, delay: 2.5, animations: {
                    self.postCompleteLabel.alpha = 0
                    self.secondPostCompleteLabel.alpha = 0
                    let ConstraintCGfloat:CGFloat = 85
                    self.postCompleteLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                    self.secondPostCompleteLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                })
            }
        }
    }
}
