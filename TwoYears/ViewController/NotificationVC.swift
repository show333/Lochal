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
    var outMemo: OutMemo?
    var notificationTab : Bool = false
    var userId : String?
    var cellDocumentId : String?
    var userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String
    var userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String
    var userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String
    private let cellId = "cellId"
    let db = Firestore.firestore()
    
    
    
    @IBOutlet weak var requestLabel: UILabel!
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
    
    @IBOutlet weak var acceptImageView: UIImageView!
    
    @IBOutlet weak var acceptImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptedImageView: UIImageView!

    @IBOutlet weak var acceptedImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptingBackButton: UIButton!
    @IBAction func acceptingBackTappedButton(_ sender: Any) {
        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        requestLabel.alpha = 0

    }
    @IBOutlet weak var acceptingButton: UIButton!
    
    @IBAction func acceptingTappedButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        reaction[indexPathRow ?? 0].reactionMessage = "さんがフォローをしました"
        
   
        followSet(uid: uid)
        MyPostGet(uid: uid)
        
        
        reaction.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.fetchReaction(userId:uid)

        }
        
        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        requestLabel.alpha = 0
        
        
    }
    
    func followSet(uid:String){
        
        let acceptNotification = [
            "createdAt": FieldValue.serverTimestamp(),
            "userId": uid,
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            "documentId" : "accept"+uid,
            "reactionImage": "",
            "reactionMessage":"さんがフォローを許可しました",
            "theMessage": "",
            "dataType": "accepted",
            "anonymous":false,
            "admin": false,
        ] as [String: Any]
        
        db.collection("users").document(userId ?? "").collection("Notification").document("accept"+uid).setData(acceptNotification, merge: true)
        db.collection("users").document(userId ?? "").setData(["notificationNum": FieldValue.increment(1.0)], merge: true)

        db.collection("users").document(uid).collection("Notification").document(cellDocumentId ?? "").setData(["reactionMessage":"さんがフォローをしました"], merge: true)
        db.collection("users").document(uid).collection("Notification").document(cellDocumentId ?? "").setData(["acceptBool":true], merge: true)
        
        db.collection("users").document(userId ?? "").collection("Following").document(uid).setData(["status":"accept"], merge: true)
        
        db.collection("users").document(uid).collection("Follower").document(userId ?? "").setData(["status":"accept"], merge: true)
        
        db.collection("users").document(userId ?? "").setData(["followingCount": FieldValue.increment(1.0)], merge: true)
        db.collection("users").document(uid).setData(["followerCount": FieldValue.increment(1.0)], merge: true)
        
    }
    
    func MyPostGet(uid:String){
        db.collection("users").document(uid).collection("MyPost").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                    
                        print("\(document.documentID) => \(document.data())")
                        let dic = document.data()
                        let outMemoDic = OutMemo(dic: dic)
                        
                        MyPostSet(userId:userId ?? "",outMemo: outMemoDic)
                    }
                }
            }
        }
        
    }
    
    func MyPostSet(userId:String,outMemo:OutMemo){
        
        let memoInfoDic = [
            "message" : outMemo.message,
            "sendImageURL": outMemo.sendImageURL,
            "documentId": outMemo.documentId,
            "createdAt": outMemo.createdAt,
            "textMask":outMemo.textMask,
            "userId":outMemo.userId,
            "userName":outMemo.userName,
            "userFrontId":outMemo.userFrontId,
            "readLog": false,
            "anonymous":outMemo.anonymous,
            "admin": outMemo.admin,
            "delete": outMemo.delete,
            
        ] as [String: Any]
        
        db.collection("users").document(userId).collection("TimeLine").document(outMemo.documentId).setData(memoInfoDic,merge: true)
//        let userId = document.data()["userId"] as! String
//                        getUserInfo(userId: userId)
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
        
        
        requestLabel.alpha = 0
        
        
        acceptImageConstraint.constant = width/2
        acceptedImageConstraint.constant = width/2
        acceptButtonConstraint.constant = width/2
        
        acceptImageView.clipsToBounds = true
        acceptedImageView.clipsToBounds = true
        acceptImageView.layer.cornerRadius = width/8
        acceptedImageView.layer.cornerRadius = width/8

        acceptingButton.alpha = 0
        acceptImageView.alpha = 0
        acceptedImageView.alpha = 0
        acceptingBackButton.alpha = 0
        
        onMessageBackView.clipsToBounds = true
        onMessageBackView.layer.cornerRadius = 18
        
        onUserImageView.clipsToBounds = true
        onUserImageView.layer.cornerRadius = 30
        
        onMessageBackView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

        reactionTableView.delegate = self
        reactionTableView.dataSource = self
        
        fetchReaction(userId:uid)
        

        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FunLock.001.png?alt=media&token=dbbffbb2-26c1-4623-ac12-ca1185b2b424") {
            Nuke.loadImage(with: url, into: acceptImageView)
        } else {
            acceptImageView?.image = nil
        }
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2Faccept.001.png?alt=media&token=67e1a7eb-1e84-4b5b-93f2-a49d9987ddfa") {
            Nuke.loadImage(with: url, into: acceptedImageView)
        } else {
            acceptedImageView?.image = nil
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        if notificationTab == true {
            self.tabBarController?.tabBar.isHidden = false
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
        
        if reaction[indexPath.row].dataType == "reaction" {
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
            
        } else if reaction[indexPath.row].dataType == "acceptingFollow"{
            cellDocumentId = reaction[indexPath.row].documentId
            userId = reaction[indexPath.row].userId
            if reaction[indexPath.row].acceptBool == false {
                acceptImageAnimation(imageView: acceptImageView)
                acceptingBackButton.alpha = 0.8
                acceptingButton.alpha = 1
                requestLabel.text = "↓タップでフォローを許可"
                
            } else {
                acceptImageAnimation(imageView: acceptedImageView)
                acceptingBackButton.alpha = 0.8
                requestLabel.text = "フォロー認証済み"
            }
        } else if reaction[indexPath.row].dataType == "followersPost"{
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            guard let uid = Auth.auth().currentUser?.uid else { return }
            ProfileVC.userId = uid
            ProfileVC.cellImageTap = true
            navigationController?.pushViewController(ProfileVC, animated: true)
        } else {
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            ProfileVC.userId = reaction[indexPath.row].userId
            ProfileVC.cellImageTap = true
            navigationController?.pushViewController(ProfileVC, animated: true)
        }
    }
    
    func acceptImageAnimation(imageView: UIImageView){
        
        
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            imageView.alpha = 1
            self.requestLabel.alpha = 1
            
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.05, delay: 0, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            })
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
