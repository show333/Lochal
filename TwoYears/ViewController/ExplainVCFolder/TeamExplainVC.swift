//
//  TeamExplainVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit
import Nuke



class TeamExplainVC:UIViewController {
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
        @IBOutlet weak var nextButton: UIButton!

    @IBAction func nextTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CreateTeam", bundle: nil)
        let CreateTeamVC = storyboard.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
        CreateTeamVC.skipBool = true
        navigationController?.pushViewController(CreateTeamVC, animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        nextButton.backgroundColor = .clear
        
        
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FmakeAUnitTeam.001.png?alt=media&token=3195f984-ccb6-4993-8f1b-220a96c988dc") {
            Nuke.loadImage(with: url, into: backImageView)
        } else {
            backImageView.image = nil
        }
        
    }
}
