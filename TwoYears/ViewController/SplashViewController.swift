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
    
    @IBOutlet weak var titleLeftLabel: UILabel!
    @IBOutlet weak var leftLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleCenterLabel: UILabel!
    
    @IBOutlet weak var titleRightLabel: UILabel!
    @IBOutlet weak var rightLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser?.uid


        if uid != nil {
            profileGet(userId:uid ?? "")
        } else {
            presentSignInVC()
        }
//        let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "selectAreaVC") as! selectAreaVC
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
//        let storyboard = UIStoryboard.init(name: "AreaRanking", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "AreaRankingVC") as! AreaRankingVC
//        vc.modalPresentationStyle = .fullScreen
//
//        self.present(vc, animated: true, completion: nil)
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
                let areaNameEn = document["areaNameEn"] as? String ?? "tokyo"
                let areaNameJa = document["areaNameJa"] as? String ?? "東京"


                
                
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
//                    UserDefaults.standard.set(self.userId, forKey: "connectingUserId")
                }
            }
        }
    }
    
    func presentSignInVC() {
        
        UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
            
            titleRightLabel.alpha = 1
            titleLeftLabel.alpha = 1
            let ConstraintCGfloat:CGFloat = 5.0
            titleRightLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)

            let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*15)
            titleCenterLabel.transform = transScale
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                
                let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*200)
                titleCenterLabel.transform = transScale
                
                let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180*90)
                titleCenterLabel.transform = transScaleSeconds
                let transScaleThird = CGAffineTransform(rotationAngle: CGFloat.pi/180*350)
                titleCenterLabel.transform = transScaleThird
                
                
                let ConstraintCGfloat:CGFloat = 30
                titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            }) { bool in
                UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                    
                    subTitleLabel.alpha = 1
                    let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180)
                    titleCenterLabel.transform = transScaleSeconds
                    
                    
                    let ConstraintCGfloat:CGFloat = 25
                    titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                    titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
                    
                }) { bool in
                    UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
                        titleCenterLabel.alpha = 0
                        titleLeftLabel.alpha = 0
                        titleRightLabel.alpha = 0
                        subTitleLabel.alpha = 0
                    })
                    let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
                    let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    SignInViewController.modalPresentationStyle = .fullScreen
                    self.present(SignInViewController, animated: true, completion: nil)
                }
            }
        }

    }
    
    func presentTabbar(userId:String){
        let userToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        db.collection("users").document(userId).setData(["currentTime":FieldValue.serverTimestamp(),"fcmToken":userToken ?? ""]as[String:Any], merge:true)
        
        UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
            
            titleRightLabel.alpha = 1
            titleLeftLabel.alpha = 1
            let ConstraintCGfloat:CGFloat = 5.0
            titleRightLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)

            let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*15)
            titleCenterLabel.transform = transScale
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                
                let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*200)
                titleCenterLabel.transform = transScale
                
                let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180*90)
                titleCenterLabel.transform = transScaleSeconds
                let transScaleThird = CGAffineTransform(rotationAngle: CGFloat.pi/180*350)
                titleCenterLabel.transform = transScaleThird
                
                
                let ConstraintCGfloat:CGFloat = 30
                titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            }) { bool in
                UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                    
                    subTitleLabel.alpha = 1
                    let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180)
                    titleCenterLabel.transform = transScaleSeconds
                    
                    
                    let ConstraintCGfloat:CGFloat = 25
                    titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                    titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
                    
                }) { bool in
                    UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
                        titleCenterLabel.alpha = 0
                        titleLeftLabel.alpha = 0
                        titleRightLabel.alpha = 0
                        subTitleLabel.alpha = 0
                    })
                    let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                    let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                    TabbarController.selectedIndex = 0
                    TabbarController.modalPresentationStyle = .fullScreen
                    self.present(TabbarController, animated: true, completion: nil)
                }
            }
        }
    }

    func presentExplain(){
        
        UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
            
            titleRightLabel.alpha = 1
            titleLeftLabel.alpha = 1
            let ConstraintCGfloat:CGFloat = 5.0
            titleRightLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)

            let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*15)
            titleCenterLabel.transform = transScale
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                
                let transScale = CGAffineTransform(rotationAngle: CGFloat.pi/180*200)
                titleCenterLabel.transform = transScale
                
                let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180*90)
                titleCenterLabel.transform = transScaleSeconds
                let transScaleThird = CGAffineTransform(rotationAngle: CGFloat.pi/180*350)
                titleCenterLabel.transform = transScaleThird
                
                
                let ConstraintCGfloat:CGFloat = 30
                titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
            }) { bool in
                UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
                    
                    subTitleLabel.alpha = 1
                    let transScaleSeconds = CGAffineTransform(rotationAngle: CGFloat.pi/180)
                    titleCenterLabel.transform = transScaleSeconds
                    
                    
                    let ConstraintCGfloat:CGFloat = 25
                    titleRightLabel.transform = CGAffineTransform(translationX: 0, y: -ConstraintCGfloat)
                    titleLeftLabel.transform = CGAffineTransform(translationX: 0, y: ConstraintCGfloat)
                    
                }) { bool in
                    UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
                        titleCenterLabel.alpha = 0
                        titleLeftLabel.alpha = 0
                        titleRightLabel.alpha = 0
                        subTitleLabel.alpha = 0
                    })
                    let storyboard = UIStoryboard.init(name: "Explain", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "ExplainVC") as! ExplainVC
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                } 
            }
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("スプラッシュ")


//        let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
//        titleWithFontLabel.transform = transScale
        
        
        titleRightLabel.alpha = 0
        titleLeftLabel.alpha = 0
        
        let ConstraintCGfloat:CGFloat = 25
        rightLabelConstraint.constant = ConstraintCGfloat
        
        leftLabelConstraint.constant = -ConstraintCGfloat
        
        
        subTitleLabel.alpha = 0
        
        
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
