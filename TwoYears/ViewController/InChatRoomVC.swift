//
//  InChatRoomVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftMoment
import Nuke
import TTTAttributedLabel

class InChatRoomVC:UIViewController{
    
    var teamRoomDic : Team?
    var ChatRoomInfo = [ChatsInfo]()

    @IBOutlet weak var inChatTableView: UITableView!
    
    private let cellId = "cellId"
    private let accessoryHeight: CGFloat = 900
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    }
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 1000)
        view.delegate = self
        return view
    }()
    
    let db = Firestore.firestore()
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inChatTableView.backgroundColor = .systemBlue
        setSwipeBack()
        setupNotification()
        inChatTableView.delegate = self
        inChatTableView.dataSource = self
        inChatTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        inChatTableView.keyboardDismissMode = .interactive
        fetchFireStore()
    }
    
    
    
    private func fetchFireStore() {
        guard let teamId = teamRoomDic?.teamId else { return }
        db.collection("Team").document(teamId).collection("ChatRoom").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let chatsInfo = ChatsInfo(dic: dic)

//                    let date: Date = rarabai.zikokudosei.dateValue()
//                    let momentType = moment(date)

//                    if blockList[rarabai.userId] == true {
//
//                    } else {
//                        if momentType >= moment() - 14.days {
//                            if rarabai.admin == true {
//                            }
//                            self.animals.append(rarabai)
//                        }
//                    }

                    self.ChatRoomInfo.append(chatsInfo)
                    print("dイックs",chatsInfo)
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.ChatRoomInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date < m2Date
                    }
                    self.inChatTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
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
            let top = keyboardFrame.height - safeAreaBottom - 48
            let bottom = inChatTableView.contentOffset.y
            let moveY =  inChatTableView.contentOffset.y
            print(bottom)
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: top, right: 0)
            inChatTableView.contentInset = contentInset
            inChatTableView.scrollIndicatorInsets = contentInset
            inChatTableView.contentOffset = CGPoint(x: 0, y: moveY + top)
        }
    }
    @objc func keyboardWillHide() {
        print("keyboardWillHide")
        inChatTableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        inChatTableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}



extension InChatRoomVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRoomInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inChatTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRoomTableViewCell
        cell.messageLabel.text = ChatRoomInfo[indexPath.row].message
        cell.sendImageView.image = nil
        cell.userImage.image = nil
        cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8024133134)
        cell.Imageheight.constant = 0
        if ChatRoomInfo[indexPath.row].sendImageURL != "" {
            if let url = URL(string: ChatRoomInfo[indexPath.row].sendImageURL) {
                Nuke.loadImage(with: url, into: cell.sendImageView!)
                let width = UIScreen.main.bounds.size.width
                cell.Imageheight.constant = width*0.55
                cell.backView.backgroundColor = .clear
            }
        }
        
        
        
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
            cell.userImage.image = UIImage(named:data["userBrands"] as! String)!
              print("Current data: \(data)")
            }

        db.collection("users").document()
        
        
        return cell
    }
}
extension InChatRoomVC: ChatInputAccessoryViewDelegate{
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)
    }
    private func addMessageToFirestore(text: String) {
        chatInputAccessoryView.removeText()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let teamId = teamRoomDic?.teamId else { return }
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let commentId = randomString(length: 20)
                    let docData = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "message": text,
                        "userId": uid,
                        "teamId": teamRoomDic?.teamId as Any,
                        "comentId" : commentId,
                        "admin": false,
                        "sendImageURL": "",
                    ] as [String: Any]
        
        db.collection("Team").document(teamId).collection("ChatRoom").document(commentId).setData(docData)
        
    }
}

extension UIView {
    
    func setSwipeBack() {
        let target = ViewController()?.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.InChatRoomVC()?.view.addGestureRecognizer(recognizer)
    }
    
    func InChatRoomVC() -> UIViewController? {
        var ChatRoomtableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomtableViewCellResponder = ChatRoomtableViewResponder?.next else { return nil }
            if let viewController = ChatRoomtableViewCellResponder as? UIViewController {
                return viewController
            }
            ChatRoomtableViewResponder = ChatRoomtableViewCellResponder
        }
    }
    func InChatRoomVC<T: UIView>(type: T.Type) -> T? {
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
