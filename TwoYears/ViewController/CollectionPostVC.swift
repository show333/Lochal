//
//  CollectionPostVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/04.
//

import UIKit

class CollectionPostVC:UIViewController{
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func imageTappedButton(_ sender: Any) {
        
    }
    @IBOutlet weak var bottomTextView: UITextView!
    
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            backView.alpha = 0.8
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        backView.alpha = 0
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
}
