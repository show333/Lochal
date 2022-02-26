//
//  ReNewPostVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class ReMemoPostVC:UIViewController {
    var postInfoTitle: String?
    var postInfoImage: String?
    var postInfoDoc:String?
    var userId: String?
    var userName: String?
    var userImage: String?
    var userFrontId: String?
    
    
    
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
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func tappedSendButton(_ sender: Any) {
        reSendMemoFireStore()
        print("鮮度")
    }
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var graffitiUserImageView: UIImageView!
    @IBOutlet weak var graffitiUserLabel: UILabel!
    @IBOutlet weak var graffitiContentsImageView: UIImageView!
    @IBOutlet weak var graffitiTitleLabel: UILabel!
    
    
    func reSendMemoFireStore() {

        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let graffitiUserId = userId else {return}
        guard let graffitiUserName = userName else {return}
        guard let graffitiUserImage = userImage else {return}
        guard let graffitiUserFrontId = userFrontId else {return}
        guard let graffitiContentsImage = postInfoImage else {return}
        guard let graffitiTitle = postInfoTitle else {return}

        
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)
        let thisisMessage = self.commentTextView.text.trimmingCharacters(in: .newlines)

        
        let memoInfoDic = [
            "message" : thisisMessage as Any,
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "graffitiUserId":graffitiUserId,
            "graffitiUserFrontId":graffitiUserFrontId,
            "graffitiUserName":graffitiUserName,
            "graffitiUserImage":graffitiUserImage,
            "graffitiTitle":graffitiTitle,
            "graffitiContentsImage":graffitiContentsImage,
            "readLog": false,
            "anonymous":false,
            "admin": false,
            "delete": false,
            
        ] as [String: Any]
        
        let myPost = [
            "message" : thisisMessage as Any,
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userName":UserDefaults.standard.string(forKey: "userName") ?? "",
            "userImage":UserDefaults.standard.string(forKey: "userImage") ?? "",
            "userFrontId":UserDefaults.standard.string(forKey: "userFrontId") ?? "",
            "userId":uid,
            "graffitiUserId":graffitiUserId,
            "graffitiUserFrontId":graffitiUserFrontId,
            "graffitiUserName":graffitiUserName,
            "graffitiUserImage":graffitiUserImage,
            "graffitiTitle":graffitiTitle,
            "graffitiContentsImage":graffitiContentsImage,
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graffitiUserLabel.text = userFrontId
        graffitiTitleLabel.text = postInfoTitle
        
        if let url = URL(string:userImage ?? "") {
            Nuke.loadImage(with: url, into: graffitiUserImageView)
        } else {
            graffitiUserImageView.image = nil
        }
        
        if let url = URL(string:postInfoImage ?? "") {
            Nuke.loadImage(with: url, into: graffitiContentsImageView)
        } else {
            graffitiContentsImageView.image = nil
        }
        
        
    }
}
