//
//  FirstSetNameVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstSetNameVC:UIViewController{
    
    
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
            let storyboard = UIStoryboard.init(name: "FirstSetImage", bundle: nil)
            let FirstSetImageVC = storyboard.instantiateViewController(withIdentifier: "FirstSetImageVC") as! FirstSetImageVC
            navigationController?.pushViewController(FirstSetImageVC, animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        warningLabel.alpha = 0
        
        explainLabel.text = "友達にわかりやすい名前を\n入力してください！"
        
        sendButton.clipsToBounds = true
        sendButton.layer.masksToBounds = false
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 5
        
        let safeArea = UIScreen.main.bounds.size.width
        
        nameTextFieldConstraint.constant = safeArea/6
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    func firstSetup() {
        let uid = Auth.auth().currentUser?.uid
        let firstSetup = [
            "admin":false,
            "userId":uid ?? "",
            "nowjikan": FieldValue.serverTimestamp(),
            "createdAt": FieldValue.serverTimestamp(),
        ] as [String: Any]
        
        
        db.collection("users").document(uid ?? "").setData(firstSetup,merge: true)
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
