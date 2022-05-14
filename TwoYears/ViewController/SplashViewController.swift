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
    var userId:[String] = []
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let mainBoundSize = UIScreen.main.bounds.size
        let mainBoundSizeHeight = mainBoundSize.height
        print("添えフィ潮江jf",mainBoundSizeHeight)

        let fractionHight = mainBoundSizeHeight/10
        let ConstraintCGfloat:CGFloat = fractionHight
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)

        UIView.animate(withDuration: 0.2, delay: 0, animations: { [self] in
            //            self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.logoImageView.alpha = 1

            let fractionHight = mainBoundSizeHeight/10
            let ConstraintCGfloat:CGFloat = fractionHight + 20
            logoImageView.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in

                let fractionHight = mainBoundSizeHeight/10
                let ConstraintCGfloat:CGFloat = 10
                logoImageView.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)

            }) { bool in
                UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in

                    let ConstraintCGfloat:CGFloat = 0
                    logoImageView.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)

                    let uid = Auth.auth().currentUser?.uid
                    if uid != nil {
                        profileGet(userId:uid ?? "")
                    } else {
                        presentSignInVC()
                    }

                })
            }
        }
//                let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
//                let vc = storyboard.instantiateViewController(identifier: "selectAreaVC") as! selectAreaVC
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
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
                let areaNameEn = document["areaNameEn"] as? String
                let areaNameJa = document["areaNameJa"] as? String
                
                print("あいあいあい",userName)
                print("あいあい",userImage)
                print("あいあいあ",userId)
                
                if UEnterdBool == true {
                    
                    if userName != "" && userImage != "" && userFrontId != "" {
                        
                        presentTabbar(userId: userId)
                        getConnection(uid:userId)
                        UserDefaults.standard.set(userId, forKey: "userId")
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(userImage, forKey: "userImage")
                        UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
                        
                        print("青背Jふぉいせじゃ",areaNameEn)
                        
                        UserDefaults.standard.set(areaNameEn, forKey: "areaNameEn")
                        UserDefaults.standard.set(areaNameJa, forKey: "areaNameJa")
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
    
    func getConnection(uid:String) {
        db.collection("users").document(uid).collection("Connections").whereField("status", isEqualTo: "accept").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        self.userId.append(userId)
                    }
                    print("usseserser",self.userId)
                    self.db.collection("users").document(uid).setData(["connectingUserId":self.userId] as [String : Any], merge: true)
                    UserDefaults.standard.set(self.userId, forKey: "connectingUserId")
                    print("青市へフィオアセjフォイアジェヲイfjアセおいfじゃ教えjfおいあせjfおいあせじぇf",UserDefaults.standard.object(forKey: "connectingUserId") ?? "")
                }
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
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.selectedIndex = 0
        TabbarController.modalPresentationStyle = .fullScreen
        self.present(TabbarController, animated: true, completion: nil)
    }
    
    func presentExplain(){
        let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ExplainVC") as! ExplainVC
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("スプラッシュ")
        
        
        logoImageView.alpha = 0

        
        
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
