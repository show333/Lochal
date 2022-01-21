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

    
    @IBOutlet weak var reactionBackButton: UIButton!
    
    @IBAction func reactionTappedButton(_ sender: Any) {
        
        onUserImageView.alpha = 0
        onUserNameLabel.alpha = 0
        onReactionView.alpha = 0
        onMessageBackView.alpha = 0
        onMessageLabel.alpha = 0
        reactionBackButton.alpha = 0
        onCloseLabel.alpha = 0

        
    }
    
    @IBOutlet weak var onUserImageView: UIImageView!
    @IBOutlet weak var onUserNameLabel: UILabel!
    @IBOutlet weak var onReactionView: UIImageView!
    @IBOutlet weak var onReactionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var onMessageBackView: UIView!
    @IBOutlet weak var onBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var onMessageLabel: UILabel!
    @IBOutlet weak var onCloseLabel: UILabel!
    @IBOutlet weak var reactionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        setSwipeBack()

        let width = UIScreen.main.bounds.size.width
        onReactionViewConstraint.constant = width*0.55
        onBackViewConstraint.constant = width*0.3
        
        onUserImageView.alpha = 0
        onUserNameLabel.alpha = 0
        onReactionView.alpha = 0
        onMessageBackView.alpha = 0
        onMessageLabel.alpha = 0
        onCloseLabel.alpha = 0
        reactionBackButton.alpha = 0
        
        onMessageBackView.clipsToBounds = true
        onMessageBackView.layer.cornerRadius = 18
        
        onUserImageView.clipsToBounds = true
        onUserImageView.layer.cornerRadius = 30
        
        onMessageBackView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData(["notificationNum": 0],merge: true)
    }
    func fetchReaction(userId:String) {
        db.collection("users").document(userId).collection("Notification").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let reactionDic = Reaction(dic: dic)
                    
                    self.reaction.append(reactionDic)

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
        
        cell.reaction = reaction[indexPath.row]
        
        cell.messageLabel.text = reaction[indexPath.row].reactionMessage
        
        let date: Date = reaction[indexPath.row].createdAt.dateValue()
        cell.dateLabel.text = date.agoText()
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 25
        cell.userImageView.image = nil
        if let url = URL(string:reaction[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        cell.userNameLabel.text = reaction[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if reaction[indexPath.row].theMessage != "" {
            onMessageLabel.text = reaction[indexPath.row].theMessage
            onUserNameLabel.text = reaction[indexPath.row].userName
            
            if let url = URL(string:reaction[indexPath.row].userImage) {
                Nuke.loadImage(with: url, into: onUserImageView)
            } else {
                onUserImageView.image = nil
            }
            
            
            if let url = URL(string:reaction[indexPath.row].reactionImage) {
                Nuke.loadImage(with: url, into: onReactionView)
            } else {
                onReactionView.image = nil
            }
            
            
            
     
            reactionBackButton.alpha = 0.8
            onAnimation()
            
        } else {
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            ProfileVC.userId = reaction[indexPath.row].userId
            ProfileVC.cellImageTap = true
            navigationController?.pushViewController(ProfileVC, animated: true)
        }
    }
    
    func onAnimation(){
        onMessageAnimation()
        onUserImageAnimation()
        onCloseLabelAnimation()
    }
    
    func onMessageAnimation() {

            // ②アイコンを大きくする
        UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
            self.onMessageBackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.onMessageLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                onMessageBackView.alpha = 1
                onMessageLabel.alpha = 1
                
            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.05, delay: 0, animations: {
                    self.onMessageBackView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.onMessageLabel.transform = CGAffineTransform(scaleX: 1, y: 1)

                    
                })
//            }
        }
    }
    func onUserImageAnimation() {

        // ②アイコンを大きくする
        UIView.animate(withDuration: 0.1, delay: 0.1, animations: { [self] in
            self.onUserImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.onReactionView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.onUserNameLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            onUserImageView.alpha = 1
            onReactionView.alpha = 1
            onUserNameLabel.alpha = 1

            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.1, delay: 0, animations: {
                    self.onUserImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.onReactionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.onUserNameLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
        }
    }
    
    
    func onCloseLabelAnimation() {
        UIView.animate(withDuration: 0.05, delay: 0.1, animations: { [self] in
            self.onCloseLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            onCloseLabel.alpha = 1

            //
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                self.onCloseLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            })
            
        }
        
    }
    
    
}

class reactionTableViewCell: UITableViewCell {
    
    var reaction : Reaction?

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = reaction?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
    }
}
