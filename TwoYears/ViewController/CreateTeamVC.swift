//
//  CreateTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/22.
//

import UIKit

class CreateTeamVC : UIViewController {
    
    var skipBool = false
    
    @IBOutlet weak var upButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonDistance: NSLayoutConstraint!
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
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
        } else {
            skipButton.alpha = 0
        }
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let safeArea = UIScreen.main.bounds.size.height - statusbarHeight - navigationbarHeight
        
        upButtonConstraint.constant = safeArea/4
        buttonDistance.constant = safeArea/8
        downConstraint.constant = safeArea/4
        
        
        
        setSwipeBack()
        
        upButton.clipsToBounds = true
        upButton.layer.masksToBounds = false
        upButton.layer.cornerRadius = 10
        upButton.layer.shadowColor = UIColor.black.cgColor
        upButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        upButton.layer.shadowOpacity = 0.7
        upButton.layer.shadowRadius = 5
        
        downButton.clipsToBounds = true
        downButton.layer.masksToBounds = false
        downButton.layer.cornerRadius = 10
        downButton.layer.shadowColor = UIColor.black.cgColor
        downButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        downButton.layer.shadowOpacity = 0.7
        downButton.layer.shadowRadius = 5

        
    }
    
}
