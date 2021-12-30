//
//  EULAViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/04.
//

import UIKit

class EULAViewController: UIViewController {
    @IBOutlet weak var eulaTextView: UITextView!
    
    @IBOutlet weak var euButton: UIButton!
    
    @IBAction func euTappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(1, forKey: "EULA")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
