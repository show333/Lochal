//
//  ReadLogVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/05.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class ReadLogVC: UIViewController{
    
    private let cellId = "cellId"
    let db = Firestore.firestore()
    let uid =  UserDefaults.standard.string(forKey: "userId")
    var documentId:String?
    var readLog: [ReadLog] = []
    
    @IBOutlet weak var readLogTableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }

        readLogTableView.delegate = self
        readLogTableView.dataSource = self
        getReadLog(userId: uid)
        readLogTableView.tableFooterView = UIView()
    }

    
    
    func getReadLog(userId:String) {
        db.collection("users").document(userId).collection("MyPost").document(documentId ?? "").collection("Readlog").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (documentChanges) in
                switch documentChanges.type {
                case .added:
                    let dic = documentChanges.document.data()
                    let readLogDic = ReadLog(dic: dic)
                    
//                    let date: Date = rarabai.zikokudosei.dateValue()
//                    let momentType = moment(date)

                    
                    self.readLog.append(readLogDic)
                    
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.readLog.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.readLogTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
    
    
}
extension ReadLogVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = readLogTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReadLogTableViewCell
        cell.userNameLabel.text = readLog[indexPath.row].userName
        
        cell.userImageView.image = nil
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 20
        
        cell.userImageView.image = nil
        if let url = URL(string:readLog[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        return cell
    }
    
    
}

class ReadLogTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
