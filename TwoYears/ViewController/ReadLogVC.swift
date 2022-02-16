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
    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButton(_ sender: Any) {
        reallyButton.alpha = 1
        backGroundButton.alpha = 0.6
        explainLabel.alpha = 1
    }
    @IBOutlet weak var reallyButton: UIButton!
    
    @IBAction func reallyTappedButton(_ sender: Any) {
        db.collection("users").document(uid ?? "").collection("MyPost").document(documentId ?? "").setData(["delete":true] as [String : Any],merge: true)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var backGroundButton: UIButton!
    
    @IBAction func backGroundTappedButton(_ sender: Any) {
        backGroundButton.alpha = 0
        reallyButton.alpha = 0
        explainLabel.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        backGroundButton.alpha = 0
        reallyButton.alpha = 0
        explainLabel.alpha = 0
        
        reallyButton.clipsToBounds = true
        reallyButton.tintColor = .white
        reallyButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1478673758, blue: 0.2359769761, alpha: 1)
        reallyButton.layer.masksToBounds = false
        reallyButton.layer.cornerRadius = 10
        reallyButton.layer.shadowColor = UIColor.black.cgColor
        reallyButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        reallyButton.layer.shadowOpacity = 0.7
        reallyButton.layer.shadowRadius = 5
        
        deleteButton.clipsToBounds = true
        deleteButton.tintColor = .white
        deleteButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1478673758, blue: 0.2359769761, alpha: 1)
        deleteButton.layer.masksToBounds = false
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        deleteButton.layer.shadowOpacity = 0.7
        deleteButton.layer.shadowRadius = 5

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
