//
//  ThankyouVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit
import Nuke

class ThankyouVC:UIViewController {
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        TabbarController.modalPresentationStyle = .fullScreen
        self.present(TabbarController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad(){
        super.viewDidLoad()
    https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages3.003.png?alt=media&token=736702b1-f14f-4347-9b49-733a8a9ef24b
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages4.013.png?alt=media&token=4e8ed41c-58f3-4568-a048-a27ff97194e9") {
            Nuke.loadImage(with: url, into:  backGroundImageView)
        } else {
            backGroundImageView.image = nil
        }
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
