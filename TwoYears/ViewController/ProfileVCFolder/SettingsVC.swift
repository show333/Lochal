//
//  SettingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import UIKit
import Nuke

class SettingsVC : UIViewController{
    
    
    @IBOutlet weak var imageImageView: UIImageView!
    
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    
    @IBOutlet weak var upDistance: NSLayoutConstraint!
    
    @IBOutlet weak var downDistance: NSLayoutConstraint!
    
    @IBOutlet weak var upView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var downView: UIView!
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
        
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_Asset_selection_re_k5fj.png?alt=media&token=6606717a-2514-42cc-be08-efcba24c067d") {
            Nuke.loadImage(with: url, into: imageImageView)
        } else {
            imageImageView?.image = nil
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_Email_capture_re_b5ys.png?alt=media&token=1a25bd46-8546-4c6c-80ab-252a60a038a5") {
            Nuke.loadImage(with: url, into: idImageView)
        } else {
            idImageView?.image = nil
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_Knowledge_re_leit.png?alt=media&token=5f3db7c5-3d2c-4f9e-91f6-00ed06ccdb9b") {
            Nuke.loadImage(with: url, into: nameImageView)
        } else {
            nameImageView?.image = nil
        }
        
        setSwipeBack()
        
        upView.backgroundColor = .white
        upView.clipsToBounds = true
        upView.layer.masksToBounds = false
        upView.layer.cornerRadius = 10
        upView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        upView.layer.shadowOffset = CGSize(width: 0, height: 3)
        upView.layer.shadowOpacity = 0.7
        upView.layer.shadowRadius = 5
        
        middleView.backgroundColor = .white
        middleView.clipsToBounds = true
        middleView.layer.masksToBounds = false
        middleView.layer.cornerRadius = 10
        middleView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        middleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        middleView.layer.shadowOpacity = 0.7
        middleView.layer.shadowRadius = 5
        
        downView.backgroundColor = .white
        downView.clipsToBounds = true
        downView.layer.masksToBounds = false
        downView.layer.cornerRadius = 10
        downView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        downView.layer.shadowOffset = CGSize(width: 0, height: 3)
        downView.layer.shadowOpacity = 0.7
        downView.layer.shadowRadius = 5
        
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
