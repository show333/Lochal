//
//  AgeSelectVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/05/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class AgeSelectVC:UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmTappedButton(_ sender: Any) {
        let ageText = textField.text ?? ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if ageText == "" {
            warningLabel.text = "生年月日を入力してください"

            labelAnimation()
        } else {
            print("教えjf",ageText)
            let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
            let selectAreaVC = storyboard.instantiateViewController(withIdentifier: "selectAreaVC") as! selectAreaVC
            selectAreaVC.firstBool = true
            navigationController?.pushViewController(selectAreaVC, animated: true)
            
            sendAgeInfo(userId:uid,userAge:ageText)
        }

                
    }
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.alpha = 0
        explainLabel.text = "年齢が遠い人とのトラブルを減らすため\n生年月日を入力してください！"
        
        explainLabel.font = UIFont(name:"03SmartFontUI", size:16)
        
        
        confirmButton.clipsToBounds = true
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmButton.layer.shadowOpacity = 0.7
        confirmButton.layer.shadowRadius = 5

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月d日"
        datePicker.date = formatter.date(from: "2000年 1月1日")!
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    func sendAgeInfo(userId:String,userAge:String) {
        UserDefaults.standard.set(userAge, forKey: "userAge")
        db.collection("users").document(userId).collection("Profile").document("profile").setData(["userAge":userAge]as[String : Any],merge: true)
        db.collection("users").document(userId).setData(["userAge":userAge] as [String : Any],merge: true)
        
    }
    
    func labelAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.warningLabel.alpha = 1
//
//
        }) { bool in
        // ②アイコンを大きくする
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.warningLabel.alpha = 1

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.2, delay: 2, animations: {
                self.warningLabel.alpha = 0

            })
            }
        }
    }
    
    @objc func done() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月d日"
        textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
