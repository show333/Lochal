//
//  ShoutaiHakkou.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/07.
//

import UIKit
import Firebase
import FirebaseAuth
import Lottie
import SwiftMoment
import FirebaseFirestore

class ShoutaiHakkou: UIViewController {
    
    //　タイムスタンプの取得回数を減らすため
    var jigen : Timestamp?
    
    @IBOutlet weak var hakkoButton: UIButton!
    
    //戻るボタン
    @IBAction func BubuButton(_ sender: Any) {

        presentingViewController!.dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var hakkoLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hellowButton: UIButton!
    @IBAction func hellowfriendsButton(_ sender: Any) {
        logout()
        sinkiki(friendsbool:true)
        print("プリンプリン")
    }
    @IBOutlet weak var beforeexplainLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var underLabel: UILabel!
    
    @IBOutlet weak var myidLabel: UILabel!
    
    @IBOutlet weak var thisaccountLabel: UILabel!
    
    // 一度ログアウトを行う処理を書くためここで一回IDを取得
    let oyaId = Auth.auth().currentUser!.uid as String
    
    @IBAction func hakkouTappedButton(_ sender: Any) {
        logout() //ログアウト
        sinkiki(friendsbool: false) //ID発行とサインイン処理
    }
    
    //ログアウト
    func logout() {
        self.hakkoButton.isHidden = true
        do{
            try  Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error singing out : %@", signOutError)
        }
        print("1ログアウト後", oyaId)
    }
    
    //ID発行とサインイン処理
    func sinkiki(friendsbool:Bool) {
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        
        let sinkiId = randomString(length: 10)
        
        let email = sinkiId + "@2.years"
        UserDefaults.standard.set(sinkiId, forKey: "invited")
        

        let nowdate: Date = jigen!.dateValue()
        
        let nowmoment = moment(nowdate)
        
        let twoweeks = nowmoment +  1.days
        
        let twodate = twoweeks.date
        
        print("2",email)
        print("3親ID", oyaId)
//        アカウント作成
        Auth.auth().createUser(withEmail: email, password: "ONELIFE") { (res, err) in
            if let err = err {
                print("失敗やで、、、\(err)")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("4成功！！！", uid)

            let docData = [
                "招待した人のID": self.oyaId,
                "jikan": FieldValue.serverTimestamp(),
                "invitedtime": twodate,
                "teamname": "none",
                "この人のアドレス": sinkiId,
                "この人のuid": uid,
                "friends": friendsbool,
                "adminaccount": false,
                "mymessage": ""
            ]
                as [String : Any]

            print("5uid", uid)
            
            
            //アカウントをfirestoreに保存
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("firestore保存が失敗、、\(err)")
                    return
                }
                print("6成功！")
            }
        }
        print("7Firestoreに記述したで！！oya", oyaId)
        //        showAnimation()
        
        //        func showAnimation() {
        
        //アニメーション開始
        self.hakkoLabel.alpha = 0
        self.backButton.alpha = 0
        self.beforeexplainLabel.alpha = 0
        self.thisaccountLabel.alpha = 0
        self.myidLabel.alpha = 0
        self.address.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.view.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.7730132999, blue: 0.6565710616, alpha: 1)
        })
        
        let animationView = AnimationView(name: "goodloadingcolor")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        //         animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.6
        
        view.addSubview(animationView)
        
        
        //アニメーション終了
        animationView.play { finished in
            if finished {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.view.backgroundColor = #colorLiteral(red: 0.07889355443, green: 0.04010983246, blue: 0.007999785959, alpha: 0.9072131849)
                })
                self.hakkoLabel.text = sinkiId
                self.backButton.alpha = 1
                self.hakkoLabel.alpha = 1
                self.beforeexplainLabel.alpha = 1
                self.thisaccountLabel.alpha = 1
                self.myidLabel.alpha = 1
                self.underLabel.alpha = 0
                self.address.alpha = 1
                self.beforeexplainLabel.text = "上のIDを友達に送ってください！" 
                animationView.removeFromSuperview()
                
                //元々のIDでログイン
                self.login()
            }
        }
        
        //        }
        
    }
    
    
    func login() {
        
        //　友達だった場合発行ボタンが即使用可能になる
        if UserDefaults.standard.bool(forKey: "friends") == false {
            underLabel.alpha = 1
        } else {
            self.hakkoButton.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
            }) { [self] (completed) in
                UIView.animate(withDuration: 0.2, delay: 2, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.explainLabel.alpha = 0
                })
            }
        }
        
        //元々のIDでのサインイン
        let email = UserDefaults.standard.string(forKey: "email")
        Auth.auth().signIn(withEmail: email! + "@2.years", password: "ONELIFE") { (res, err) in
            if let err = err {
                print("ログイン失敗、、、:", err)
                return
            }
            let nowdate: Date = self.jigen!.dateValue()
            let nowmoment = moment(nowdate)
            let twoweeks = nowmoment +  14.days
            let twodate = twoweeks.date
            
            //　発行ボタンを押した後、2週間後に使用可能になるように時間を設定
            Firestore.firestore().collection("users").document(self.oyaId).setData(["invitedtime":twodate], merge: true) { (err) in
                if let err = err {
                    print("firestore保存が失敗、、\(err)")
                    return
                }
                print("6成功！")
            }
            
            print("8サインイン後のID", self.oyaId)
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = #colorLiteral(red: 0.07889355443, green: 0.04010983246, blue: 0.007999785959, alpha: 1)
//        #colorLiteral(red: 0.07889355443, green: 0.04010983246, blue: 0.007999785959, alpha: 0.9072131849)
        let invited = UserDefaults.standard.string(forKey: "invited")
        let email = UserDefaults.standard.string(forKey: "email")
        print(UserDefaults.standard.bool(forKey: "friends"))
        
            
        hakkoLabel.text = invited!
        myidLabel.text = "My Id :" + email!
//        myidLabel.text = "Accountname"
        
        hakkoLabel.layer.cornerRadius = 5
        hakkoLabel.clipsToBounds = true

        hakkoButton.layer.cornerRadius = 15
        hakkoButton.layer.shadowColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        hakkoButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        hakkoButton.layer.shadowOpacity = 0.7
        hakkoButton.layer.shadowRadius = 20

        //　友達かどうかをここで判定
        Firestore.firestore().collection("users").document(oyaId).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let friends = document["friends"] as! Bool
                let adminaccount = document["adminaccount"] as! Bool
                
                let invitedjikan = document["invitedtime"] as! Timestamp
                jigen = document["nowjikan"] as? Timestamp
                
                print(invitedjikan)
                
                let nowjikandate: Date = jigen!.dateValue()
                let nowjikanmoment = moment(nowjikandate)
               
                let inviteddate: Date = invitedjikan.dateValue()
                print("dddddddddddddddddddd",inviteddate)
                
                let invitedmoment = moment(inviteddate)
                print("mmmmmmmmmmmmmmmmmmm",invitedmoment)
                
                if adminaccount == true {
                    UserDefaults.standard.set("", forKey: "invited")
                    hellowButton.alpha = 1
                }
                
                //友達ではない時
                if friends == false {
                    // 招待可能な期間かどうか　[可能]
                    if nowjikanmoment > invitedmoment {
                        self.hakkoButton.isHidden = false
                        UserDefaults.standard.set("", forKey: "invited")
                        // 招待可能な期間かどうか　[不可]
                    } else {
                        self.hakkoButton.isHidden = true
                        underLabel.alpha = 1
                        beforeexplainLabel.alpha = 0
                        
                        
                        //余裕ある時修正
                        if invitedmoment >= nowjikanmoment + 14.days {
                            underLabel.text = "14日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 13.days {
                            underLabel.text = "13日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 12.days {
                            underLabel.text = "12日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 11.days {
                            underLabel.text = "11日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 10.days {
                            underLabel.text = "10日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 9.days {
                            underLabel.text = "9日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 8.days {
                            underLabel.text = "8日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 7.days {
                            underLabel.text = "7日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 6.days {
                            underLabel.text = "6日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 5.days {
                            underLabel.text = "5日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 4.days {
                            underLabel.text = "4日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 3.days {
                            underLabel.text = "3日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 2.days {
                            underLabel.text = "2日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 1.hours {
                            underLabel.text = "1日後に\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 12.hours {
                            underLabel.text = "半日後、\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 12.hours {
                            underLabel.text = "半日後、\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 1.hours {
                            underLabel.text = "数時間後、\n一人分の招待が可能になります"
                        } else if invitedmoment >= nowjikanmoment + 10.minutes {
                            underLabel.text = "後数分で一人分の招待が可能になります"
                        }
                        
                    }
                    
                } else {
                    // 友達の時は毎回可能にする
                    UserDefaults.standard.set("", forKey: "invited")
                    thisaccountLabel.alpha = 1
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
