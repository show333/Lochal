//
//  ShoutaiHakkou.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/07.
//

import UIKit
import Firebase
import FirebaseAuth

class ShoutaiHakkou: UIViewController {
    @IBOutlet weak var hakkoButton: UIButton!

//    一応サインアウトボタン
    @IBAction func BubuButton(_ sender: Any) {
        do{
            try  Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error singing out : %@", signOutError)
        }

        
    }
    @IBAction func hakkouTappedButton(_ sender: Any) {
 
        sinkiki()
    }
    
    func sinkiki() {
        
        guard let oyaId = Auth.auth().currentUser?.uid else { return }
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let sinkiId = randomString(length: 10)
        hakkouTextField.text = sinkiId
        
        let email = sinkiId + "@2.years"
        print(email)
        
        //アカウント作成
        Auth.auth().createUser(withEmail: email, password: "ONELIFE") { (res, err) in
            if let err = err {
                print("失敗やで、、、\(err)")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("成功！！！", uid)
            
            let docData = ["招待した人のID": oyaId, "jikan": Timestamp()] as [String : Any]
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("firestore保存が失敗、、\(err)")
                    return
                }
                print("成功！")
            }
        }
        
        //ログアウト
        do{
            try  Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error singing out : %@", signOutError)
        }
        
    }
    
    
    @IBOutlet weak var hakkouTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
