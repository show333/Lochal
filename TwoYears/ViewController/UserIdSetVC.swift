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

    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var idTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldDistance: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendTappedButton(_ sender: Any) {
        
        let idText = idTextField.text
        let removeString = idText?.removeAllWhitespacesAndNewlines
        let sendUserId = removeString?.lowercased() ?? ""
        let sendUserIdBool = sendUserId.count
        
        if sendUserIdBool<2 || sendUserIdBool>30 {
            print("以外")
        } else {
            print("inai")
            
            if sendUserId.isAlphanumeric() == false {
                print("使用ができない文字が含まれています")
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                getAccount(userId: uid, userFrontId: sendUserId)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
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
                    } else {
                        print("このアカウントはすでに使用されています")
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
