//
//  CreateTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/22.
//

import UIKit

class CreateTeamVC : UIViewController {
    
    @IBOutlet weak var upButton: UIButton!
    @IBAction func upTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Company", bundle: nil)
        let CompanyViewController = storyboard.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
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
        
        
    }
    
}
