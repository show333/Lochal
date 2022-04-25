//
//  NotificationExVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/04/25.
//

import UIKit
import Nuke

class NotificationExVC: UIViewController {
    @IBOutlet weak var explainImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2Fnotification.001.png?alt=media&token=d9e4eba9-e811-40e0-902e-ea7cce136874") {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
    }
}
