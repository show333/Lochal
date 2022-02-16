//
//  CreateTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/22.
//

import UIKit
import Nuke


class CreateTeamVC : UIViewController {
    
    var skipBool = false
    
    @IBOutlet var canChangeLabel: UIView!
    @IBOutlet weak var upConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonDistance: NSLayoutConstraint!
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var upImageView: UIImageView!
    
    @IBOutlet weak var downImageView: UIImageView!
    @IBOutlet weak var upButton: UIButton!
    @IBAction func upTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "NewCreateTeam", bundle: nil)
        let NewCreateTeamVC = storyboard.instantiateViewController(withIdentifier: "NewCreateTeamVC") as! NewCreateTeamVC
        NewCreateTeamVC.skipBool = self.skipBool
        navigationController?.pushViewController(NewCreateTeamVC, animated: true)
    }
    
    
    @IBOutlet weak var downButton: UIButton!
    @IBAction func downTappedButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "EnterTeam", bundle: nil)
        let EnterTeamVC = storyboard.instantiateViewController(withIdentifier: "EnterTeamVC") as! EnterTeamVC
        EnterTeamVC.skipBool = self.skipBool
        navigationController?.pushViewController(EnterTeamVC, animated: true)
    }
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBAction func skipTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Thankyou", bundle: nil)
        let ThankyouVC = storyboard.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
        navigationController?.pushViewController(ThankyouVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if skipBool == true {
            skipButton.alpha = 1
            countLabel.alpha = 1
            canChangeLabel.alpha = 1
        } else {
            skipButton.alpha = 0
            countLabel.alpha = 0
            canChangeLabel.alpha = 0
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_circles_y7s2.png?alt=media&token=f2f89b22-99a8-4d33-a127-86290cf4b53a") {
            Nuke.loadImage(with: url, into: upImageView)
        } else {
            upImageView?.image = nil
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Fundraw_join_of2w.png?alt=media&token=90126689-76f6-4177-b67a-743fed12917f") {
            Nuke.loadImage(with: url, into: downImageView)
        } else {
            downImageView?.image = nil
        }
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let safeArea = UIScreen.main.bounds.size.height - statusbarHeight - navigationbarHeight
        
        upConstraint.constant = safeArea/4
        buttonDistance.constant = safeArea/8
        downConstraint.constant = safeArea/4
        
        upView.backgroundColor = .white
        downView.backgroundColor = .white
        setSwipeBack()
        
        
        upView.clipsToBounds = true
        upView.layer.masksToBounds = false
        upView.layer.cornerRadius = 10
        upView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        upView.layer.shadowOffset = CGSize(width: 0, height: 3)
        upView.layer.shadowOpacity = 0.7
        upView.layer.shadowRadius = 5
        
        downView.clipsToBounds = true
        downView.layer.masksToBounds = false
        downView.layer.cornerRadius = 10
        downView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        downView.layer.shadowOffset = CGSize(width: 0, height: 3)
        downView.layer.shadowOpacity = 0.7
        downView.layer.shadowRadius = 5

        
    }
    
}
