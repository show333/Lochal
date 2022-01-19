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
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldDistance: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendTappedButton(_ sender: Any) {
        
        let idText = nameTextField.text
        let sendName = idText?.removeAllWhitespacesAndNewlines ?? ""
        let sendNameBool = sendName.count
        
        if sendNameBool<2 || sendNameBool>30 {
            print("以外")
        } else {
            print("inai")
            guard let uid = Auth.auth().currentUser?.uid else {return}
            setFirestore(userId: uid, userName: sendName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeBack()

        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    func setFirestore(userId:String,userName:String){
        setNameAccount(userId: userId, userName: userName)
        fetchMyPost(userId: userId, userName: userName)
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
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


