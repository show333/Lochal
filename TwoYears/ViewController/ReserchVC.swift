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
import Nuke


class ReserchVC:UIViewController{
    private let cellId = "cellId"
    let db = Firestore.firestore()
    var selectBool:Bool = false
    var users: [Users] = []

    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var noExistLabel: UILabel!
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
        
//        let smallStr = inputText.lowercased()// "abcdefg"
//        print(smallStr)
        let inputText = inputTextField.text ?? ""
        let removeWhitesSpacesString = inputText.removeWhitespacesAndNewlines

        if selectBool == false {
            getAccount(keyString:"userName",reserchString: removeWhitesSpacesString)
        } else {
            getAccount(keyString:"userFrontId",reserchString: removeWhitesSpacesString)
        }
    }
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    func getAccount(keyString:String,reserchString: String){
        
        db.collection("users").whereField(keyString, isEqualTo: reserchString)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(querySnapshot!.documents.count)
                    let userCount:Int = querySnapshot!.documents.count
                    if userCount == 0 {
                        noExsitAnimation()
                    } else {
                        noExistLabel.alpha = 0
                        users.removeAll()
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let usersDic = Users(dic: document.data())
                            self.users.append(usersDic)
                        }
                        reserchTableView.reloadData()
                    }
                }
            }
    }
    
    func noExsitAnimation(){
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            self.noExistLabel.alpha = 0
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.noExistLabel.alpha = 1
            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.5, delay: 2, animations: {
                    self.noExistLabel.alpha = 0
                })
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 任意の処理
        inputTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true

    }
    // キーボードと閉じる際の処理
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        
        explainLabel.text = "←タップで条件変更"
        noExistLabel.alpha = 0
        noExistLabel.text = "該当するユーザーが\nいませんでした"

        if selectBool == false {
            selectButton.setTitle("Name", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーネームで検索", attributes: nil)


        } else {
            selectButton.setTitle("ID", for: .normal)
            inputTextField.attributedPlaceholder = NSAttributedString(string: "ユーザーIDで検索", attributes: nil)

        }
        
        //        テスト ca-app-pub-3940256099942544/2934735716
        //        本番 ca-app-pub-9686355783426956/8797317880
        self.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        selectButton.clipsToBounds = true
        selectButton.layer.masksToBounds = false
        selectButton.layer.cornerRadius = 6
        selectButton.layer.shadowColor = UIColor.black.cgColor
        selectButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        selectButton.layer.shadowOpacity = 0.2
        selectButton.layer.shadowRadius = 5
        
        reserchTableView.dataSource = self
        reserchTableView.delegate = self
    }
}
extension StringProtocol where Self: RangeReplaceableCollection {
  var removeWhitespacesAndNewlines: Self {
    filter { !$0.isNewline && !$0.isWhitespace }
  }
}


extension ReserchVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reserchTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReserhTableViewCell
        cell.userImageView.image = nil
        cell.userNameLabel.text = users[indexPath.row].userName
        cell.userFrontIdLabel.text = users[indexPath.row].userFrontId
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 30
        
        if let url = URL(string:users[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = users[indexPath.row].userId
        ProfileVC.cellImageTap = true
        navigationController?.pushViewController(ProfileVC, animated: true)

    }
}

class ReserhTableViewCell:UITableViewCell{
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userFrontIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
