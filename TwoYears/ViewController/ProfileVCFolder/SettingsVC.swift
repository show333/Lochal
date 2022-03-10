//
//  SettingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import UIKit
import Nuke

class SettingsVC : UIViewController{
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageImageView: UIImageView!
    
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    
    @IBOutlet weak var upDistance: NSLayoutConstraint!
    
    @IBOutlet weak var downDistance: NSLayoutConstraint!
    
    @IBOutlet weak var ImageBackView: UIView!
    
    @IBOutlet weak var IdBackView: UIView!
    @IBOutlet weak var NameBackView: UIView!
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
    
    @IBOutlet weak var backGroundBackView: UIView!
    
    @IBOutlet weak var backGroundBackImageView: UIImageView!
    @IBOutlet weak var backGroundDistance: NSLayoutConstraint!
    
    @IBOutlet weak var backGroundHeight: NSLayoutConstraint!
    @IBOutlet weak var backGroundButton: UIButton!
    
    @IBAction func backGroundTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "backGroundSettings", bundle: nil)
        let backGroundSettingsVC = storyboard.instantiateViewController(withIdentifier: "backGroundSettingsVC") as! backGroundSettingsVC
        navigationController?.pushViewController(backGroundSettingsVC, animated: true)
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
        
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FbackGroundIcon.001.png?alt=media&token=080d7c22-2653-4a81-a810-e3e6490b72ad") {
            Nuke.loadImage(with: url, into: backGroundBackImageView)
        } else {
            backGroundBackImageView?.image = nil
        }
        
        setSwipeBack()
        
        ImageBackView.backgroundColor = .white
        ImageBackView.clipsToBounds = true
        ImageBackView.layer.masksToBounds = false
        ImageBackView.layer.cornerRadius = 10
        ImageBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        ImageBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        ImageBackView.layer.shadowOpacity = 0.7
        ImageBackView.layer.shadowRadius = 5
        
        IdBackView.backgroundColor = .white
        IdBackView.clipsToBounds = true
        IdBackView.layer.masksToBounds = false
        IdBackView.layer.cornerRadius = 10
        IdBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        IdBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        IdBackView.layer.shadowOpacity = 0.7
        IdBackView.layer.shadowRadius = 5
        
        NameBackView.backgroundColor = .white
        NameBackView.clipsToBounds = true
        NameBackView.layer.masksToBounds = false
        NameBackView.layer.cornerRadius = 10
        NameBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        NameBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        NameBackView.layer.shadowOpacity = 0.7
        NameBackView.layer.shadowRadius = 5
        
        backGroundBackView.backgroundColor = .white
        backGroundBackView.clipsToBounds = true
        backGroundBackView.layer.masksToBounds = false
        backGroundBackView.layer.cornerRadius = 10
        backGroundBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        backGroundBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backGroundBackView.layer.shadowOpacity = 0.7
        backGroundBackView.layer.shadowRadius = 5
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        let safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        
        centerConstraint.constant = -safeArea/12
        
        upDistance.constant = safeArea/12
        downDistance.constant = safeArea/12
        backGroundDistance.constant = safeArea/12
        
        imageButtonHeight.constant = safeArea/8
        idButtonHeight.constant = safeArea/8
        nameButtonHeight.constant = safeArea/8
        backGroundHeight.constant = safeArea/8
        
    }
}
