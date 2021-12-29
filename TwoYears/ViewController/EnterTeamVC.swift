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
    let db = Firestore.firestore()
    
    @IBOutlet weak var teamIdField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func tappedEnterButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let teamId = teamIdField.text ?? ""
        getsTeamInfo(teamId:teamId,uid:uid)
    }
    
    func getsTeamInfo(teamId:String,uid:String){
        db.collection("Team").whereField("teamId", isEqualTo: teamId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let teamBoolCount : Int = querySnapshot?.documents.count ?? 0
                    if teamBoolCount == 0 {
                        print("nothing")
                    } else if teamBoolCount == 1{
                        self.checkTeamUser(teamId: teamId,uid: uid)
                        } else {
                        print("IDが重複している可能性がありますラベルで")
                    }
                }
            }
    }
    
    func checkTeamUser(teamId:String,uid:String) {
        db.collection("Team").document(teamId).collection("MembersId").document("membersId").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let userIdArray : Array = document["userId"] as! Array<String>
                if userIdArray.contains(uid) != true {
                self.enterTeam(teamId: teamId,uid: uid)
                } else {
                    print("既に入っていますラベル")
                }

            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func enterTeam(teamId:String,uid:String) {
        
        db.collection("users").document(uid).collection("belong_Team").document("teamId").setData(["teamId":FieldValue.arrayUnion([teamId]) ], merge: true)
        db.collection("Team").document(teamId).setData(["membersCount": FieldValue.increment(1.0)], merge: true)
        db.collection("Team").document(teamId).collection("MembersId").document("membersId").setData(["userId": FieldValue.arrayUnion([uid])], merge: true)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
