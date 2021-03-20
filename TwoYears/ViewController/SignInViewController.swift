//
//  SignIn.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/07.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var SigninTextField: UITextField!
    
    @IBOutlet weak var InButton: UIButton!
        
    @IBAction func tappedButton(_ sender: Any) {
        
        guard  let email = SigninTextField.text else { return }
        
        
        Auth.auth().signIn(withEmail: email + "@2.years", password: "ONELIFE") { (res, err) in
            if let err = err {
                print("ログイン失敗、、、:", err)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("ログイン成功！")
            Firestore.firestore().collection("users").document(uid).setData(["teamname": "red"], merge: true)
            print("いってくれーーーーー")
            
//            self.dismiss(animated: true, completion: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TabbarController = storyboard.instantiateViewController(withIdentifier: "flower") as! UITabBarController
            TabbarController.modalPresentationStyle = .fullScreen
            self.present(TabbarController, animated: true, completion: nil)

//            self.navigationController?.pushViewController(ViewController, animated: true)
            
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            //遷移先のStoryboardを設定
//            let navigationController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! UINavigationController
//            //遷移先のNavigationControllerを設定 //こっちだとnavigationBar出る
//            self.present(navigationController, animated: true, completion: nil)
//            //遷移する
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
