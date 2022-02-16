//
//  UserIdSetVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore



class UserIdSetVC:UIViewController,UITextFieldDelegate{
    
    
    let db = Firestore.firestore()

    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var idTextFieldConstraint: NSLayoutConstraint!
//    @IBOutlet var textFieldDistance: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendTappedButton(_ sender: Any) {
        
        let idText = idTextField.text
        let removeString = idText?.removeAllWhitespacesAndNewlines
        let sendUserId = removeString?.lowercased() ?? ""
        let sendUserIdBool = sendUserId.count
        
        if sendUserIdBool<2 || sendUserIdBool>30 {
            warningLabel.text = "2~30文字で入力してください"
            labelAnimation()
        } else {
            print("inai")
            
            if sendUserId.isAlphanumeric() == false {
                warningLabel.text = "使用ができない文字が含まれています"
                labelAnimation()
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                UserDefaults.standard.set(sendUserId, forKey: "userFrontId")
                getAccount(userId: uid, userFrontId: sendUserId)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.alpha = 0
        
        explainLabel.text = "半角英数字で入力してください.\n2~30以内の文字数が可能です.\n空白は使用する事ができません."
        sendButton.clipsToBounds = true
        sendButton.layer.masksToBounds = false
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 5
        
        let safeArea = UIScreen.main.bounds.size.width
        
        idTextFieldConstraint.constant = safeArea/6
        
  
        
        setSwipeBack()
        idTextField.delegate = self

        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    func getAccount(userId:String,userFrontId:String){
        db.collection("users").whereField("userFrontId", isEqualTo: userFrontId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0{
                        setIdAccount(userId: userId, userFrontId: userFrontId)
                        fetchMyPost(userId: userId, userFrontId: userFrontId)
                        fetchMyTeam(userId:userId,userFrontId:userFrontId)
                        UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
                        
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        warningLabel.text = "このアカウントはすでに使用されています"
                        labelAnimation()
                    }
                }
        }
        
    }
    
    func setIdAccount(userId:String,userFrontId:String){
        db.collection("users").document(userId).collection("Profile").document("profile").setData(["userFrontId":userFrontId]as[String : Any],merge: true)
        db.collection("users").document(userId).setData(["userFrontId":userFrontId] as [String : Any],merge: true)
    }
    
    func fetchMyPost(userId:String,userFrontId:String){
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
                        self.db.collection("users").document(userId).collection("MyPost").document(myPostDocId).setData(["userFrontId":userFrontId] as [String : Any],merge: true)
                    }
                }
            }
        }
    }
    
    func fetchMyTeam(userId:String,userFrontId:String){
        db.collection("users").document(userId).collection("belong_Team").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count == 0 {
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let myTeamId =  document.data()["teamId"] as? String ?? "unKnown"
                        self.db.collection("Team").document(myTeamId).collection("MembersId").document(userId).setData(["userFrontId":userFrontId] as [String : Any],merge: true)
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


extension String {
    // 半角数字の判定
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-z0-9_]", options: .regularExpression) == nil
    }
}
