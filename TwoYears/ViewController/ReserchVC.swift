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
    var referralNum = 0
    var messageNum = 0
    
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
            getUserId(keyString:"userName",reserchString: removeWhitesSpacesString)
        } else {
            getUserId(keyString:"userFrontId",reserchString: removeWhitesSpacesString)
        }
    }
    
    
    @IBOutlet weak var refferalButton: UIButton!
    
    @IBAction func refferalTappedButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Refferal", bundle: nil)
        let RefferalVC = storyboard.instantiateViewController(withIdentifier: "RefferalVC") as! RefferalVC
        RefferalVC.referralCount = referralNum
        navigationController?.pushViewController(RefferalVC, animated: true)
        
    }
    
    @IBOutlet weak var refferalCountLabel: UILabel!
    
    func getUserId(keyString:String,reserchString: String){
        
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
                            let messageCount = document.data()["messageCount"] as? Int ?? 0
                            let chatLatestedAt = document.data()["chatLatestedAt"] as? Timestamp ?? Timestamp()
                            let newMessage = document.data()["newMessage"]  as? String ?? ""

                            let userInfoDic = UserInfo(dic: document.data(),messageCount:messageCount,chatLatestedAt:chatLatestedAt, newMessage: newMessage)
                            print("a",userInfoDic)
                            self.userInfo.append(userInfoDic)
                        }
                        reserchTableView.reloadData()
                    }
                }
            }
    }
    
    func getUserAccount(userId:String,userInfo:UserInfo) {
        guard  let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("Connections").whereField("userId", isEqualTo: userId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(querySnapshot!.documents.count)
                    let userCount:Int = querySnapshot!.documents.count
                    if userCount == 0 {
                        
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let messageCount = document.data()["messageCount"] as? Int ?? 0
                            let chatLatestedAt = document.data()["chatLatestedAt"] as? Timestamp ?? Timestamp()
                            let newMessage = document.data()["newMessage"]  as? String ?? ""

                            let userInfoDic = UserInfo(dic: document.data(),messageCount:messageCount,chatLatestedAt:chatLatestedAt, newMessage: newMessage)
                            print("a",userInfoDic)
                            self.userInfo.append(userInfoDic)
                        }
                        reserchTableView.reloadData()
                    }
                }
            }
    }
    
    func fetchUserList(userId:String){
        
        let textFieldString = inputTextField.text
        
        
        if textFieldString == "" {
            
            db.collection("users").document(userId).collection("Connections").addSnapshotListener { [self] ( snapshots, err) in
                if let err = err {
                    
                    print("メッセージの取得に失敗、\(err)")
                    return
                }
                
                if snapshots?.documents.count ?? 0 >= 1{
                    
                    snapshots?.documentChanges.forEach({ (documents) in
                        switch documents.type {
                        case .added:
                            
                            let userId = documents.document.data()["userId"] as? String ?? ""
                            let messageCount = documents.document.data()["messageCount"] as? Int ?? 0
                            let chatLatestedAt = documents.document.data()["chatLatestedAt"] as? Timestamp ?? Timestamp()
                            let newMessage = documents.document.data()["newMessage"]  as? String ?? ""
                            
                            print("aaaaa",messageCount)
                            getUserInfo(userId: userId,messageCount: messageCount,chatLatestedAt: chatLatestedAt,snapType: "added",newMessage:newMessage)
                            
                        case .modified, .removed:
                            print("noproblem")
                            
                            let userId = documents.document.data()["userId"] as? String ?? ""
                            
                            let messageCount = documents.document.data()["messageCount"] as? Int ?? 0
                            let chatLatestedAt = documents.document.data()["chatLatestedAt"] as? Timestamp ?? Timestamp()
                            let newMessage = documents.document.data()["newMessage"]  as? String ?? ""

                            print("aaaaa",messageCount)
                            getUserInfo(userId: userId,messageCount: messageCount,chatLatestedAt: chatLatestedAt,snapType: "modified",newMessage:newMessage)
                        }
                        
                    })
                }
            }
        }
    }
    
    
    func getUserInfo(userId:String,messageCount:Int,chatLatestedAt:Timestamp,snapType:String,newMessage:String){
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let userInfoDic = UserInfo(dic: document.data()!,messageCount:messageCount,chatLatestedAt:chatLatestedAt,newMessage:newMessage)
                
                self.userInfo.append(userInfoDic)
                
                if snapType == "modified" {
                let aaa = self.userInfo.firstIndex(of: userInfoDic)
                self.userInfo.remove(at: aaa ?? 0)
                }
                
                self.userInfo.sort { (m1, m2) -> Bool in
                    let m1LatestDate = m1.chatLatestedAt.dateValue()
                    let m2LatestDate = m2.chatLatestedAt.dateValue()

                    return m1LatestDate < m2LatestDate
                }
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
                    refferalButton.alpha = 0.85
                    refferalCountLabel.text = String(referralCount)
                    referralNum = referralCount
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
        
//
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchUserList(userId:uid)

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
//
//
//
//
        self.coachMarksController.dataSource = self
//
//
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
//
        reserchTableView.dataSource = self
        reserchTableView.delegate = self
//
        fetchNotification(userId:uid)

    }
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {

        //スワイプ方向による実行処理をcase文で指定
        print("aaa")
    }
    
    func fetchNotification(userId:String){
        
        db.collection("users").document(userId).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            let notificationNum = data["notificationNum"] as? Int ?? 0
            
            
            messageNum = data["messageNum"] as? Int ?? 0
            
            print(notificationNum)
            
            if notificationNum >= 1 {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = String(notificationNum)
            } else {
            }
            
            
            if messageNum >= 1 {
                self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = String(messageNum)
                
            } else {
            }
        }
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
        
        
        cell.userImageView.isUserInteractionEnabled = true
        cell.userImageView.tag = indexPath.row
        cell.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userImageTapped(_:))))

        
        let selectionView = UIView()
        selectionView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0.2487988115)
        cell.selectedBackgroundView = selectionView
        cell.userImageView.image = nil
        cell.userNameLabel.text = userInfo[indexPath.row].userName
        cell.userFrontIdLabel.text = userInfo[indexPath.row].userFrontId
        cell.userNameLabel.font = UIFont(name:"03SmartFontUI", size:19)
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 25
        cell.messageLabel.text = userInfo[indexPath.row].newMessage
    
        cell.messageCountLabel.text = String(userInfo[indexPath.row].messageCount)

        if userInfo[indexPath.row].messageCount == 0 {
            cell.messageCountLabel.alpha = 0
        } else {
            cell.messageCountLabel.alpha = 1
        }

        if let url = URL(string:userInfo[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let cell = self.reserchTableView.cellForRow(at:indexPath) as! ReserhTableViewCell
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let messageCount = userInfo[indexPath.row].messageCount
        let selectedUserId = userInfo[indexPath.row].userId
        
        userIdConnectionCheck(userId: selectedUserId, uid: uid, indexPath: indexPath, messageCount: messageCount)
    }
    
    func userIdConnectionCheck(userId:String,uid:String,indexPath:IndexPath,messageCount:Int) {
        db.collection("users").document(uid).collection("Connections").whereField("userId", isEqualTo: userId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(querySnapshot!.documents.count)
                    let userCount:Int = querySnapshot!.documents.count
                    if userCount == 0 {
                    } else {
                        countPush(uid: uid, messageCount: messageCount, userId: userId)
                        let storyboard = UIStoryboard.init(name: "InChatRoom", bundle: nil)
                        let InChatRoomVC = storyboard.instantiateViewController(withIdentifier: "InChatRoomVC") as! InChatRoomVC
                        InChatRoomVC.userId = userInfo[indexPath.row].userId
                        InChatRoomVC.userFrontId = userInfo[indexPath.row].userFrontId
                        InChatRoomVC.userImage = userInfo[indexPath.row].userImage
                        InChatRoomVC.userName = userInfo[indexPath.row].userName
                        InChatRoomVC.messageNum = messageNum
                        navigationController?.pushViewController(InChatRoomVC, animated: true)
                    }
                }
            }
    }
    
    @objc func userImageTapped(_ sender: UITapGestureRecognizer) {
        
        guard let numbers = sender.view?.tag else { return }
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC

        ProfileVC.userId = userInfo[numbers].userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(ProfileVC, animated: true)        
    }
    
    func countPush(uid:String,messageCount:Int,userId:String) {
        let calculationResults = messageNum-messageCount
        
        db.collection("users").document(uid).setData(["messageNum":calculationResults]as[String : Any], merge: true)
        db.collection("users").document(uid).collection("Connections").document(userId).setData(["messageCount":0]as[String : Any], merge: true)
        if calculationResults != 0 {
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = String(calculationResults)
        } else {
            self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil

        }
    }
}

class ReserhTableViewCell:UITableViewCell{
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userFrontIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ReserchVC: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [refferalButton]
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
            coachViews.bodyView.hintLabel.text = "ここから招待IDを\n発行することができます"
            coachViews.bodyView.nextLabel.text = "OK"
        
        
        default:
            break
        
        }
        
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}


