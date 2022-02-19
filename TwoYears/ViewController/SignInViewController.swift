//
//  SignIn.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/07.
//

import UIKit
import Firebase
import FirebaseAuth
import BATabBarController
import TransitionButton
import FirebaseFirestore
import SwiftUI



class SignInViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomId = randomString(length: 8)
        let uid = Auth.auth().currentUser?.uid
        if uid == nil {
            Auth.auth().createUser(withEmail: randomId + "@2.years", password: "ONELIFE") { authResult, error in
            }
        }
        
        explainLabel.alpha = 0
        view.backgroundColor = #colorLiteral(red: 0.9402339228, green: 0.9045240944, blue: 0.8474154538, alpha: 1)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let button = TransitionButton(frame:CGRect(x:width/4,y:height/2.5,width:width/2,height:50)); // please use Autolayout in real project
        
        self.view.addSubview(button)
        
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        button.setTitle("Enter", for: .normal)
        button.cornerRadius = 20
        button.spinnerColor = .white
        
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        
    }
    
    // サインインボタン
    @IBAction func buttonAction(_ button: TransitionButton) {
        guard let refferalId = idTextField.text else { return }
        
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: { [self] in
            sleep(1) // 3: Do your networking task or background work here.
            
            db.collection("RefferalId").whereField("usedBool", isEqualTo: false).whereField("refferalId", isEqualTo: refferalId)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        if querySnapshot!.documents.count != 0 {
                            self.successAnimation(button: button, refferalId: refferalId)
                            
                            for document in querySnapshot!.documents {
                                let refferalUserId = document.data()["userId"] as? String ?? ""
                                UserDefaults.standard.set(refferalUserId, forKey: "refferalUserId")
                            }
                            
                        } else {
                            self.ErrorAnimation(button: button)
                        }
                    }
                }
        })
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    func ErrorAnimation(button:TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        //ログイン失敗(IDが違う場合)
        backgroundQueue.async(execute: {
            sleep(1) // 3: Do your networking task or background work here.
            DispatchQueue.main.async(execute: { () -> Void in
                button.stopAnimation(animationStyle: .shake, completion: {
                    
                    print("shake")
                    self.explainLabel.text = "このIDは招待されたIDと異なります。"
                    button.setTitle("Enter", for: .normal)
                    self.textAnimation()
                })
            })
            return
        })
        
    }
    
    func textAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.explainLabel.alpha = 1
        }) {(completed) in
            UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
            })
        }
    }
    
    func successAnimation(button:TransitionButton,refferalId:String) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        //ログイン失敗(IDが違う場合)
        backgroundQueue.async(execute: {
            sleep(1) // 3: Do your networking task or background work here.
            DispatchQueue.main.async(execute: { () -> Void in
                button.stopAnimation(animationStyle: .expand, completion: { [self] in
                    print("setdata")
                    firstSetup(refferalId: refferalId)

                })
            })
            return
        })
        
    }
    
    
    func firstSetup(refferalId:String) {
        let uid = Auth.auth().currentUser?.uid
        let userToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")

        let firstSetup = [
            "admin":false,
            "UEnterdBool": true,
            "fcmToken":userToken ?? "unKnown",
            "userId":uid ?? "",
            "nowjikan": FieldValue.serverTimestamp(),
            "createdAt": FieldValue.serverTimestamp(),
        ] as [String: Any]
        UserDefaults.standard.set(uid, forKey: "userId")
        
        db.collection("users").document(uid ?? "").setData(firstSetup,merge: true)
        
        let profile = [
            "admin":false,
            "UEnterdBool": true,
            "userId":uid ?? "",
        ] as [String: Any]
        
        db.collection("users").document(uid ?? "").collection("Profile").document("profile").setData(profile,merge: true)
        
        db.collection("RefferalId").document(refferalId).setData(["usedBool":true],merge: true)
        
        let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ExplainVC") as! ExplainVC
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    
//    func presentTabbar(userId:String) {
//        db.collection("users").document(userId).setData(["nowjikan":FieldValue.serverTimestamp()]as[String:Any], merge:true)
//        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
//        TabbarController.modalPresentationStyle = .fullScreen
//        self.present(TabbarController, animated: true, completion: nil)
//    }

    //他の部分をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
