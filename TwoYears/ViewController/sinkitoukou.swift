//
//  sinkitoukou.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class sinkitoukou: UIViewController {
    @IBOutlet weak var sinkiButton: UIButton!
    @IBOutlet weak var sinkiTextView: UITextView!
    @IBAction func tappedSinkiButton(_ sender: Any) {
        lulu()
    }
    
    private func lulu() {
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        
        let DB = Firestore.firestore().collection("Rooms").document("karano")
        let docRef = Firestore.firestore().collection("users").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("Document data: \(dataDescription)")
                
                if let teamnameid = document.data()?["teamname"]{
                print(teamnameid)
                    
                    let iwayuruId = randomString(length: 20)
                    let thisisMessage = self.sinkiTextView.text
                    let rufi = [
                        "message" : thisisMessage as Any,
                        "documentId": iwayuruId,
                        "createdAt": Timestamp(),
                        "teamname":  teamnameid,
                        
                    ] as [String: Any]
                    
                    DB.collection("kokoniireru").document(iwayuruId).setData(rufi)
                    DB.collection("kokoniireru").document(iwayuruId).collection("members").document("membersId").setData([uid:uid])
                    DB.collection("kokoniireru").document(iwayuruId).collection("messages").document().setData(["message" : thisisMessage as Any, uid:uid, "createdAt":Timestamp(),])
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
