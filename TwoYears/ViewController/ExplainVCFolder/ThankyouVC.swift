//
//  ThankyouVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit

class ThankyouVC:UIViewController {
    
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
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
