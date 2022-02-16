//
//  SelectMakeTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit

class SelectMakeTeamVC : UIViewController {
    
    @IBOutlet weak var upButton: UIButton!
    @IBAction func upTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "NewCreateTeam", bundle: nil)
        let CompanyViewController = storyboard.instantiateViewController(withIdentifier: "NewCreateTeamVC") as! NewCreateTeamVC
        navigationController?.pushViewController(CompanyViewController, animated: true)
    }
    
    
    @IBOutlet weak var downButton: UIButton!
    @IBAction func downTappedButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "EnterTeam", bundle: nil)
        let EnterTeamVC = storyboard.instantiateViewController(withIdentifier: "EnterTeamVC") as! EnterTeamVC
        navigationController?.pushViewController(EnterTeamVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
