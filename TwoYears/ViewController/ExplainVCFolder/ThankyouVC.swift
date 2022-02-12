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
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.modalPresentationStyle = .fullScreen
        self.present(TabbarController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        firstSetUpData()
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages4.013.png?alt=media&token=4e8ed41c-58f3-4568-a048-a27ff97194e9") {
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
    
    func firstSetUpData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentId = randomString(length: 20)
        
        let sendedPostDoc = [
            "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
            "postImage":"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FfirstsendImage.001.png?alt=media&token=0eda6b67-cdeb-424c-997c-9bc42256c88e",
            "documentId":documentId,
            "titleComment":"Thanks for installing this app!",
            "createdAt": FieldValue.serverTimestamp(),
            "admin":false
        ] as [String: Any]
//
        let timeLineDoc = [
            "message" : "Thanks for installing! \n2行目以降はマスクされるよ！\n enjoy!",
            "sendImageURL": "",
            "documentId": documentId,
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
            "documentId" : documentId,
            "reactionImage": "",
            "reactionMessage":"Welcome!",
            "theMessage":"",
            "dataType": "followersPost",
            "acceptBool":false,
            "anonymous":false,
            "admin": false,
        ] as [String: Any]

        db.collection("users").document(uid).collection("Notification").document(documentId).setData(notificationDoc)
        db.collection("users").document(uid).collection("TimeLine").document(documentId).setData(timeLineDoc)
        db.collection("users").document(uid).collection("SendedPost").document(documentId).setData(sendedPostDoc)
        db.collection("users").document(uid).setData(["notificationNum": FieldValue.increment(1.0)], merge: true)

        
    }
}
