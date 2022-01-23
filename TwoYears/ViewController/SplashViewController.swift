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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        let storyboard = UIStoryboard.init(name: "TeamExplain", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "TeamExplainVC") as! TeamExplainVC
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                   let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                   TabbarController.modalPresentationStyle = .fullScreen
                   self.present(TabbarController, animated: true, completion: nil)
//        let uid = Auth.auth().currentUser?.uid
//        let belongTeam = UserDefaults.standard.bool(forKey: "belongTeam")
//        if uid != nil {
//            if belongTeam == true{
//                profileGet(userId:uid ?? "")
//                presentTabbar(userId:uid ?? "")
//            } else {
//                db.collection("users").document(uid!).getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                        print("Document data: \(dataDescription)")
//                        self.profileSet(userId: uid ?? "unKnown")
//                        self.presentTabbar(userId:uid ?? "unKnown")
//                    } else {
//                        print("Document does not exist")
//                        self.presentSignIn(userId:uid ?? "unKnown")
//                    }
//                }
//            }
//        } else {
//            presentSignIn(userId:uid ?? "")
//        }
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    func profileGet(userId:String) {
        
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument {(document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let userId = document["userId"] as? String ?? ""
                let userName = document["userName"] as? String ?? ""
                let userImage = document["userImage"] as? String ?? ""
//                let userFrontId = document["userFrontId"] as? String ?? ""
                
                UserDefaults.standard.set(userId, forKey: "userId")
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userImage, forKey: "userImage")
//                UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
            } else {
                print("Document does not exist")
                let userImage = self.userImage.randomElement()
                let userName = self.randomString(length: 6)
                
                
                UserDefaults.standard.set(userId, forKey: "userId")
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userImage, forKey: "userImage")
//                UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
                
                let profile = [
                    "admin":false,
                    "userId":userId,
                    "userImage":userImage ?? "",
                    "userName":userName
                ] as [String: Any]
                
                self.db.collection("users").document(userId).collection("Profile").document("profile").setData(profile,merge: true)
                print("ここにセットする")
            }
        }
    }
    

    
    func profileSet(userId:String) {
        
//        zry0f5L5XFLwNVZP
        
        UserDefaults.standard.set(true, forKey: "belongTeam")

        let userImage = self.userImage.randomElement()
        let userName = self.randomString(length: 6)
        
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userImage, forKey: "userImage")
        let profile: [String: Any] = [
            "admin":false,
            "userId":userId,
            "userImage":userImage ?? "",
            "userName":userName
        ]
        db.collection("users").document(userId).collection("Profile").document("profile").setData(profile) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        db.collection("users").document(userId).collection("belong_Team").document("teamId").setData(["teamId":FieldValue.arrayUnion(["zry0f5L5XFLwNVZP"]) ], merge: true)
        db.collection("Team").document("zry0f5L5XFLwNVZP").setData(["membersCount": FieldValue.increment(1.0)], merge: true)

        db.collection("Team").document("zry0f5L5XFLwNVZP").collection("MembersId").document("membersId").setData(["userId": FieldValue.arrayUnion([userId])], merge: true)
        
        
        let Account: [String: Any] = [
            "Entered":true,
            "friends":true,
            "adminaccount":false,
            "この人のuid":userId,
        ]
        
        db.collection("users").document(userId).setData(Account,merge: true)
    }
    
    func presentTabbar(userId:String){
        db.collection("users").document(userId).setData(["nowjikan":FieldValue.serverTimestamp()]as[String:Any], merge:true)
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
//                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
//                let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
//                TabbarController.modalPresentationStyle = .fullScreen
//                self.present(TabbarController, animated: true, completion: nil)
                
                
//                let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
//                let vc = storyboard.instantiateViewController(identifier: "ExplainVC") as! ExplainVC
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
                
                let storyboard = UIStoryboard.init(name: "TeamExplain", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "TeamExplainVC") as! TeamExplainVC
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
//
                
            }
        }
    }
    
    func presentSignIn(userId:String){
        db.collection("users").document(userId).setData(["nowjikan":FieldValue.serverTimestamp()]as[String:Any], merge:true)
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
                let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)//遷移先のStoryboardを設定
                let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") //遷移先のTabbarController指定とIDをここに入力
                SignInViewController.modalPresentationStyle = .fullScreen
                self.present(SignInViewController, animated: true, completion: nil)
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
