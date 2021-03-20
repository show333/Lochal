//
//  SplashViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/13.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBAction func taranButton(_ sender: Any) {
        //        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        //        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        //        signInViewController.modalPresentationStyle = .fullScreen
        //        self.present(signInViewController, animated: true, completion: nil)
        
//
//                これを基準に画面遷移
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)//遷移先のStoryboardを設定
//
//                let tabbarController = storyboard.instantiateViewController(withIdentifier: "flower") as! UITabBarController//遷移先のTabbarController指定とIDをここに入力
//                tabbarController.modalPresentationStyle = .fullScreen
//                self.present(tabbarController, animated: true, completion: nil)//遷移する
        let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)//遷移先のStoryboardを設定

        let SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") //遷移先のTabbarController指定とIDをここに入力
        SignInViewController.modalPresentationStyle = .fullScreen
        self.present(SignInViewController, animated: true, completion: nil)//遷移する
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
