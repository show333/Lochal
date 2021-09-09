//
//  exampleviewcontroller.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/06/05.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class exampleviewcontroller: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("users").whereField("招待した人のID", isEqualTo: uid!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("あい上岡きけこ",querySnapshot!.documents)
                    }
                }
            }
    }
}
