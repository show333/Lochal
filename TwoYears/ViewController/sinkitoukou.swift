//
//  sinkitoukou.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftMoment
import Nuke


class sinkitoukou: UIViewController {
    let uid = UserDefaults.standard.string(forKey: "userId")
    var company1Id : String?
    var followerId : [String] = []
    
    var userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String
    var userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String
    var userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String
    
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
    
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var ongakuLabel: UILabel!
    @IBOutlet weak var sinkiButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var companyView: UIImageView!
    @IBAction func tappedSinkiButton(_ sender: Any) {
        sendMemoFireStore()
        dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func sendMemoFireStore() {

        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)
        let thisisMessage = self.textView.text.trimmingCharacters(in: .newlines)
        
        let memoInfoDic = [
            "message" : thisisMessage as Any,
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "readLog": false,
            "anonymous":false,
            "admin": true,
            "delete": false,
        ] as [String: Any]
        
        let myPost = [
            "message" : thisisMessage as Any,
            "sendImageURL": "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            "userId":uid,
            "textMask":textMask.randomElement() ?? "",
            "anonymous":false,
            "admin": true,
            "delete": false,
        ] as [String: Any]
        
        
        followerId = ["a","aa","aaa","aaaa","aaaaa","aaaaaa",]
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userId =  document.data()["この人のuid"] as? String ?? "unKnown"
                    db.collection("users").document(userId).collection("TimeLine").document(memoId).setData(memoInfoDic)
//                    print("おおおお",userId)
                }
            }
        }
//
//        followerId.forEach{
//            print($0)
//            db.collection("users").document($0).collection("TimeLine").document(memoId).setData(memoInfoDic)
//        }
        
        
        db.collection("AllOutMemo").document(memoId).setData(memoInfoDic)
//
//        db.collection("users").document(uid).collection("TimeLine").document(memoId).setData(memoInfoDic)
//
        db.collection("users").document(uid).collection("MyPost").document(memoId).setData(myPost)
        
    }
    
    
    
    
    fileprivate let placeholder: String = "今、何を聴いてる?\nこういう人、どう思う？\netc." //プレイスホルダー
    fileprivate var maxWordCount: Int = 200 //最大文字数
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firestore.firestore().collection("users").document(uid!).getDocument{ (document, error) in
          if let document = document {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
           let company1Idget = document.data()?["company1"]as? String
            
            if let company1Idget = company1Idget {
                self.company1Id = company1Idget
            }
          } else {
            print("Document does not exist in cache")
          }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ongakuLabel.text = "投稿は2日間で消えます"
        self.textView.delegate = self
        sinkiButton.isEnabled = false
        sinkiButton.backgroundColor = .gray
        textView.text = placeholder
        textView.textColor = .gray
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9829034675)
        textView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 8
        sinkiButton.clipsToBounds = true
        sinkiButton.layer.cornerRadius = 5
        wordCountLabel.text = "200文字まで"
    }
}
extension sinkitoukou: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        return linesAfterChange <= 20 && textView.text.count + (text.count - range.length) <= maxWordCount
    }
    func textViewDidChange(_ textView: UITextView) {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let textwhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)//空白、改行のみを防ぐ
        if textwhite.isEmpty {
            sinkiButton.isEnabled = false
            sinkiButton.backgroundColor = .gray
        } else {
            sinkiButton.isEnabled = true
            sinkiButton.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        }
        if existingLines.count <= 20 {
            self.wordCountLabel.text = "残り\(maxWordCount - textView.text.count)文字"
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = placeholder
        }
    }
}
