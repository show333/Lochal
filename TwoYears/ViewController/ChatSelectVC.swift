//
//  ChatSelectVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ChatSelectVC:UIViewController {
    
    let db = Firestore.firestore()
    var teamSelect = [String]()
    
    @IBOutlet weak var oneButton: UIButton!
    
    @IBAction func tappedOneButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "InChatRoom", bundle: nil)
        let InChatRoomVC = storyboard.instantiateViewController(withIdentifier: "InChatRoomVC") as! InChatRoomVC
        navigationController?.pushViewController(InChatRoomVC, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchFireStore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("belong_Team").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarabai = Animal(dic: dic)
                    
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
                    
                    self.teamSelect.append(rarabai)
                    
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.teamSelect.sort { (m1, m2) -> Bool in
                        let m1Date = m1.latestAt.dateValue()
                        let m2Date = m2.latestAt.dateValue()
                        return m1Date > m2Date
                    }
//                    self.chatListTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
    
    
}
