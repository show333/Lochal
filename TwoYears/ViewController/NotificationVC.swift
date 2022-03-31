//
//  NotificationVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class NotificationVC: UIViewController {
    
    var reaction : [Reaction] = []
    var outMemo: OutMemo?
    var reactionSelected: Reaction?
    var notificationTab:Bool = false
    var userId : String?
    var cellDocumentId : String?
    var releaseBool:Bool = false
    var userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String
    var userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String
    var userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String
    private let cellId = "cellId"
    
    let db = Firestore.firestore()
    let textMask : Array = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth1.001.png?alt=media&token=bae3c928-485e-464f-ac00-35a97e03d681",//1
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth2.001.png?alt=media&token=8dab1e72-f1d7-4636-b203-37085b6a1a02",//2
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth3.001.png?alt=media&token=453af75e-4578-4fbd-abe7-cc0686a694ee",//3
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth4.001.png?alt=media&token=ffe5efc4-af99-423f-85e9-943c7ed00674",//4
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth5.001.png?alt=media&token=79a71066-96fb-42d0-a6b9-88a9edaea762",//5
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth6.001.png?alt=media&token=0a7254d8-01fd-4db0-82dd-573caecd3be7",//6
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth7.001.png?alt=media&token=6ec61c57-c5f2-4182-b81f-1c94e5830c01",//7
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth8.001.png?alt=media&token=894a2dc4-c3c8-4fe3-94c9-632a76921ad4",//8
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth10.001.png?alt=media&token=bc4d5271-11b0-499b-ad1e-88788329d417",//10
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth12.001.png?alt=media&token=5dd3e8a6-d265-4b1c-92ca-7de64c549de4",//12
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth13.001.png?alt=media&token=a875740c-c522-4087-8b7e-1e4d03ee392c",//13
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth14.001.png?alt=media&token=b73e6cb2-63f7-419a-bca9-4e79255c8cdf",//14
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth15.001.png?alt=media&token=46d8f2b2-feaa-4c38-ad5b-cd7924cf88f7",//15
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth16.001.png?alt=media&token=c5a3ea4a-59aa-41b4-9726-5453e19eca59",//16
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth17.001.png?alt=media&token=486ad9c8-f4ac-441f-ab70-b43feff85d99",//17
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth18.001.png?alt=media&token=b4a4525b-38ee-4842-a191-3fb49ec3b8e0",//18
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth20.001.png?alt=media&token=e0693059-4e99-4378-a5cf-1b19854f30e0",//20
    ]
    
    @IBOutlet weak var postBackView: UIView!
    
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var graffitiBackView: UIView!
    
    @IBOutlet weak var graffitiImageView: UIImageView!
    
    @IBOutlet weak var graffitiImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiLabel: UILabel!
    @IBOutlet weak var graffitiTitleLabel: UILabel!
    @IBOutlet weak var postUserImageView: UIImageView!
    @IBOutlet weak var postUserLabel: UILabel!
    
    @IBOutlet weak var postExplainLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var postBackButton: UIButton!
    
    @IBAction func postBackTappedButton(_ sender: Any) {
        postBackView.alpha = 0
        print("eiisei")
    }
    
    @IBAction func postFrontTappedButton(_ sender: Any) {
        postBackView.alpha = 0
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if releaseBool == false {
            release(uid:uid)
            sendMemoFireStore(uid:uid)
            reaction.removeAll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchReaction(userId:uid)
            }
        } else {
        }
    }
    
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var reactionBackButton: UIButton!
    
    @IBAction func reactionTappedButton(_ sender: Any) {
        onUserImageView.alpha = 0
        onUserNameLabel.alpha = 0
        onReactionView.alpha = 0
        onMessageBackView.alpha = 0
        onMessageLabel.alpha = 0
        reactionBackButton.alpha = 0
        onCloseLabel.alpha = 0
    }
    
    @IBOutlet weak var acceptImageView: UIImageView!
    
    @IBOutlet weak var acceptImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptedImageView: UIImageView!

    @IBOutlet weak var acceptedImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptingBackButton: UIButton!
    @IBAction func acceptingBackTappedButton(_ sender: Any) {
        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        requestLabel.alpha = 0
    }
    @IBOutlet weak var acceptingButton: UIButton!
    
    @IBAction func acceptingTappedButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        followSet(uid: uid)
        MyPostGet(uid: uid)
        
        
        reaction.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.fetchReaction(userId:uid)

        }
        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        requestLabel.alpha = 0
    }
    
    func followSet(uid:String){
        
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
                    "documentId" : "Connecting"+uid,
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
        
    }
    
    func MyPostGet(uid:String){
        db.collection("users").document(uid).collection("MyPost").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                    
                        print("\(document.documentID) => \(document.data())")
                        let dic = document.data()
                        let outMemoDic = OutMemo(dic: dic)
                        
                        MyPostSet(userId:userId ?? "",outMemo: outMemoDic)
                    }
                }
            }
        }
    }
    func MyPostSet(userId:String,outMemo:OutMemo){
        
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
//        let userId = document.data()["userId"] as! String
//                        getUserInfo(userId: userId)
    }
    
    func release(uid:String) {
        guard let userId = userId else {return}
        db.collection("users").document(uid).collection("SendedPost").document(cellDocumentId ?? "").setData(["releaseBool":true], merge: true)
        
        db.collection("users").document(uid).collection("Notification").document(cellDocumentId ?? "").setData(["releaseBool":true,"reactionMessage":"さんからの投稿を公開しました"], merge: true)
 
        
        
        
        db.collection("users").document(userId).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0
                
                
                let documentId = randomString(length: 20)
                let docData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": uid,
                    "userName":UserDefaults.standard.string(forKey: "userName") ?? "unKnown",
                    "userImage":UserDefaults.standard.string(forKey: "userImage") ?? "unKnown",
                    "userFrontId":UserDefaults.standard.string(forKey: "userFrontId") ?? "unKnown",
                    "documentId" : documentId,
                    "reactionImage": "",
                    "hexColor":"",
                    "textFontName":"",
                    "reactionMessage":"さんがあなたの投稿を公開しました",
                    "postImage":"",
                    "imageAddress":"",
                    "titleComment":"",
                    "theMessage":"",
                    "dataType": "releaseReport",
                    "notificationNum": notificationNum+1,
                    "releaseBool":false,
                    "acceptBool":false,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]

                db.collection("users").document(userId).collection("Notification").document(documentId).setData(docData, merge: true)
                db.collection("users").document(userId).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    

    func sendMemoFireStore(uid:String) {

        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)

        let memoInfoDic = [
            "message" : "\(reactionSelected?.userName ?? "unKnown")さんから投稿を受けました",
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "readLog": false,
            "anonymous":false,
            "admin": false,
            "delete": false,
            
            "graffitiUserId":reactionSelected?.userId ?? "",
            "graffitiUserFrontId":reactionSelected?.userFrontId ?? "",
            "graffitiUserName":reactionSelected?.userName ?? "unKnown",
            "graffitiUserImage":reactionSelected?.userImage ?? "",
            "graffitiTitle":reactionSelected?.titleComment ?? "",
            "graffitiContentsImage":reactionSelected?.postImage ?? "",
            "hexColor": reactionSelected?.hexColor ?? "",
            "backHexColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7973026613).toHexString(),
            "textFontName":reactionSelected?.textFontName ?? "",
            
        ] as [String: Any]
        
        let myPost = [
            "message" : "\(reactionSelected?.userName ?? "unKnown")さんから投稿を受けました",
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            
            "userId":uid,
            
            "graffitiUserId":reactionSelected?.userId ?? "",
            "graffitiUserFrontId":reactionSelected?.userFrontId ?? "",
            "graffitiUserName":reactionSelected?.userName ?? "unKnown",
            "graffitiUserImage":reactionSelected?.userImage ?? "",
            "graffitiTitle":reactionSelected?.titleComment ?? "",
            "graffitiContentsImage":reactionSelected?.postImage ?? "",
            "hexColor": reactionSelected?.hexColor ?? "",
            "textFontName":reactionSelected?.textFontName ?? "",
            "backHexColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7973026613).toHexString(),

            "anonymous":false,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("Connections").whereField("status", isEqualTo: "accept").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {

                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        db.collection("users").document(userId).collection("TimeLine").document(memoId).setData(memoInfoDic)

                    }
                }
            }
        }

        db.collection("AllOutMemo").document(memoId).setData(memoInfoDic)
//
        db.collection("users").document(uid).collection("TimeLine").document(memoId).setData(memoInfoDic)
//
        db.collection("users").document(uid).collection("MyPost").document(memoId).setData(myPost)
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    @IBOutlet weak var onUserImageView: UIImageView!
    @IBOutlet weak var onUserNameLabel: UILabel!
    @IBOutlet weak var onReactionView: UIImageView!
    @IBOutlet weak var onReactionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var onMessageBackView: UIView!
    @IBOutlet weak var onBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var onMessageLabel: UILabel!
    @IBOutlet weak var onCloseLabel: UILabel!
    @IBOutlet weak var reactionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        onMessageLabel.font = UIFont(name:"03SmartFontUI", size:19)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        setSwipeBack()
        
        UIApplication.shared.applicationIconBadgeNumber = 0


        let width = UIScreen.main.bounds.size.width
        onReactionViewConstraint.constant = width*0.55
        onBackViewConstraint.constant = width*0.3
        
        graffitiImageWidthConstraint.constant = width/2
        
        onUserImageView.alpha = 0
        onUserNameLabel.alpha = 0
        onReactionView.alpha = 0
        onMessageBackView.alpha = 0
        onMessageLabel.alpha = 0
        onCloseLabel.alpha = 0
        reactionBackButton.alpha = 0
        
        
        requestLabel.alpha = 0
        
        postBackView.alpha = 0
        
        postView.clipsToBounds = true
        postView.layer.cornerRadius = 10
        
        graffitiImageView.clipsToBounds = true
        graffitiImageView.layer.cornerRadius = 10
        
        postUserImageView.clipsToBounds = true
        postUserImageView.layer.cornerRadius = 20
        
        let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
        graffitiLabel.transform = transScale
        
        
        
        acceptImageConstraint.constant = width/2
        acceptedImageConstraint.constant = width/2
        acceptButtonConstraint.constant = width/2
        
        acceptImageView.clipsToBounds = true
        acceptedImageView.clipsToBounds = true
        acceptImageView.layer.cornerRadius = width/8
        acceptedImageView.layer.cornerRadius = width/8

        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        
        onMessageBackView.clipsToBounds = true
        onMessageBackView.layer.cornerRadius = 18
        
        onUserImageView.clipsToBounds = true
        onUserImageView.layer.cornerRadius = 30
        
        onMessageBackView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

        reactionTableView.delegate = self
        reactionTableView.dataSource = self
        
        fetchReaction(userId:uid)
        

        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FunLock.001.png?alt=media&token=dbbffbb2-26c1-4623-ac12-ca1185b2b424") {
            Nuke.loadImage(with: url, into: acceptImageView)
        } else {
            acceptImageView?.image = nil
        }
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Faccept.001.png?alt=media&token=67e1a7eb-1e84-4b5b-93f2-a49d9987ddfa") {
            Nuke.loadImage(with: url, into: acceptedImageView)
        } else {
            acceptedImageView?.image = nil
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData(["notificationNum": 0],merge: true)
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData(["notificationNum": 0],merge: true)
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    func fetchReaction(userId:String) {
        db.collection("users").document(userId).collection("Notification").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let reactionDic = Reaction(dic: dic)
                    
                    self.reaction.append(reactionDic)

                    self.reaction.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.reactionTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
}

extension NotificationVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reactionTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! reactionTableViewCell
        
        cell.reaction = reaction[indexPath.row]
        let dataType = reaction[indexPath.row].dataType
        let releaseBool = reaction[indexPath.row].releaseBool
        let acceptBool = reaction[indexPath.row].acceptBool
        
        cell.backgroundColor = .clear

        switch dataType {
        case "acceptingConnect":
            if acceptBool == true {
                cell.backgroundColor  = .clear
            } else if acceptBool == false {
                cell.backgroundColor  = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0.2)
            }
            
            
        case "ConnectersPost":
            if releaseBool == true {
                cell.backgroundColor = .clear
            } else if releaseBool == false {
                cell.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0.2)
            }
        default :
            cell.backgroundColor = .clear
        }
        
        cell.messageLabel.text = reaction[indexPath.row].reactionMessage
        
        let date: Date = reaction[indexPath.row].createdAt.dateValue()
        cell.dateLabel.text = date.agoText()
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 25
        cell.userImageView.image = nil
        if let url = URL(string:reaction[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        cell.userNameLabel.text = reaction[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        let storyboard = UIStoryboard.init(name: "FontCollection", bundle: nil)
        let FontCollectionVC = storyboard.instantiateViewController(withIdentifier: "FontCollectionVC") as! FontCollectionVC
        let safeAreaWidth = UIScreen.main.bounds.size.width
        cellDocumentId = reaction[indexPath.row].documentId
        userId = reaction[indexPath.row].userId
        
        reactionSelected = reaction[indexPath.row]
        

        

        let dataType = reaction[indexPath.row].dataType
        switch dataType {
        case "reaction" :
            onMessageLabel.text = reaction[indexPath.row].theMessage
            onUserNameLabel.text = reaction[indexPath.row].userName
            
            if let url = URL(string:reaction[indexPath.row].userImage) {
                Nuke.loadImage(with: url, into: onUserImageView)
            } else {
                onUserImageView.image = nil
            }
            if let url = URL(string:reaction[indexPath.row].reactionImage) {
                Nuke.loadImage(with: url, into: onReactionView)
            } else {
                onReactionView.image = nil
            }
            reactionBackButton.alpha = 0.8
            onAnimation()
            
        case "acceptingConnect":
            if reaction[indexPath.row].acceptBool == false {
                acceptImageAnimation(imageView: acceptImageView)
                acceptingBackButton.alpha = 0.8
                acceptingButton.alpha = 1
                requestLabel.text = "↓タップでコネクトを許可"
            } else {
                acceptImageAnimation(imageView: acceptedImageView)
                acceptingBackButton.alpha = 0.8
                requestLabel.text = "コネクト認証済み"
            }
        case "ConnectersPost":
            releaseBool = reaction[indexPath.row].releaseBool
            postViewAnimation(postView: postView)
            postBackView.alpha = 0.95
            
            
            if let url = URL(string:reaction[indexPath.row].userImage) {
                Nuke.loadImage(with: url, into: postUserImageView)
            } else {
                postUserImageView.image = nil
            }
            if let url = URL(string:reaction[indexPath.row].postImage) {
                Nuke.loadImage(with: url, into: graffitiImageView)
                graffitiLabel.alpha = 0
                graffitiTitleLabel.alpha = 1
            } else {
                graffitiImageView.image = nil
                graffitiTitleLabel.alpha = 0
                graffitiLabel.alpha = 1
            }
            postUserLabel.text = reaction[indexPath.row].userFrontId
            graffitiLabel.text = reaction[indexPath.row].titleComment
            graffitiTitleLabel.text = reaction[indexPath.row].titleComment
            
            
            let fontBool = FontCollectionVC.fontArray.contains(reaction[indexPath.row].textFontName)
            let removeSpacePostTitle = reaction[indexPath.row].titleComment.removeAllWhitespacesAndNewlines
//
            if removeSpacePostTitle.isAlphanumericAll() == false {
                graffitiTitleLabel.font = UIFont(name:"03SmartFontUI", size:safeAreaWidth/20)
                graffitiLabel.font = UIFont(name:"03SmartFontUI", size:safeAreaWidth/8)
            } else {
                if fontBool == false {
                    graffitiTitleLabel.font = UIFont(name:"Southpaw", size:safeAreaWidth/20)
                    graffitiLabel.font = UIFont(name:"Southpaw", size:safeAreaWidth/8)

                } else {
                    graffitiTitleLabel.font = UIFont(name:reaction[indexPath.row].textFontName, size:safeAreaWidth/20)
                    graffitiLabel.font = UIFont(name:reaction[indexPath.row].textFontName, size:safeAreaWidth/8)

                }
            }

            let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
            graffitiLabel.transform = transScale
//
//
//
            if reaction[indexPath.row].hexColor == "" {
                graffitiTitleLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            } else {
                let UITextColor = UIColor(hex: reaction[indexPath.row].hexColor)
                graffitiTitleLabel.textColor = UITextColor
                graffitiLabel.textColor = UITextColor
            }
            
            
            if reaction[indexPath.row].releaseBool == false {
                postExplainLabel.text = "↓をタップで公開"
            } else {
                postExplainLabel.text = "公開済み"
            }
            
        default :
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            ProfileVC.userId = reaction[indexPath.row].userId
            ProfileVC.cellImageTap = true
            navigationController?.pushViewController(ProfileVC, animated: true)
        }
        
    }
    
    func postViewAnimation(postView: UIView){
        
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            postView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            postView.alpha = 1
//            self.requestLabel.alpha = 1
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                postView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            })
        }
    }
    
    func acceptImageAnimation(imageView: UIImageView){
        
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            imageView.alpha = 1
            self.requestLabel.alpha = 1
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            })
        }
    }
    
    func onAnimation(){
        onMessageAnimation()
        onUserImageAnimation()
        onCloseLabelAnimation()
    }
    
    func onMessageAnimation() {
        
        // ②アイコンを大きくする
        UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
            self.onMessageBackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.onMessageLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            onMessageBackView.alpha = 1
            onMessageLabel.alpha = 1
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                self.onMessageBackView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.onMessageLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            })
            //            }
        }
    }
    func onUserImageAnimation() {
        
        // ②アイコンを大きくする
        UIView.animate(withDuration: 0.1, delay: 0.1, animations: { [self] in
            self.onUserImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.onReactionView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.onUserNameLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            onUserImageView.alpha = 1
            onReactionView.alpha = 1
            onUserNameLabel.alpha = 1
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.onUserImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.onReactionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.onUserNameLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
    func onCloseLabelAnimation() {
        UIView.animate(withDuration: 0.05, delay: 0.1, animations: { [self] in
            self.onCloseLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            onCloseLabel.alpha = 1

            //
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                self.onCloseLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            })
            
        }
        
    }
    
    
}

class reactionTableViewCell: UITableViewCell {
    
    var reaction : Reaction?

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = reaction?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
    }
}
