//
//  ThankyouVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class ThankyouVC:UIViewController {
    
    let db = Firestore.firestore()
    
    var outMemo: OutMemo?
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.selectedIndex = 0
        TabbarController.modalPresentationStyle = .fullScreen
        self.present(TabbarController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userId = UserDefaults.standard.string(forKey: "referralUserlId") ?? "unKnown"
        
        print("あなた",uid)
        print("えいえいえ",userId)

        let documentId = randomString(length: 20)

        firstSetUpData(uid:uid,documentId: documentId)
        firstChain(uid:uid,userId:userId)
        PostGet(uid:uid,userId:userId)
        PostGet(uid:userId,userId:uid)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.setNotification(userId: uid, documentId: documentId)
        }

        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.012.png?alt=media&token=54f5aabc-1273-4e35-9fd5-f644e7bad865") {
            Nuke.loadImage(with: url, into:  backGroundImageView)
        } else {
            backGroundImageView.image = nil
        }
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    func firstSetUpData(uid:String,documentId:String) {
        
        let sendedPostDoc = [
            "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
            "postImage":"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FfirstsendImage.001.png?alt=media&token=0eda6b67-cdeb-424c-997c-9bc42256c88e",
            "documentId":documentId,
            "titleComment":"Thanks for installing this app!",
            "createdAt": FieldValue.serverTimestamp(),
            "admin":false,
            "releaseBool":false
        ] as [String: Any]
//
        let timeLineDoc = [
            "message" : "Thanks for installing! \n2行目以降はマスクされるよ！\n enjoy!",
            "sendImageURL": "",
            "documentId": "firstSetUpNotificationDoc",
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth13.001.png?alt=media&token=a875740c-c522-4087-8b7e-1e4d03ee392c",
            "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
            "readLog": false,
            "anonymous":false,
            "admin": false,
            "delete": false,
        ] as [String: Any]

        let notificationDoc = [
            "createdAt": FieldValue.serverTimestamp(),
            "userId": "gBD75KJjTSPcfZ6TvbapBgTqpd92",
            "userName":"Ubatge",
            "userImage":"https://firebasestorage.googleapis.com:443/v0/b/totalgood-7b3a3.appspot.com/o/User_Image%2F51115339-DA49-4BE0-B9E6-A45FC8198FE0?alt=media&token=dac0b228-8381-430d-bb07-71ef20d80f4d",
            "userFrontId":"ubatge",
            "documentId" : "firstSetUpNotificationDoc",
            "reactionImage": "",
            "reactionMessage":"Welcome!",
            "theMessage":"",
            "dataType": "followersPost",
            "acceptBool":false,
            "anonymous":false,
            "admin": false,
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("Notification").document("firstSetUpNotificationDoc").setData(notificationDoc)
        db.collection("users").document(uid).collection("TimeLine").document("firstSetUpNotificationDoc").setData(timeLineDoc)
        db.collection("users").document(uid).collection("SendedPost").document(documentId).setData(sendedPostDoc)
        
        let userToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        
        let addNumber = [
            //        welcome と refferalの許可したぶんを合わせて2つ
            "notificationNum": FieldValue.increment(2.0),
            "referralCount": 15,
            "currentTime":FieldValue.serverTimestamp(),
            "fcmToken":userToken ?? ""
        ] as [String:Any]
        db.collection("users").document(uid).setData(addNumber, merge: true)
        
    }
    
    func firstChain(uid:String,userId:String){
        
        
        db.collection("users").document(userId).getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let userName = document["userName"] as? String ?? ""
                let userImage = document["userImage"] as? String ?? ""
                let userFrontId = document["userFrontId"] as? String ?? ""
                let notificationNum = document["userFrontId"] as? Int ?? 0
                
                let refferalUserProfile = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": userId,
                    "userName":userName,
                    "userImage":userImage,
                    "userFrontId":userFrontId,
                    "documentId" : "Chaining"+userId,
                    "reactionImage": "",
                    "reactionMessage":"さんとコネクトしました",
                    "theMessage":"",
                    "dataType": "acceptingConnect",
                    "notificationNum":2,
                    "acceptBool":true,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                
                let myUserProfile = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": uid,
                    "userName": UserDefaults.standard.object(forKey: "userName") as? String ?? "unKnown",
                    "userImage": UserDefaults.standard.object(forKey: "userImage") as? String ?? "unKnown",
                    "userFrontId": UserDefaults.standard.object(forKey: "userFrontId") as? String ?? "unKnown",
                    "documentId" : "Connecting"+uid,
                    "reactionImage": "",
                    "reactionMessage":"さんとコネクトしました",
                    "theMessage":"",
                    "dataType": "acceptingChain",
                    "notificationNum":notificationNum,
                    "acceptBool":true,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                
                
                db.collection("users").document(userId).collection("Notification").document("Connecting"+uid).setData(myUserProfile, merge: true)
                db.collection("users").document(userId).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                db.collection("users").document(uid).collection("Notification").document("Connecting\(userId)").setData(refferalUserProfile, merge: true)
                db.collection("users").document(userId).collection("Connections").document(uid).setData(["createdAt": FieldValue.serverTimestamp(),"userId":uid,"status":"accept"], merge: true)
                db.collection("users").document(uid).collection("Connections").document(userId).setData(["createdAt": FieldValue.serverTimestamp(),"userId":userId,"status":"accept"], merge: true)
                db.collection("users").document(userId).setData(["ConnectionsCount": FieldValue.increment(1.0)], merge: true)
                db.collection("users").document(uid).setData(["ConnectionsCount": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func PostGet(uid:String,userId:String){
        db.collection("users").document(uid).collection("MyPost").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                    
                        print("\(document.documentID) => \(document.data())")
                        let dic = document.data()
                        let outMemoDic = OutMemo(dic: dic)
                        print("あせfs")
                        print(outMemoDic)
                        print(userId)
                        PostSet(userId:userId ,outMemo: outMemoDic)
                    }
                }
            }
        }
    }
    
    func PostSet(userId:String,outMemo:OutMemo){
        
        let documentId = outMemo.documentId
        
        if documentId != "" && outMemo.anonymous != true{
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
            db.collection("users").document(userId).collection("TimeLine").document(documentId).setData(memoInfoDic, merge:true)
        }
        
    }
    
    func setNotification(userId: String,documentId:String) {
        
        db.collection("users").document(userId).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0
                
                let hexColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1).toHexString()
                
                let sendedNotification = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": "gBD75KJjTSPcfZ6TvbapBgTqpd92",
                    "userName":"Ubatge",
                    "userImage":"https://firebasestorage.googleapis.com:443/v0/b/totalgood-7b3a3.appspot.com/o/User_Image%2F51115339-DA49-4BE0-B9E6-A45FC8198FE0?alt=media&token=dac0b228-8381-430d-bb07-71ef20d80f4d",
                    "userFrontId":"ubatge",
                    "documentId" : documentId,
                    "reactionImage": "",
                    "hexColor":hexColor,
                    "textFontName":"Julies",
                    "reactionMessage":"さんから投稿を受けました",
                    "postImage":"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FfirstsendImage.001.png?alt=media&token=0eda6b67-cdeb-424c-997c-9bc42256c88e",
                    "imageAddress":"",
                    "titleComment":"Thanks for installing this app!",
                    "theMessage":"",
                    "dataType": "ConnectersPost",
                    "notificationNum": notificationNum+1,
                    "releaseBool":false,
                    "acceptBool":false,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                db.collection("users").document(userId).collection("Notification").document(documentId).setData(sendedNotification)

                db.collection("users").document(userId).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    
}
