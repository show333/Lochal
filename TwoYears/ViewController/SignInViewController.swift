//
//  SignIn.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/07.
//

import UIKit
import Firebase
import FirebaseAuth
import BATabBarController
import TransitionButton
import FirebaseFirestore



class SignInViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainLabel.alpha = 0
        view.backgroundColor = #colorLiteral(red: 0.9402339228, green: 0.9045240944, blue: 0.8474154538, alpha: 1)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let button = TransitionButton(frame:CGRect(x:width/4,y:height/2.5,width:width/2,height:50)); // please use Autolayout in real project

        self.view.addSubview(button)

        button.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        button.setTitle("Enter", for: .normal)
        button.cornerRadius = 20
        button.spinnerColor = .white
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        
    }
    
    // サインインボタン
    @IBAction func buttonAction(_ button: TransitionButton) {
        
        // 最初のボタンアクション
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        guard let email = idTextField.text else { return }
        
        //ログイン失敗(IDが違う場合)
        backgroundQueue.async(execute: {
            
            Auth.auth().signIn(withEmail: email + "@2.years", password: "ONELIFE") { (res, err) in
                if let err = err {
                    print("ログイン失敗、、、:", err)
                    sleep(1) // 3: Do your networking task or background work here.
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .shake, completion: {
                            print("shake")
                            self.explainLabel.text = "このIDは招待されたIDと異なります。"
                            
                            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                self.explainLabel.alpha = 1
                                
                            }) {(completed) in
                                
                                UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                    self.explainLabel.alpha = 0
                                })
                            }
                        })
                    })
                    return
                }
                let uid = Auth.auth().currentUser?.uid
                print("ログイン成功！")
                
                //ログイン失敗(もう使われているアカウント)
                Firestore.firestore().collection("users").document(uid!).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        let teamname = document["teamname"] as! String
                
                if  teamname == "red" || teamname == "blue" || teamname == "yellow" || teamname == "purple" {
                    
                    sleep(1) // 3: Do your networking task or background work here.
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .shake, completion: {
                            print("shake")
                            
                            //ログアウトを行う
                            self.explainLabel.text = "このIDは既に使われています。"
                            try? Auth.auth().signOut()
                            
                            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                self.explainLabel.alpha = 1
                                
                            }) {(completed) in
                                
                                UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                                    self.explainLabel.alpha = 0
                                })
                            }
                        })
                    })
                    
                } else {
                    //　whichoneviewcontrollerに飛ぶ
                    let storyboard: UIStoryboard = UIStoryboard(name: "WhichOne", bundle: nil)//遷移先のStoryboardを設定
                    let WhichOneViewController = storyboard.instantiateViewController(withIdentifier: "WhichOneViewController") //遷移先のTabbarController指定とIDをここに入力
                    WhichOneViewController.modalPresentationStyle = .fullScreen
                    
                    sleep(2) // 3: Do your networking task or background work here.
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        button.stopAnimation(animationStyle: .expand, completion: {
                            self.present(WhichOneViewController, animated: true, completion: nil)
                            
                        })
                    })
                }
                    }
                }
            }
        })
    }
        //他の部分をタップしたらキーボードを閉じる
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
