//
//  UserNameSetVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserNameSetVC:UIViewController{
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendTappedButton(_ sender: Any) {
        
        let idText = nameTextField.text
        let sendName = idText?.removeAllWhitespacesAndNewlines ?? ""
        let sendNameBool = sendName.count
        
        if sendNameBool<2 || sendNameBool>30 {
            warningLabel.text = "2~30文字で入力してください"
            labelAnimation()
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            UserDefaults.standard.set(sendName, forKey: "userName")
            setFirestore(userId: uid, userName: sendName)
            self.navigationController?.popViewController(animated: true)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.alpha = 0
        
        explainLabel.text = "2~30以内の文字数が可能です.\n空白は使用する事ができません."
        
        sendButton.clipsToBounds = true
        sendButton.layer.masksToBounds = false
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 5
        
        let safeArea = UIScreen.main.bounds.size.width
        
        nameTextFieldConstraint.constant = safeArea/6
        
        setSwipeBack()

        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    func setFirestore(userId:String,userName:String){
        setNameAccount(userId: userId, userName: userName)
        fetchMyPost(userId: userId, userName: userName)
        fetchMyTeam(userId:userId,userName:userName)
    }
    
    func setNameAccount(userId:String,userName:String){
        db.collection("users").document(userId).collection("Profile").document("profile").setData(["userName":userName]as[String : Any],merge: true)
        db.collection("users").document(userId).setData(["userName":userName] as [String : Any],merge: true)
    }
    
    func fetchMyPost(userId:String,userName:String){
        db.collection("users").document(userId).collection("MyPost").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count == 0 {
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let myPostDocId =  document.data()["documentId"] as? String ?? "unKnown"
                        print("ハングリー",myPostDocId)
                        self.db.collection("users").document(userId).collection("MyPost").document(myPostDocId).setData(["userName":userName] as [String : Any],merge: true)
                    }
                }
            }
        }
    }
    
    func fetchMyTeam(userId:String,userName:String){
        db.collection("users").document(userId).collection("belong_Team").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count == 0 {
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let myTeamId =  document.data()["teamId"] as? String ?? "unKnown"
                        self.db.collection("Team").document(myTeamId).collection("MembersId").document(userId).setData(["userName":userName] as [String : Any],merge: true)
                    }
                }
            }
        }
    }
    
    func labelAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.warningLabel.alpha = 1
//
//
        }) { bool in
        // ②アイコンを大きくする
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.warningLabel.alpha = 1

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.2, delay: 2, animations: {
                self.warningLabel.alpha = 0

            })
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


