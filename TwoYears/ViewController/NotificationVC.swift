//
//  NotificationVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class NotificationVC: UIViewController {
    
    var reaction : [Reaction] = []
    var notificationTab : Bool = false
    private let cellId = "cellId"
    let db = Firestore.firestore()

    
    @IBOutlet weak var reactionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        setSwipeBack()


        reactionTableView.delegate = self
        reactionTableView.dataSource = self
        
        fetchReaction(userId:uid)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        if notificationTab == true {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    func fetchReaction(userId:String) {
        db.collection("users").document(userId).collection("Reaction").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let reactionDic = Reaction(dic: dic)
                    
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
                    
                    self.reaction.append(reactionDic)
                    
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.reaction.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.reactionTableView.reloadData()
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
}

extension NotificationVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reactionTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! reactionTableViewCell
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 30
        cell.userImageView.image = nil
        cell.reactionView.image = nil
        cell.messageLabel.text = reaction[indexPath.row].theMessage
        if let url = URL(string:reaction[indexPath.row].reaction) {
            Nuke.loadImage(with: url, into: cell.reactionView!)
        } else {
            cell.reactionView?.image = nil
        }
//        fetchUserProfile(userId: reaction[indexPath.row].userId, cell: cell)
//        getUserInfo(userId: reaction[indexPath.row].userId, cell: cell)
        
        
        if let url = URL(string:reaction[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        cell.userNameLabel.text = reaction[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = reaction[indexPath.row].userId
        ProfileVC.cellImageTap = true
        navigationController?.pushViewController(ProfileVC, animated: true)

    }
    

    
}

class reactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reactionView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
