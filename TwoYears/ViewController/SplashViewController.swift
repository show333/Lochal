//
//  SplashViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/13.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import BATabBarController
import Lottie


class SplashViewController: UIViewController {
    
    private var teamId: [String] = []

    
    var randamUserImageInt: Int?

    
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    
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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        func randomString(length: Int) -> String {
            let characters = "0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        randamUserImageInt = Int(randomString(length: 1))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        
        if uid != nil {
            func randomString(length: Int) -> String {
                let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return String((0..<length).map{ _ in characters.randomElement()! })
            }
            
            let dic = [
                "first":[1,2,3],
                "seconds":[4,6,7],
                "third":[8,7,4],
                "fourth":[5,5,3]
            ]
            
            print("あああああああ",dic["first"] as Any)
            
            print(uid)
            
            Firestore.firestore().collection("users").document(uid!).collection("Profile").document("profile").getDocument {(document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    print("愛恵f助汗jフォイアせjf")
                    
                    let userId = document["userId"] as? String ?? ""
                    let userName = document["userName"] as? String ?? ""
                    let userImage = document["userImage"] as? String ?? ""
                    let userFrontId = document["userFrontId"] as? String ?? ""
                    
//                    let dicArray : Array = document["eieie"] as! Array<String>
                    
                    
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.set(userImage, forKey: "userImage")
                    UserDefaults.standard.set(userFrontId, forKey: "userFrontId")

                }
            }
            
            Firestore.firestore().collection("users").document(uid!).setData(["eieie":["かっっけk","アイウエオ","oooooo"]],merge: true)
            
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
            TabbarController.modalPresentationStyle = .fullScreen
            
            Firestore.firestore().collection("users").document(uid!).setData(["nowjikan": FieldValue.serverTimestamp()], merge: true)
            
            UIView.animate(withDuration: 0.4, delay: 0, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.subTitleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.15, delay: 0, animations: {
                    self.titleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.titleLabel.alpha = 0
                    self.subTitleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.subTitleLabel.alpha = 0
                }) { bool in
                    self.present(TabbarController, animated: true, completion: nil)
                }
            }
            
        } else {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)//遷移先のStoryboardを設定
            let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") //遷移先のTabbarController指定とIDをここに入力
            SignInViewController.modalPresentationStyle = .fullScreen
            
            UIView.animate(withDuration: 0.4, delay: 0, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.subTitleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.15, delay: 0, animations: {
                    self.titleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.titleLabel.alpha = 0
                    self.subTitleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.subTitleLabel.alpha = 0
                }) { bool in
                    self.present(SignInViewController, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("スプラッシュ")
        
        
        // Atomically increment the population of the city by 50.
        // Note that increment() with no arguments increments by 1.
        
        if UserDefaults.standard.object(forKey: "blocked") == nil{
            let XXX = ["XX" : true]
            UserDefaults.standard.set(XXX, forKey: "blocked")
        }
        
        if  UserDefaults.standard.string(forKey: "invited") == nil{
            UserDefaults.standard.set("", forKey: "invited")
        }
        
        
    }
    
    
}


extension SplashViewController: BATabBarControllerDelegate {
    func tabBarController(_ tabBarController: BATabBarController, didSelect: UIViewController) {
        print("Delegate success!");
    }
}
