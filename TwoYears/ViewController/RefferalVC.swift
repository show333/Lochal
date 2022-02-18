//
//  RefferalVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class RefferalVC : UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var createRefferalButton: UIButton!
    
    @IBAction func createRefferalTappedButton(_ sender: Any) {
        let randomId = randomString(length: 8)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let refferalDoc = [
            
            "createdAt": FieldValue.serverTimestamp(),
            "userId": uid,
            "usedBool": false,
            "refferalId":randomId,
            
        ] as [String : Any]
        
        db.collection("RefferalId").document(randomId).setData(refferalDoc)
        
    }
    
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
