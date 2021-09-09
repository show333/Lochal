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
            Firestore.firestore().collection("teams").document("orange").getDocument{ (document, error) in
              if let document = document {
                print("ビューカウント！！！！",document.data()?["viewcount"] ?? "0")
                UserDefaults.standard.set(document.data()?["viewcount"] as? Int, forKey: "orangeViewCount")
              } else {
                print("Document does not exist in cache")
              }
            }
            Firestore.firestore().collection("teams").document("violet").getDocument{ (document, error) in
              if let document = document {
                print("ビューカウント！！！",document.data()?["viewcount"] ?? "0")
                UserDefaults.standard.set(document.data()?["viewcount"] as? Int, forKey: "violetViewCount")
                
              } else {
                print("Document does not exist in cache")
              }
            }
            Firestore.firestore().collection("users").whereField("招待した人のID", isEqualTo: uid!).whereField("Entered", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    Firestore.firestore().collection("users").document(uid!).setData(["invitedCount":querySnapshot!.documents.count],merge: true)
                }
            }
            Firestore.firestore().collection("users").document(uid!).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    
                    let teamcolor = document["teamname"] as? String ?? "none"
                    let email = document["この人のアドレス"] as? String ?? "none"
                    let userid = document["この人のuid"] as? String ?? "none"
                    let friends = document["friends"] as? Bool ?? false
                    let userBrands = document["userBrands"] as? String ?? "none"
                    let viewtcount = document["viewcount"] as? Int ?? 0
                    let goodcount = document["goodcount"] as? Int ?? 0
                    let earliest = document["The_earliest"] as? Bool ?? false
                    let founder = document["Founder"] as? Bool ?? false
                    let company1Id = document["company1"] as? String?
                    
                    if let company1Id = company1Id {
                        UserDefaults.standard.set(company1Id, forKey: "company1Id")
                    } else {
                        print("a")
                    }
                    if founder != true {
                        Firestore.firestore().collection("users").document(document["招待した人のID"] as? String ?? "none").getDocument { (document, error) in
                            if let document = document, document.exists {
                                let companyId = document["company1"] as? String ?? nil
                                if companyId != nil {
                                    func randomString(length: Int) -> String {
                                        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                                        return String((0..<length).map{ _ in characters.randomElement()! })
                                    }
                                    let randamUserName = randomString(length: 10)
                                    Firestore.firestore().collection("users").document(uid!).setData(["company1":companyId!,"userImage1":self.userImage[self.randamUserImageInt!],"userName1": randamUserName] as [String : Any] , merge: true)
                                    self.firebaseCompany.document(companyId!).collection("userColor").document("company_1_Color").updateData([teamcolor + "User": FieldValue.increment(Int64(1))])
                                    let userDate = [
                                        "JoindTime": FieldValue.serverTimestamp(),
                                        "uid":uid!,
                                        "userColor": teamcolor,
                                        "userBrands": userBrands,
                                        "userImage1": self.userImage[self.randamUserImageInt!],
                                        "userName1": randamUserName,
                                        "belong": true
                                        
                                    ] as [String: Any]
                                    
                                    self.firebaseCompany.document(companyId!).collection("members").document(uid!).setData(userDate)
                                }
                            }
                        }
                    }
                    print(document["teamname"] as? String ?? "none")
                    if teamcolor == "red" || teamcolor == "blue" || teamcolor == "yellow" || teamcolor == "purple" {
                        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                        TabbarController.modalPresentationStyle = .fullScreen
                        TabbarController.color = teamcolor
                        
                        if UserDefaults.standard.bool(forKey: "friends") != true || false {
                            if friends == true {
                                UserDefaults.standard.set(true, forKey: "friends")
                            } else {
                                UserDefaults.standard.set(false, forKey: "friends")
                            }
                        } else {
                        }
                        UserDefaults.standard.set(teamcolor, forKey: "color")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(userid, forKey: "userid")
                        UserDefaults.standard.set(friends, forKey: "friends")
                        UserDefaults.standard.set(uid, forKey: "userId")
                        UserDefaults.standard.set(userBrands, forKey: "userBrands")
                        UserDefaults.standard.set(viewtcount, forKey: "userviewcount")
                        UserDefaults.standard.set(goodcount, forKey: "usergoodcount")
                        UserDefaults.standard.set(earliest, forKey: "earliest")
                        Firestore.firestore().collection("users").document(uid!).setData(["nowjikan": FieldValue.serverTimestamp()], merge: true)
                        UIView.animate(withDuration: 0.4, delay: 0, animations: {
                            self.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            self.subTitleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            self.view.alpha = 0.9
                            
                            if teamcolor == "red" {
                                self.view.backgroundColor = #colorLiteral(red: 1, green: 0.249650467, blue: 0, alpha: 1)
                            } else if teamcolor == "blue" {
                                self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                            } else if teamcolor == "yellow" {
                                self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.871326245, blue: 0.1333333403, alpha: 1)
                            } else if teamcolor == "purple" {
                                self.view.backgroundColor = #colorLiteral(red: 0.7549457672, green: 0.5, blue: 1, alpha: 1)
                            }
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
                        let storyboard: UIStoryboard = UIStoryboard(name: "WhichOne", bundle: nil)//遷移先のStoryboardを設定
                        let WhichOneViewController = storyboard.instantiateViewController(withIdentifier: "WhichOneViewController") //遷移先のTabbarController指定とIDをここに入力
                        WhichOneViewController.modalPresentationStyle = .fullScreen
                        
                        UIView.animate(withDuration: 0.4, delay: 0, animations: {
                            self.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            self.subTitleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

                            self.view.alpha = 0.9
                            
                        }) { bool in
                        // ②アイコンを大きくする
                            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                                self.titleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                                self.titleLabel.alpha = 0
                                self.subTitleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                                self.subTitleLabel.alpha = 0

                            }) { bool in
                                self.present(WhichOneViewController, animated: true, completion: nil)

                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)//遷移先のStoryboardを設定
            let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") //遷移先のTabbarController指定とIDをここに入力
            SignInViewController.modalPresentationStyle = .fullScreen

            UIView.animate(withDuration: 0.4, delay: 0, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.view.alpha = 0.9
            }) { bool in
            // ②アイコンを大きくする
                UIView.animate(withDuration: 0.15, delay: 0, animations: {
                    self.titleLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.titleLabel.alpha = 0
                }) { bool in
                    self.present(SignInViewController, animated: true, completion: nil)

                }
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
