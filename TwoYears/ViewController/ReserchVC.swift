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
import Instructions


class ReserchVC:UIViewController{
    
    var selectBool:Bool = false
    var userInfo: [UserInfo] = []
    private let cellId = "cellId"
    let db = Firestore.firestore()
    let coachMarksController = CoachMarksController()

    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var noExistLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var backImageView: UIImageView!
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
    
    
    @IBOutlet weak var refferalButton: UIButton!
    
    @IBAction func refferalTappedButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Refferal", bundle: nil)
        let RefferalVC = storyboard.instantiateViewController(withIdentifier: "RefferalVC") as! RefferalVC
        navigationController?.pushViewController(RefferalVC, animated: true)
        
    }
    
    @IBOutlet weak var refferalCountLabel: UILabel!
    
    
    
    
    
    
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
                        userInfo.removeAll()
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let userInfoDic = UserInfo(dic: document.data())
                            self.userInfo.append(userInfoDic)
                        }
                        reserchTableView.reloadData()
                    }
                }
            }
    }
    
    func getUserList(userId:String){
        
        self.db.collection("users").document(userId).collection("Connections").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        getUserInfo(userId: userId)
                    }
                }
            }
        }
    }
    
    
    func getUserInfo(userId:String){
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let userInfoDic = UserInfo(dic: document.data()!)
                self.userInfo.append(userInfoDic)
                self.reserchTableView.reloadData()
            } else {
                print("Document does not exist")
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        refferalCount(uid:uid)
        
        let backGroundString = UserDefaults.standard.string(forKey: "userBackGround") ?? "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/backGroound%2FstoryBackGroundView.png?alt=media&token=0daf6ab0-0a44-4a65-b3aa-68058a70085d"
        
        if let url = URL(string:backGroundString) {
            Nuke.loadImage(with: url, into: backImageView)
        } else {
            backImageView.image = nil
        }
        
        
    }
    
    func refferalCount(uid:String){
        
        
        db.collection("users").document(uid).getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let referralCount = document["referralCount"] as? Int ?? 0
                
                if referralCount != 0 {
                    refferalCountLabel.alpha = 1
                    refferalButton.alpha = 1
                    refferalCountLabel.text = String(referralCount)
                } else {
                    refferalCountLabel.alpha = 0
                    refferalButton.alpha = 0
                }
                
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // キーボードと閉じる際の処理
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = false
//        print("aa")
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "SerchInstruct") != true{
            UserDefaults.standard.set(true, forKey: "SerchInstruct")
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        getUserList(userId:uid)
        
        let downSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipe(_:))
        )
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        
            let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        

        
        self.coachMarksController.dataSource = self
        
        
        refferalButton.layer.cornerRadius = 30
        refferalButton.clipsToBounds = true
        refferalButton.layer.masksToBounds = false
        refferalButton.layer.shadowColor = UIColor.black.cgColor
        refferalButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        refferalButton.layer.shadowOpacity = 1
        refferalButton.layer.shadowRadius = 5
        
        refferalCountLabel.clipsToBounds = true
        refferalCountLabel.layer.cornerRadius = 12.5

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
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {

        //スワイプ方向による実行処理をcase文で指定
        print("aaa")
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
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reserchTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReserhTableViewCell
        cell.userImageView.image = nil
        cell.userNameLabel.text = userInfo[indexPath.row].userName
        cell.userFrontIdLabel.text = userInfo[indexPath.row].userFrontId
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 30
        
        if let url = URL(string:userInfo[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = userInfo[indexPath.row].userId
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

extension ReserchVC: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [reserchButton,refferalButton]
        //(hogeLabelが最初、次にfugaButton,最後にpiyoSwitchという流れにしたい)
        
        //チュートリアルで使うビューの中からindexで何ステップ目かを指定
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {

        //吹き出しのビューを作成します
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,    //三角の矢印をつけるか
            arrowOrientation: coachMark.arrowOrientation    //矢印の向き(吹き出しの位置)
        )

        //index(ステップ)によって表示内容を分岐させます
        switch index {
        case 0:    //hogeLabel
            coachViews.bodyView.hintLabel.text = "ここで新しいユーザーを\n探します"
            coachViews.bodyView.nextLabel.text = "次へ"
        case 1:    //hogeLabel
            coachViews.bodyView.hintLabel.text = "ここから招待IDを\n発行することができます"
            coachViews.bodyView.nextLabel.text = "OK"
        
        
        default:
            break
        
        }
        
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
