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
    
    
    let userImage : Array = ["https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA11gusya.png?alt=media&token=fc744cee-7365-441c-81d4-8f877076ec13",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB2hyokkori.png?alt=media&token=13eb5fa7-d790-451b-a7a2-43c1b1b532f8",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB3korede.png?alt=media&token=70a31f21-728b-4339-93f1-7984ac7f635a",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB4ha-to.png?alt=media&token=22cb5c5e-d4f1-4a46-be32-5c708f669473",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC12flag.png?alt=media&token=e55ae578-4826-4bd8-962a-b989f61b736d",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD2kondru.png?alt=media&token=3566e4ce-6102-4735-a553-d973b70509d9",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF1burebure.png?alt=media&token=6ef860dc-4669-4abd-bfbe-acccfada72d4",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF18gojou.png?alt=media&token=0ce25eb8-9048-482e-a9fd-4faf593c28a2",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG2nemasu.png?alt=media&token=a03da529-c8c6-4f8e-94b8-39fefd8de034",
                             "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG8dog.png?alt=media&token=3755a316-e21a-491c-b050-267d5c9a9e8f",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        guard let teamId = idTextField.text else { return }
        let randomId = randomString(length: 8)
        Auth.auth().createUser(withEmail: randomId + "@2.years", password: "ONELIFE") { authResult, error in
            print("トントン")
        }
        print("あいあいあいあ")
        
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: { [self] in
            sleep(1) // 3: Do your networking task or background work here.
            
            db.collection("Team").whereField("teamId", isEqualTo: teamId)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        if querySnapshot!.documents.count != 0 {
                            self.successAnimation(button: button, teamId: teamId,randomId:randomId)
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
                    
                    let user = Auth.auth().currentUser

                    user?.delete { error in
                      if let error = error {
                          print(error)
                      } else {
                        // Account deleted.
                      }
                    }
                    print("shake")
                    self.explainLabel.text = "このIDは招待されたIDと異なります。"
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
    
    func successAnimation(button:TransitionButton,teamId:String,randomId:String) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        //ログイン失敗(IDが違う場合)
        backgroundQueue.async(execute: {
            sleep(1) // 3: Do your networking task or background work here.
            DispatchQueue.main.async(execute: { () -> Void in
                button.stopAnimation(animationStyle: .expand, completion: { [self] in
                    print("setdata")
                    
                    
                    UserDefaults.standard.set(true, forKey: "belongTeam")

                    let userImage = self.userImage.randomElement()
                    let userName = self.randomString(length: 6)
                    let uid = Auth.auth().currentUser?.uid

                    UserDefaults.standard.set(uid, forKey: "userId")
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.set(userImage, forKey: "userImage")
                    let profile: [String: Any] = [
                        "admin":false,
                        "userId":uid ?? "",
                        "userImage":userImage ?? "",
                        "userName":userName
                    ]
                    db.collection("users").document(uid ?? "").collection("Profile").document("profile").setData(profile) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    db.collection("users").document(uid ?? "").collection("belong_Team").document("teamId").setData(["teamId":FieldValue.arrayUnion([teamId]) ], merge: true)
                    db.collection("Team").document(teamId).setData(["membersCount": FieldValue.increment(1.0)], merge: true)

                    db.collection("Team").document(teamId).collection("MembersId").document("membersId").setData(["userId": FieldValue.arrayUnion([uid ?? ""])], merge: true)
                    
                    let Account: [String: Any] = [
                        "Entered":true,
                        "adminaccount":false,
                        "この人のuid":uid ?? "",
                        "この人のアドレス":randomId,
                    ]
                    
                    db.collection("users").document(uid ?? "").setData(Account,merge: true)
                    
                    
                    self.presentTabbar(userId: uid ?? "")

                })
            })
            return
        })
        
    }
    
    func presentTabbar(userId:String) {
        db.collection("users").document(userId).setData(["nowjikan":FieldValue.serverTimestamp()]as[String:Any], merge:true)
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.modalPresentationStyle = .fullScreen
        self.present(TabbarController, animated: true, completion: nil)
    }

    //他の部分をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
