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
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var ongakuLabel: UILabel!
    @IBOutlet weak var sinkiButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var companyView: UIImageView!
    @IBAction func tappedSinkiButton(_ sender: Any) {
        lulu(teamName: teamColor!)
        dismiss(animated: true, completion: nil)
        print("タップした後！",UserDefaults.standard.string(forKey: "color")!)
    }
    var teamColor : String?
    var newColor : String?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func lulu(teamName: String) {
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let DB = Firestore.firestore().collection("Rooms").document("karano")
        let iwayuruId = randomString(length: 20)
        let randomUserId = randomString(length: 8)
        let thisisMessage = self.textView.text.trimmingCharacters(in: .newlines)
        let comentId = uid + "comentId"
        let userBrands = UserDefaults.standard.string(forKey: "userBrands")
        
        let rufi = [
            "message" : thisisMessage as Any,
            "documentId": iwayuruId,
            "createdAt": FieldValue.serverTimestamp(),
            "createdLatestAt": FieldValue.serverTimestamp(),
            "teamname":  teamName,
            "memberscount": 1,
            "goodcount": 1,
            "messagecount": 1,
            "userId":uid,
            uid: true,
            "userBrands": userBrands!,
            "admin": false,
            "newColor": newColor!,
            "company1":""
        ] as [String: Any]
        
        let zoro = [
            "message" : thisisMessage as Any,
            "comentId": comentId,
            "createdAt": FieldValue.serverTimestamp(),
            "teamname":  teamName,
            "documentId": iwayuruId,
            "userId": uid,
            "admin": false,
            "randomUserId": "",
            "userBrands": userBrands!,
            "sendImageURL":"",
            "company1": company1Id!,
        ] as [String: Any]
        
        Firestore.firestore().collection("users").document(uid).setData(["The_earliest":true], merge: true)
        DB.collection("kokoniireru").document(iwayuruId).setData(rufi)
        DB.collection("kokoniireru").document(iwayuruId).collection("members").document(uid).setData(["randomUserId": randomUserId])
        DB.collection("kokoniireru").document(iwayuruId).collection("good").document("goodman").setData(["space":"X"])
        DB.collection("kokoniireru").document(iwayuruId).collection("messages").document(comentId).setData(zoro)
        print(rufi["createdAt"] as Any)
        print(Timestamp().dateValue())
        let aaaa = FieldValue.serverTimestamp()
        print(aaaa)
    }
    fileprivate let placeholder: String = "今、何を聴いてる?\nこういう人、どう思う？\netc." //プレイスホルダー
    fileprivate var maxWordCount: Int = 70 //最大文字数
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
        teamColor =  UserDefaults.standard.string(forKey: "color")!
        
        if teamColor == "red" || teamColor == "yellow" {
            newColor = "orange"
        } else if teamColor == "blue" || teamColor == "purple" {
            newColor = "violet"
        }
        ongakuLabel.text = "投稿は2週間で消えます"
        print("新規投稿",UserDefaults.standard.string(forKey: "color")!)
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
        wordCountLabel.text = "70文字まで"
    }
}
extension sinkitoukou: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        return linesAfterChange <= 5 && textView.text.count + (text.count - range.length) <= maxWordCount
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
        if existingLines.count <= 5 {
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
