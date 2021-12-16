//
//  ChatRoomViewController.swift
//  protain
//
////  Created by 平田翔大 on 2021/02/03.
////
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SOTabBar
import SwiftMoment
import Nuke
import TTTAttributedLabel

class ChatRoomViewController: UIViewController {
    var dragons: Animal?
    var userteamnames: Team?
    var rurubus = [Message]()
    private let cellId = "cellId"
    private let accessoryHeight: CGFloat = 90
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    }
    var documentTeamColor : String?
    var userTeamColor : String?
    let userMyBrands = UserDefaults.standard.string(forKey: "userBrands")
    let uid = Auth.auth().currentUser?.uid
    let DB = Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru")
    @IBOutlet weak var navbarTitle: UINavigationItem!
    //チャットインプットアクセサリーのやつ
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 70)
        view.delegate = self
        return view
    }()
    let differentView = UIView(frame:CGRect(x:100,y:100,width:0,height:0));
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var differentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotification()
        setupChatRoomTableView()
        setSwipeBack()
//        fetchMessages()
        goodmanmember()
        messagemember()
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        guard let userInfo = notification.userInfo else { return }
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            if keyboardFrame.height <= accessoryHeight { return }
            print("keyふらめ", keyboardFrame)
            let top = keyboardFrame.height - safeAreaBottom - 48
            let bottom = chatRoomTableView.contentOffset.y
            let moveY =  chatRoomTableView.contentOffset.y
            print(bottom)
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: top, right: 0)
            chatRoomTableView.contentInset = contentInset
            chatRoomTableView.scrollIndicatorInsets = contentInset
            chatRoomTableView.contentOffset = CGPoint(x: 0, y: moveY + top)
        }
    }
    @objc func keyboardWillHide() {
        print("keyboardWillHide")
        chatRoomTableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        chatRoomTableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    private func setupChatRoomTableView() {
        self.navigationItem.title = ("コメント数" + String(dragons!.messageCount))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "戻る",
            style: .plain,
            target: nil,
            action: nil
        )
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.keyboardDismissMode = .interactive
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = #colorLiteral(red: 0.9387103873, green: 0.8334191148, blue: 0.6862602769, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.9387103873, green: 0.8334191148, blue: 0.6862602769, alpha: 1)
    }
    override var inputAccessoryView: UIView? {
        get {
                return chatInputAccessoryView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    private func goodmanmember() {
        let chatRoomDocId = dragons!.documentId
        
        DB.document(chatRoomDocId).collection("good").document("goodman")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data(goodman) was empty.")
                    return
                }
                print("Current data: \(data)")
                self.DB.document(chatRoomDocId).updateData(["goodcount":data.count as Int])
            }
    }
    private func messagemember() {
        let chatRoomDocId = dragons!.documentId
        
        DB.document(chatRoomDocId).collection("members").addSnapshotListener{ [self] (querySnapshot, err) in
            if let err = err {
                print("失敗やで、、、\(err)")
                return
            }
            print("メンバーズカウント！！！！！！！！！",querySnapshot!.documents.count)
            self.DB.document(chatRoomDocId).updateData(["memberscount":querySnapshot!.documents.count as Int])
        }
        DB.document(chatRoomDocId).collection("members").document("membersId")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data(members) was empty.")
                    return
                }
                print("Current data: \(data)")
                self.DB.document(chatRoomDocId).updateData(["memberscount":data.count as Int])
            }
    }
    private func fetchMessages() {
        let chatRoomDocId = dragons!.documentId

        DB.document(chatRoomDocId).collection("messages").addSnapshotListener{ [self] (snapshots, err) in

            if let err = err {
                print("失敗やで、、、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({( documentChange) in
                switch documentChange.type {
                case .added:
                    let iineman = documentChange.document.data()[self.uid!] as? String ?? ""
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic, iineman: iineman)
                    if UserDefaults.standard.object(forKey: "blocked") == nil {
                        let XXX = ["XX" : true]
                        UserDefaults.standard.set(XXX, forKey: "blocked")
                    }
                    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
                    if blockList[message.uid] == true {
                    } else {
                        if message.admin == true {
                        }
                        self.rurubus.append(message)
                        self.navigationItem.title = ("コメント数" + String(rurubus.count))
                    }
                    self.rurubus.sort{(m1, m2) -> Bool in
                        let m1Date = m1.createdTime.dateValue()
                        let m2Date = m2.createdTime.dateValue()
                        return m1Date < m2Date

                    }
                    self.chatRoomTableView.reloadData()
                case .modified, .removed:
                    print("ランダムUSERID","")
                }
            })
        }
    }
}
extension ChatRoomViewController: ChatInputAccessoryViewDelegate{
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)
    }
    private func addMessageToFirestore(text: String) {
        chatInputAccessoryView.removeText()
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let randomUserId = randomString(length: 8)
        let chatRoomDocId = dragons!.documentId
        guard let uid = Auth.auth().currentUser?.uid else { return }
        func comment(randomuserId: String,commentId: String) {
            let docData = [
                "createdAt": FieldValue.serverTimestamp(),
                "message": text,
                "userId": uid,
                "documentId": chatRoomDocId,
                "comentId" : commentId,
                "admin": false,
                "randomUserId": randomuserId,
                "userBrands": userMyBrands!,
                "sendImageURL": "",
            ] as [String: Any]
            
            DB.document(chatRoomDocId).collection("messages").document(commentId).setData(docData) { (err) in
                if let err = err {
                    print("メッセージ情報の保存に失敗しました。ss\(err)")
                    return
                }
                print("成功！")
            }
        }

        
        self.DB.document(chatRoomDocId).collection("messages").whereField("userId", isEqualTo: uid).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("クエリースナップショットカウント！",querySnapshot!.documents.count)
                if querySnapshot!.documents.count == 0 {
                    let commentId = uid+"comentId"
                    comment(randomuserId: "",commentId: commentId)
                    DB.document(chatRoomDocId).collection("members").document(uid).setData(["randomUserId": randomUserId], merge: true)
                    DB.document(chatRoomDocId).setData([uid: true], merge: true)
                    Firestore.firestore().collection("users").document(uid).setData(["The_earliest":true], merge: true)
                } else if querySnapshot!.documents.count == 1 {
                    print("ln")
                    DB.document(chatRoomDocId).collection("members").document(uid).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let randomUserId = document["randomUserId"] as? String ?? "unknown"
                            
                            print(randomUserId,"aaaaaaaaa")
                            print("aaaa")
                            let comentId = randomString(length: 15)
                            comment(randomuserId: randomUserId, commentId: comentId)
                            DB.document(chatRoomDocId).collection("messages").document(uid+"comentId").updateData(["randomUserId":randomUserId])
                        }
                    }
                } else if querySnapshot!.documents.count >= 2 {
                    
                    DB.document(chatRoomDocId).collection("members").document(uid).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let randomUserId = document["randomUserId"] as? String ?? "unknown"
                            
                            let comentId = randomString(length: 15)
                            comment(randomuserId: randomUserId, commentId: comentId)
                        }
                    }
                }
            }
            self.DB.document(chatRoomDocId).setData(["createdLatestAt": FieldValue.serverTimestamp()],merge: true)
            self.DB.document(chatRoomDocId).updateData(["messagecount": FieldValue.increment(Int64(1))])
        }
    }
}
extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        rurubus.remove(at: indexPath.row)
        chatRoomTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 25
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rurubus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRoomTableViewCell
        cell.sendImageView.image = nil
        cell.Imageheight.constant = 0
        let comentjidate = rurubus[indexPath.row].createdTime.dateValue()
        let comentjimoment = moment(comentjidate)
        let dateformatted1 = comentjimoment.format("hh:mm")
        let dateformatted2 = comentjimoment.format("MM/dd")
        cell.dateLabel.text = dateformatted1
        cell.thedayLabel.text = dateformatted2
        cell.chatnumbers.text = (String(indexPath.row + 1))
        
        if rurubus[indexPath.row].uid == uid {
            cell.houkokuButton.isHidden = true
            cell.iineButton.isHidden = true
        } else {
            cell.houkokuButton.isHidden = false
            cell.iineButton.isHidden = false
        }
        
        if dragons?.userId == rurubus[indexPath.row].uid {
            if dragons?.teamname == "red"{
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.6028199914)
            } else if dragons?.teamname == "blue" {
                cell.backView.backgroundColor = #colorLiteral(red: 0.3348371479, green: 0.9356233796, blue: 1, alpha: 0.6976401969)
            } else if dragons?.teamname == "yellow" {
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.9482958753, blue: 0, alpha: 0.698041524)
            } else if dragons?.teamname == "purple" {
                cell.backView.backgroundColor = #colorLiteral(red: 0.769806338, green: 0.4922828673, blue: 1, alpha: 0.6485712757)
            }
        } else {
            cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8024133134)
        }
        
        cell.messageLabel.textColor = #colorLiteral(red: 0.0431372549, green: 0.0431372549, blue: 0.0431372549, alpha: 0.8024133134)
        
        if rurubus[indexPath.row].iineman == "good" {
            cell.iineButton.tintColor = #colorLiteral(red: 0.9462587036, green: 0.3739997732, blue: 0.6042566379, alpha: 1)
        } else {
            cell.iineButton.tintColor = .gray
        }
        cell.backgroundColor = .clear
        print(rurubus.count)
        cell.userrandomId.text = rurubus[indexPath.row].randomUserId
        cell.message = rurubus[indexPath.row]
        cell.userImage.image = nil
        if rurubus[indexPath.row].userBrands == "TG1" {
            cell.userImage.image = UIImage(named:"TG1")!
            
        } else if rurubus[indexPath.row].userBrands == "TG2" {
            cell.userImage.image = UIImage(named:"TG2")!
            
        } else if rurubus[indexPath.row].userBrands == "TG3" {
            cell.userImage.image = UIImage(named:"TG3")!
            
        } else if rurubus[indexPath.row].userBrands == "TG4" {
            cell.userImage.image = UIImage(named:"TG4")!
            
        } else if rurubus[indexPath.row].userBrands == "TG5" {
            cell.userImage.image = UIImage(named:"TG5")!
        }
        cell.userImage.layer.cornerRadius = 17.5
        if rurubus[indexPath.row].sendImageURL != "" {
            if let url = URL(string: rurubus[indexPath.row].sendImageURL) {
                Nuke.loadImage(with: url, into: cell.sendImageView!)
                let width = UIScreen.main.bounds.size.width
                cell.Imageheight.constant = width*0.55
                cell.backView.backgroundColor = .clear
            }
        }
        return cell
    }
}
extension UIViewController {
    
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
extension UIView {
    func ChatRoomViewController() -> UIViewController? {
        var ChatRoomtableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomtableViewCellResponder = ChatRoomtableViewResponder?.next else { return nil }
            if let viewController = ChatRoomtableViewCellResponder as? UIViewController {
                return viewController
            }
            ChatRoomtableViewResponder = ChatRoomtableViewCellResponder
        }
    }
    func ChatRoomViewController<T: UIView>(type: T.Type) -> T? {
        var ChatRoomTableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomTableViewCellResponder = ChatRoomTableViewResponder?.next else { return nil }
            if let view = ChatRoomTableViewCellResponder as? T {
                return view
            }
            ChatRoomTableViewResponder = ChatRoomTableViewCellResponder
        }
    }
}
