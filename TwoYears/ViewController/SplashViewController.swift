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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser?.uid
        
        
        if uid != nil {
            profileGet(userId:uid ?? "")
        } else {
            presentSignInVC() 
        }
    }


    func profileGet(userId:String) {
        
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let userName = document["userName"] as? String ?? ""
                let userImage = document["userImage"] as? String ?? ""
                let userFrontId = document["userFrontId"] as? String ?? ""
                let UEnterdBool = document["UEnterdBool"] as? Bool ?? false

                
                print("あいあいあい",userName)
                print("あいあい",userImage)
                print("あいあいあ",userId)
                
                if UEnterdBool == true {
                    if userName != "" && userImage != "" && userFrontId != "" {
                        presentTabbar(userId: userId)
                        UserDefaults.standard.set(userId, forKey: "userId")
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(userImage, forKey: "userImage")
                        UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
                        
                    } else {
                        presentExplain()
                    }
                } else {
                    presentSignInVC()
                }
                
                
                
                
            } else {
                print("Document does not exist")
                
                presentSignInVC()
            }
        }
    }
    
    func presentSignInVC() {
        let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
        let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        SignInViewController.modalPresentationStyle = .fullScreen
        self.present(SignInViewController, animated: true, completion: nil)
    }
    
    func presentTabbar(userId:String){
        let userToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")

        db.collection("users").document(userId).setData(["currentTime":FieldValue.serverTimestamp(),"fcmToken":userToken ?? ""]as[String:Any], merge:true)
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
                let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                TabbarController.modalPresentationStyle = .fullScreen
                self.present(TabbarController, animated: true, completion: nil)
            }
        }
    }

    func presentExplain(){
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
                let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ExplainVC") as! ExplainVC
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("スプラッシュ")
        
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
