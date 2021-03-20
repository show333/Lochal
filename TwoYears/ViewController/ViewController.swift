//
//  ViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class ViewController: UIViewController {
    
    
    var animals: [Animal] = []
    let DBZ = Firestore.firestore().collection("Rooms").document("karano")
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    private let cellId = "cellId"
    
    @IBAction func tappedBubuButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "sinkitoukou", bundle: nil)
        let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "sinkitoukou")
        self.present(sinkitoukou, animated: true, completion: nil)
        
        DBU.document(uid!).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                print(document["teamname"] as? String ?? "")
            } else {
                print("Document does not exist")
            }
        }
        
        let dt : Date = Date()
        print("ああああ", dt)
        
    }
    @IBOutlet weak var bubuButton: UIButton!
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "WhichOne", bundle: nil)
        let whichoneViewController = storyboard.instantiateViewController(withIdentifier: "WhichOneViewController")
        whichoneViewController.modalPresentationStyle = .fullScreen
        self.present(whichoneViewController, animated: true, completion: nil)
        
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        bubuButton.layer.cornerRadius = 50
        lalaBai()
        
    }
    
    
//    //func 関数名 (引数1:引数1の型, ...) -> 戻り値の型 {
//    private  func handleAddedDocumentChange(onepiece: DocumentChange) {
//
//        var chatroom = Animal(dic: onepiece.document.data(), lalaland: Int)
//        chatroom.documentId = onepiece.document.documentID
////
////       print("天照！！！", onepiece.document.data())
//        print("八尺瓊勾玉", onepiece.document.data())
//        print("月読み", onepiece.document)
//      print("イザナミだ", chatroom.documentId)
//    }
    
    private func lalaBai() {
        DBZ.collection("kokoniireru").whereField("teamname", isEqualTo: "red").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarbai = Animal(dic: dic, lalaland: 333)
                    
                    
                    DBZ.collection("kokoniireru").document(rarbai.documentId).collection("members").getDocuments { (snaps, error) in
                        if let error = error {
                            fatalError("\(error)")
                        }
                        
                        guard let snaps = snaps else { return }
                        for document in snaps.documents {
                            let dic = Naruto.document.data()
                            let rarbai = Animal(dic: dic, lalaland: document.data().count)
                            print("でぃく",dic)
                            print("ららばい",rarbai)
        //                    self.handleAddedDocumentChange(onepiece: Naruto)
                            self.animals.append(rarbai)
                            self.chatListTableView.reloadData()
                            print("ううううううう",document.data().count)
                        }
                    }
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
}
    

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        
        cell.messageLabel.text = animals[indexPath.row].nameJP
        
        if animals[indexPath.row].membersCount > 2 {
            cell.messageLabel.backgroundColor = .yellow
        }
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        
        chatRoomViewController.dragons = animals[indexPath.row]
        print("ああああああああああああ",
              chatRoomViewController.dragons as Any)
        print(animals[indexPath.row])
        
        
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}
