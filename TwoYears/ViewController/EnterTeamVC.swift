//
//  EnterTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EnterTeamVC: UIViewController {
    
    var skipBool = false
    var teamName:String?
    var teamFrontId:String?
    var teamImage:String?
    var Founder:String?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var teamIdField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBAction func tappedEnterButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let teamId = teamIdField.text ?? ""
        getsTeamInfo(teamId:teamId,uid:uid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getsTeamInfo(teamId:String,uid:String){
        db.collection("Team").whereField("teamId", isEqualTo: teamId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let teamBoolCount : Int = querySnapshot?.documents.count ?? 0
                    if teamBoolCount == 0 {
                        print("nothing")
                        DispatchQueue.main.async(execute: { () -> Void in
                                self.explainLabel.text = "このIDは招待されたIDと異なります。"
                                
                                UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                    self.explainLabel.alpha = 1
                                    
                                }) {(completed) in
                                    
                                    UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                        self.explainLabel.alpha = 0
                                    })
                                }
                            })
                    } else if teamBoolCount == 1{
                        
                            for document in querySnapshot!.documents {
                                teamName = document.data()["teamName"] as? String
                                teamFrontId = document.data()["teamFrontId"] as? String
                                teamImage = document.data()["teamImage"] as? String
                                Founder = document.data()["Founder"] as? String
                                self.checkTeamUser(teamId: teamId,uid: uid)

                            }
                    } else {
                        print("IDが重複している可能性がありますラベルで")
                    }
                }
            }
    }
    
    func checkTeamUser(teamId:String,uid:String) {
        
        db.collection("Team").document(teamId).collection("MembersId").whereField("userId", isEqualTo: uid).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 == 0{
                    enterTeam(teamId: teamId, uid: uid)
                } else {
                    print("入ってます")
                }
            }
        }
    }
    
    
    
    func enterTeam(teamId:String,uid:String) {
        
        let userName: String? =  UserDefaults.standard.string(forKey: "userName")
        let userImage: String? = UserDefaults.standard.string(forKey: "userImage")
        let userFrontId: String? = UserDefaults.standard.string(forKey: "userFrontId")
        
        let userInfo = [
            "createdAt": FieldValue.serverTimestamp(),
            "userId":uid,
            "userFrontId":userFrontId ?? "",
            "userName": userName ?? "",
            "userImage": userImage ?? "",
            "admin": false
        ] as [String:Any]
        
        let teamDic = [
            "teamId":teamId,
            "teamName": teamName ?? "",
            "teamImage": teamImage ?? "",
            "teamFrontId":teamFrontId ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "Founder": Founder ?? "",
        ] as [String: Any]
                
        db.collection("users").document(uid).collection("belong_Team").document(teamId).setData(teamDic, merge: true)
        db.collection("Team").document(teamId).setData(["membersCount": FieldValue.increment(1.0)], merge: true)
        db.collection("Team").document(teamId).collection("MembersId").document(uid).setData(userInfo, merge: true)
        if skipBool == false {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let storyboard = UIStoryboard.init(name: "Thankyou", bundle: nil)
            let ThankyouVC = storyboard.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
            navigationController?.pushViewController(ThankyouVC, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        explainLabel.alpha = 0
        enterButton.clipsToBounds = true
        enterButton.layer.masksToBounds = false
        enterButton.layer.cornerRadius = 10
        enterButton.layer.shadowColor = UIColor.black.cgColor
        enterButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        enterButton.layer.shadowOpacity = 0.7
        enterButton.layer.shadowRadius = 5
        
        
    }
}
