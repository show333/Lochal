//
//  MyAccountViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/06/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase
import Nuke


class MyAccountViewController: UIViewController {
    
    
    var companyId : String?
    var UserId : String?
    
    let uid = Auth.auth().currentUser?.uid
    let userviewcount = UserDefaults.standard.integer(forKey: "userviewcount")
    let usergoodcount = UserDefaults.standard.integer(forKey: "usergoodcount")
    let userBrands = UserDefaults.standard.string(forKey: "userBrands")
    let teamColor = UserDefaults.standard.string(forKey: "color")
    let earliest = UserDefaults.standard.bool(forKey: "earliest")
    
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyView: UIImageView!
    
    @IBOutlet weak var companyBackView: UIView!
    
    @IBAction func tappedCompanyBack(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Company", bundle: nil)
        let CompanyViewController = storyboard.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
        CompanyViewController.UserId = UserId
        navigationController?.pushViewController(CompanyViewController, animated: true)

        print("aaaaa")
    }
    
    //UserSelf画面遷移
    @IBAction func UserSelfTapp(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserSelf", bundle: nil)
        let UserSelfViewController = storyboard.instantiateViewController(withIdentifier: "UserSelfViewController") as! UserSelfViewController
        UserSelfViewController.companyId = companyId
        navigationController?.pushViewController(UserSelfViewController, animated: true)
    }
    
    
    
    @IBOutlet weak var kinsiView: UIView!
    @IBOutlet weak var kinsiLabel: UILabel!
    
    @IBOutlet weak var companyFrontView: UIView!
    @IBOutlet weak var companyTapCanLabel: UILabel!
    
    @IBOutlet weak var companyName: UILabel!
    
    
    @IBOutlet weak var userTapCanLabel: UILabel!
    
    @IBOutlet weak var originImageView: UIImageView!
    @IBOutlet weak var TGImageView: UIImageView!
    
    @IBOutlet weak var teamColorLabel: UILabel!
    
    @IBOutlet weak var brandsLogoLabel: UILabel!
    
    @IBOutlet weak var labelsView: UIView!
    
    @IBOutlet weak var originBackView: UIView!
    
    @IBOutlet weak var TGBackView: UIView!
    @IBOutlet weak var TGBack2View: UIView!
    
    
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    

    
    @IBOutlet weak var allBackView: UIView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firestore.firestore().collection("users").document(uid!).getDocument{ [self] (document, error) in
            if let document = document {
                let company1 = document.data()?["company1"] as? String ?? "none"
                let userName1 = document.data()?["userName1"] as? String ?? "none"
                let invitedCount : Int = document.data()?["invitedCount"] as! Int
                let founder = document["Founder"] as? Bool ?? false
                
                UserId = userName1
                self.threeLabel.text = "紹介人数 : " + String(invitedCount)
                
                companyId = company1
                
                if company1 != "none" || invitedCount >= 2{
                    
                    self.kinsiView.alpha = 0
                    print("俺以外やわ",company1)
                    
                    if company1 != "none" {
                        self.firebaseCompany.document(company1).getDocument{ (document, error) in
                            if let document = document {
                                let companyImage1 = document.data()?["companyLogoImage"]
                                let companyfounder = document.data()?["Founder"]
                                let companyName = document.data()?["companyName"] ?? nil
                                
                                self.companyName.text = (companyName as! String)
                                
                                if let url = URL(string: companyImage1 as! String) {
                                    Nuke.loadImage(with: url, into: self.companyView)
                                }
                                
                                if uid == companyfounder as? String {
                                    self.fourLabel.text = "Company : 『" + (companyName as! String) + "』 設立者"
                                    
                                    companyBackView.layer.masksToBounds = false
                                    companyBackView.layer.shadowColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
                                    companyBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
                                    companyBackView.layer.shadowOpacity = 0.9
                                    companyBackView.layer.shadowRadius = 5
                                    
                                    companyFrontView.alpha = 0
                                    companyTapCanLabel.alpha = 1
                                    
                                } else {
                                    self.fourLabel.text = "Company : 『" + (companyName as! String) + "』 所属"
                                    companyTapCanLabel.alpha = 0
                                }
                            }
                        }
                    }
                    
                    
                    if founder != true {
                        companyFrontView.alpha = 0
                        companyTapCanLabel.alpha = 1
                        
                        companyBackView.layer.masksToBounds = false
                        companyBackView.layer.shadowColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
                        companyBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
                        companyBackView.layer.shadowOpacity = 0.9
                        companyBackView.layer.shadowRadius = 5
                        
                        
                    }
                    
                } else {
                    self.fourLabel.text = "Company : 無所属"
                }
                
                if userName1 != "none" {
                    let userImage1 = document.data()?["userImage1"]
                    
                    if let url = URL(string: userImage1 as! String) {
                        Nuke.loadImage(with: url, into: self.originImageView)
                    }
                    
                    self.nameLabel.text = (userName1)
                    
                }
                
                
            } else {
                print("Document does not exist in cache")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        kinsiLabel.text = "紹介人数が2人以上でオリジナルチームを\n作成可能になります\n(あなたが紹介したユーザーは\n同じオリジナルチームに所属されます)"
        
        kinsiView.clipsToBounds = true
        kinsiView.layer.cornerRadius = 20
        
        allBackView.clipsToBounds = true
        allBackView.layer.cornerRadius = 30
        

        companyBackView.clipsToBounds = true
        companyBackView.layer.cornerRadius = 20
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        companyView.layer.cornerRadius = 35
        companyView.backgroundColor = .systemGray2
        
        originBackView.clipsToBounds = true
        originBackView.layer.cornerRadius = 18
        originBackView.layer.masksToBounds = false
        originBackView.layer.shadowColor = UIColor.black.cgColor
        originBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        originBackView.layer.shadowOpacity = 0.7
        originBackView.layer.shadowRadius = 5
        
        TGBackView.clipsToBounds = true
        TGBackView.layer.cornerRadius = 20
        TGBack2View.clipsToBounds = true
        TGBack2View.layer.cornerRadius = 20
        
        labelsView.clipsToBounds = true
        labelsView.layer.cornerRadius = 25
        
        originImageView.clipsToBounds = true
        originImageView.layer.cornerRadius = 35
        
        originImageView.backgroundColor = .systemGray2
        
        TGImageView.clipsToBounds = true
        TGImageView.layer.cornerRadius = 35
        
        if earliest == true {
            fiveLabel.alpha = 1
        } else {
            fiveLabel.alpha = 0
        }
        
        oneLabel.text = "見られた数 : " + String(userviewcount)
        twoLabel.text = "いいね数 : " + String(usergoodcount)
        threeLabel.text = "紹介数"
        fiveLabel.text = "The_earliest_user:true"
        
        
        if teamColor == "red" {
            teamColorLabel.text = "あなたの色は　Red です"
            TGBackView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
                TGBack2View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6014554795)
        } else if teamColor == "yellow" {
            teamColorLabel.text = "あなたの色は　Yellow です"
            TGBackView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                TGBack2View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4078553082)
        } else if teamColor == "blue" {
            teamColorLabel.text = "あなたの色は Blue です"
            TGBackView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 1, alpha: 1)
                TGBack2View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        } else if teamColor == "purple" {
            teamColorLabel.text = "あなたの色は　Purple です"
            TGBackView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                TGBack2View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5122377997)
        }
        
        
        
        if userBrands == "TG1" {
            TGImageView.image = UIImage(named:"TG1")!
            brandsLogoLabel.text = "icon:HeadPhone"
            
        } else if userBrands == "TG2" {
            TGImageView.image = UIImage(named:"TG2")!
            brandsLogoLabel.text = "アイコン:Lucky"
            
        } else if userBrands == "TG3" {
            TGImageView.image = UIImage(named:"TG3")!
            brandsLogoLabel.text = "アイコン:Safari"
            
        } else if userBrands == "TG4" {
            TGImageView.image = UIImage(named:"TG4")!
            brandsLogoLabel.text = "アイコン:Magic"
            
        } else if userBrands == "TG5" {
            TGImageView.image = UIImage(named:"TG5")!
            brandsLogoLabel.text = "アイコン:Fox"
        }
        
   
        
        
        
        

    }
}
