//
//  WhichOne.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/16.
//

import UIKit
import FirebaseAuth
import Firebase

class WhichOneViewController: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBAction func redButton(_ sender: Any) {
        Firestore.firestore().collection("users").document(uid!).setData(["teamname": "red"], merge: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func yellowButton(_ sender: Any) {
        Firestore.firestore().collection("users").document(uid!).setData(["teamname": "yellow"], merge: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purpleButton(_ sender: Any) {
        Firestore.firestore().collection("users").document(uid!).setData(["teamname": "purple"], merge: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func blueButton(_ sender: Any) {
        Firestore.firestore().collection("users").document(uid!).setData(["teamname": "blue"], merge: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
