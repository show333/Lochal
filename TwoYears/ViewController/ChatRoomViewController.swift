//
//  ChatRoomViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChatRoomViewController: UIViewController {
    
    
    
    var dragons: Animal?

    private var rurubus = [Message]()
    private let cellId = "cellId"
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 90)
        view.delegate = self
        return view
    }()
    
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "戻る",
            style: .plain,
            target: nil,
            action: nil
        )
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
//        chatRoomTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = .black
        setSwipeBack()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchMessages() {
        let chatRoomDocId = dragons!.documentId
        
        Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(chatRoomDocId).collection("messages").addSnapshotListener{ (snapshots, err) in
            
            if let err = err {
                print("失敗やで、、、\(err)")
                return
            }
            
            snapshots?.documentChanges.forEach({( documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic)
                    self.rurubus.append(message)
                    self.chatRoomTableView.reloadData()
//                    print("チャットルームないのでーーーーーた: ",dic)
                    
                case .modified, .removed:
                    print("ナッシング")
                }
            })
        }
    }
}

extension ChatRoomViewController: ChatInputAccessoryViewDelegate {
    
    func tappedSendButton(text: String) {
        
//        rurubus.append(text)
//        chatInputAccessoryView.removeText()
//        chatRoomTableView.reloadData()
//        print("チャットルーム内の送信ボタンが押された！")
//        print(dragons!)
//        print(dragons!.documentId)
        chatInputAccessoryView.removeText()
        
        let chatRoomDocId = dragons!.documentId
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let docData = [
            "createdAt": Timestamp(),
            "message": text,
            "userId": uid,
        ] as [String: Any]
        
        Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(chatRoomDocId).collection("messages").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。ss\(err)")
                return
            }
            print("成功！")
            print("aaa")
            
    //              let saveDocument = Firestore.firestore()
    //               let user = Auth.auth().currentUser

            //Arrayのやり方は後で今はこのやり方でcountする。
            Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(chatRoomDocId).collection("members").document("membersId").updateData([uid:uid])
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rurubus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRoomTableViewCell
//        cell.messageTextView.text = rurubus[indexPath.row]
        cell.message = rurubus[indexPath.row]
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
