//
//  SettingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import UIKit

class SettingsVC : UIViewController{
    @IBOutlet weak var upDistance: NSLayoutConstraint!
    
    @IBOutlet weak var downDistance: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var imageButtonHeight: NSLayoutConstraint!
    @IBAction func imageTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserImageSet", bundle: nil)
        let UserImageSetVC = storyboard.instantiateViewController(withIdentifier: "UserImageSetVC") as! UserImageSetVC
        navigationController?.pushViewController(UserImageSetVC, animated: true)
    }
    @IBOutlet weak var idButton: UIButton!
    
    @IBOutlet weak var idButtonHeight: NSLayoutConstraint!
    @IBAction func idTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserIdSet", bundle: nil)
        let UserIdSetVC = storyboard.instantiateViewController(withIdentifier: "UserIdSetVC") as! UserIdSetVC
        navigationController?.pushViewController(UserIdSetVC, animated: true)
    }
    
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var nameButtonHeight: NSLayoutConstraint!
    @IBAction func nameTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserNameSet", bundle: nil)
        let UserNameSetVC = storyboard.instantiateViewController(withIdentifier: "UserNameSetVC") as! UserNameSetVC
        navigationController?.pushViewController(UserNameSetVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeBack()

        imageButton.clipsToBounds = true
        imageButton.layer.masksToBounds = false
        imageButton.layer.cornerRadius = 10
        imageButton.layer.shadowColor = UIColor.black.cgColor
        imageButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageButton.layer.shadowOpacity = 0.7
        imageButton.layer.shadowRadius = 5
        
        idButton.clipsToBounds = true
        idButton.layer.masksToBounds = false
        idButton.layer.cornerRadius = 10
        idButton.layer.shadowColor = UIColor.black.cgColor
        idButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        idButton.layer.shadowOpacity = 0.7
        idButton.layer.shadowRadius = 5
        
        nameButton.clipsToBounds = true
        nameButton.layer.masksToBounds = false
        nameButton.layer.cornerRadius = 10
        nameButton.layer.shadowColor = UIColor.black.cgColor
        nameButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        nameButton.layer.shadowOpacity = 0.7
        nameButton.layer.shadowRadius = 5
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        let safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        
        upDistance.constant = safeArea/10
        downDistance.constant = safeArea/10
        
        imageButtonHeight.constant = safeArea/6
        idButtonHeight.constant = safeArea/6
        nameButtonHeight.constant = safeArea/6
        
    }
}
