//
//  ReserchVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/16.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds


class ReserchVC:UIViewController{
    private let cellId = "cellId"
    let db = Firestore.firestore()
    var selectBool:Bool = false
    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBAction func selectTappedButton(_ sender: Any) {
        if selectBool == false {
            selectBool = true
            selectButton.setTitle("ID", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーIDで検索", attributes: nil)
            print("いっっぢぢ")
        } else {
            selectBool = false
            selectButton.setTitle("Name", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーネームで検索", attributes: nil)
            print("あいう")
        }
    }
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var reserchTableView: UITableView!
    @IBOutlet weak var reserchButton: UIButton!
    @IBAction func reserchTappedButton(_ sender: Any) {
        print(inputTextField.text)
        getAccount()
    }
    @IBOutlet weak var bannerView: GADBannerView!
    
    func getAccount(){
        db.collection("users").whereField("この人のアドレス", isEqualTo: inputTextField.text ?? "")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        inputTextField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainLabel.text = "←タップで条件変更"

        
        print("aaaaaaa",selectBool)
        if selectBool == false {
            selectButton.setTitle("Name", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーネームで検索", attributes: nil)


        } else {
            selectButton.setTitle("ID", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーIDで検索", attributes: nil)

        }
        
        //        テスト ca-app-pub-3940256099942544/2934735716
        //        本番 ca-app-pub-9686355783426956/8797317880
        self.bannerView.adUnitID = "ca-app-pub-9686355783426956/8797317880"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        reserchTableView.dataSource = self
        reserchTableView.delegate = self
    }
}

extension ReserchVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reserchTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReserhTableViewCell
        return cell

    }
}

class ReserhTableViewCell:UITableViewCell{
    
}
