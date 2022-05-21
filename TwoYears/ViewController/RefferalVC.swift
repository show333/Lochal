//
//  RefferalVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class RefferalVC : UIViewController {
    
    let db = Firestore.firestore()
    var referralCount = 0
    
    
    @IBOutlet weak var codeLabel: CopyUILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var hakkoLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var createRefferalButton: UIButton!
    @IBAction func createRefferalTappedButton(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let referralNum = referralCount-1
        
        makeReferralId()
        labelAnimation()
        
        countLabel.text = "残り招待コード\(String(referralNum))"

        
    }
    
    func makeReferralId() {
        let randomId = randomString(length: 8)
        guard let uid = Auth.auth().currentUser?.uid else { return }
                let referralDoc = [
            "createdAt": FieldValue.serverTimestamp(),
            "userId": uid,
            "usedBool": false,
            "referralId":randomId,
        ] as [String : Any]
        db.collection("ReferralId").document(randomId).setData(referralDoc)
        db.collection("users").document(uid).setData(["referralCount": FieldValue.increment(-1.0)],merge: true)

        codeLabel.text = randomId
    }
    
    func labelAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.explainLabel.alpha = 1
            self.codeLabel.alpha = 1
            self.hakkoLabel.alpha = 0
            self.createRefferalButton.alpha = 0
            self.backGroundView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0)
//
//
        }) { bool in
        // ②アイコンを大きくする
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.explainLabel.alpha = 1

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.2, delay: 4, animations: {
                self.explainLabel.alpha = 0

            })
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
    }

 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countLabel.text = "残り招待コード\(String(referralCount))"
        setSwipeBack()
        
        backImageView.layer.cornerRadius = 20
        backImageView.clipsToBounds = true
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_share_link_qtxe.png?alt=media&token=90f34241-25cf-4913-add9-c2108ee80513") {
            Nuke.loadImage(with: url, into: backImageView)
        } else {
            backImageView?.image = nil
        }
        
        codeLabel.alpha = 0
        explainLabel.alpha = 0


        
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.masksToBounds = false
        backGroundView.layer.cornerRadius = 20
        backGroundView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backGroundView.layer.shadowOpacity = 0.7
        backGroundView.layer.shadowRadius = 5

    }
}
