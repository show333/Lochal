//
//  ScoreViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/08.
//

import UIKit
import Lottie
import FirebaseFirestore
import FirebaseAuth
import Firebase

class ScoreViewController: UIViewController {
    
    var correctRed : Double = 0.0
    var correctBlue : Double = 0.0
    var correctYellow : Double = 0.0
    var correctPurple : Double = 0.0
    
    var teamname : String?
    let uid = Auth.auth().currentUser?.uid
    var friendsbool : Bool?
    var oyaId: String?
    
    @IBOutlet weak var anatahaLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var detaiLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var sokuteiLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        detailTextView.backgroundColor = .clear
        decideColor()
        detaiLabel.numberOfLines = 0
        
        Firestore.firestore().collection("users").document(uid!).setData(["Entered":true], merge: true)
        
        Firestore.firestore().collection("users").document(uid!).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.friendsbool = document["friends"] as? Bool
                self.oyaId = document["招待した人のID"] as? String
                
                print(self.oyaId!)
                
                Firestore.firestore().collection("users").document(self.oyaId!).collection("invited").document(self.uid!).setData(["invited" :self.uid!], merge: true)
                                
                
                
                
                // violet & orange
                Firestore.firestore().collection("teams").document("orange").getDocument(source: .cache) { (document, error) in
                  if let document = document {
        //            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print(document.data()?["viewcount"] ?? "0")
                    UserDefaults.standard.set(document.data()?["viewcount"] as? Int, forKey: "orangeViewCount")

                  } else {
                    print("Document does not exist in cache")
                  }
                }
                
                Firestore.firestore().collection("teams").document("violet").getDocument(source: .cache) { (document, error) in
                  if let document = document {
        //            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print(document.data()?["viewcount"] ?? "0")
                    UserDefaults.standard.set(document.data()?["viewcount"] as? Int, forKey: "violetViewCount")
                  } else {
                    print("Document does not exist in cache")
                  }
                }
                
                
                
                
                if self.friendsbool == true {
                    UserDefaults.standard.set(true, forKey: "friends")
                } else {
                    UserDefaults.standard.set(false, forKey: "friends")
                }
                
                UserDefaults.standard.set(self.uid, forKey: "userId")
                
            }
        }

    }
    
    
    @IBAction func tappedStartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.modalPresentationStyle = .fullScreen
        
        self.present(TabbarController, animated: true, completion: nil)
        
        Firestore.firestore().collection("users").document(uid!).setData(["nowjikan": FieldValue.serverTimestamp(),"The_earliest":true], merge: true)
        print("なう時間!",FieldValue.serverTimestamp())
        
    }
    
    
    
    
    func decideColor() {
        let CRED = correctRed
        let CBLUE = correctBlue
        let CYELLOW = correctYellow
        let CPURPLE = correctPurple
        
        
        if CPURPLE >= 8 {
            print("purple")
            teamname = "purple"
        } else if CYELLOW >= 5{
            if CBLUE >= 5 {
                if CYELLOW - CBLUE < 0 {
                    print("blue")
                    teamname = "blue"
                    showAnimation(teamnames: teamname!)
                    return
                    
                } else {
                    print("yellow")
                    teamname = "yellow"
                    showAnimation(teamnames: teamname!)
                    return
                }
            }
            if CRED >= 6{
                if CYELLOW - CRED < 0 {
                    print("red")
                    teamname = "red"
                    showAnimation(teamnames: teamname!)
                    return
                } else {
                    print("yellow")
                    teamname = "yellow"
                    showAnimation(teamnames: teamname!)

                    return
                }
            }else {
                print("yellow")
                teamname = "yellow"
                showAnimation(teamnames: teamname!)

                return
            }
                     
            
        } else if CBLUE >= 6{
            if CRED >= 6 {
                if CBLUE + 1 - CRED <= 0 {
                    print("red")
                    teamname = "red"
                    showAnimation(teamnames: teamname!)

                    return
                } else {
                    print("blue")
                    teamname = "blue"
                    showAnimation(teamnames: teamname!)
                    return
                    
                }
            }else {
                print("blue")
                teamname = "blue"
                showAnimation(teamnames: teamname!)
                return
            }
            
        } else if CRED >= 7{
            print("red")
            teamname = "red"
            showAnimation(teamnames: teamname!)
            return
            
        } else {
            print("purple")
            teamname = "purple"
            showAnimation(teamnames: teamname!)
            return
            
        }
        
    }
    
    func showAnimation(teamnames:String) {
        let animationView = AnimationView(name: "packmanload")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .repeat(4.837)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.3
        view.addSubview(animationView)
        
        startButton.layer.cornerRadius = 10
//        startButton.layer.shadowColor = UIColor.startColor.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        startButton.layer.shadowOpacity = 0.7
        startButton.layer.shadowRadius = 10
        
        if teamname == "red" {
            let image1:UIImage = UIImage(named:"redman")!
            self.teamImageView.image = image1
            self.teamNameLabel.text = "RED"
            self.detaiLabel.text = "大きなエネルギーを秘めている。\nコントロールが難しいその才能は\n制御した時、多くの人々を惹きつける。\n \nあなたのチームは\n『レッド』です。"
            startButton.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            UserDefaults.standard.set("red", forKey: "color")
            
            Firestore.firestore().collection("users").document(uid!).setData(["teamname": "red"], merge: true)
            
            
        } else if teamname == "blue" {
            let image1:UIImage = UIImage(named:"blueman")!
            self.teamImageView.image = image1
            self.teamNameLabel.text = "BLUE"
            self.detaiLabel.text = " 決断力と思考力に優れたセンスがある。\n知識や経験が増した時、\n味方に高い安心感を与える。\n \nあなたのチームは\n『ブルー』です。"
            startButton.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            UserDefaults.standard.set("blue", forKey: "color")
            Firestore.firestore().collection("users").document(uid!).setData(["teamname": "blue"], merge: true)
            
            
        } else if teamname == "yellow" {
            let image1:UIImage = UIImage(named:"yellowman")!
            self.teamImageView.image = image1
            self.teamNameLabel.text = "YELLOW"
            self.detaiLabel.text = "幅広い視野を持つ。\n多種多様な個性、環境を受け入れる力を持つため、\nたくさんの人を幸せにする素質を持つ。\n \nあなたのチームは\n『イエロー』です。"
            UserDefaults.standard.set("yellow", forKey: "color")
            Firestore.firestore().collection("users").document(uid!).setData(["teamname": "yellow"], merge: true)
            startButton.tintColor = #colorLiteral(red: 0.9529411793, green: 0.871326245, blue: 0.1333333403, alpha: 1)
            
        } else if teamname == "purple" {
            let image1:UIImage = UIImage(named:"purpleman")!
            self.teamImageView.image = image1
            self.teamNameLabel.text = "PURPLE"
            self.detaiLabel.text = "他とは違う個性が光る。\nその強烈な個性に加え本質を見抜く才能は、\n  開花した時、他者へ大きな影響力を\n発揮する。\n \nあなたのチームは\n『パープル』です。"
            startButton.tintColor = #colorLiteral(red: 0.7549457672, green: 0.5, blue: 1, alpha: 1)
            UserDefaults.standard.set("purple", forKey: "color")
            Firestore.firestore().collection("users").document(uid!).setData(["teamname": "purple"], merge: true)

        }
        
        
        animationView.play { [self] finished in
            if finished {
                sokuteiLabel.text = ""
                animationView.removeFromSuperview()
                redcolors(teamname: teamname!)
            }
        }
    }
    
    func redcolors(teamname: String) {
        
        UIView.animate(withDuration: 3, delay: 1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            // Viewを見えなくする
            //            self.view.alpha = 0.05
            if teamname == "red" {
                self.view.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            } else if teamname == "blue" {
                self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else if teamname == "yellow" {
                self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.871326245, blue: 0.1333333403, alpha: 1)
            } else if teamname == "purple" {
                self.view.backgroundColor = #colorLiteral(red: 0.7549457672, green: 0.5, blue: 1, alpha: 1)
            }

            
        }) { [self] (completed) in
            
            UIView.animate(withDuration: 2.5, delay: 0.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                // Viewを見えなくする
                //            self.view.alpha = 0.05
    //            #colorLiteral(red: 0.9529411793, green: 0.871326245, blue: 0.1333333403, alpha: 1)
                self.detaiLabel.alpha = 1
                self.teamNameLabel.alpha = 1
                self.anatahaLabel.alpha = 1
                self.teamImageView.alpha = 0.7
            }) {(completed) in
                UIView.animate(withDuration: 2.0, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
   
                    self.startButton.alpha = 0.9
                })

            }
            
        }
    }
}


