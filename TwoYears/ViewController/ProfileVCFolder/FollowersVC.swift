//
//  FollowersVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/20.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke


class FollowersVC:UIViewController {
    private let cellId = "cellId"

    let db = Firestore.firestore()
    var userInfo : [UserInfo] = []

    
    @IBOutlet weak var userListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userListTableView.dataSource = self
        userListTableView.delegate = self
        fetchUserInfo(uid: uid)
    }

    func fetchUserInfo(uid:String){
        
        self.db.collection("users").document(uid).collection("Follower").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        getUserInfo(userId: userId)
                    }
                }
            }
        }
    }
    
    func getUserInfo(userId:String){
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.userListTableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}



extension FollowersVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! followersTableViewCell
        
        cell.userNameLabel.text = userInfo[indexPath.row].userName
        cell.userFrontIdLabel.text = userInfo[indexPath.row].userFrontId
        
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.cornerRadius = 25
        //
        cell.userImageView.image = nil
        if let url = URL(string:userInfo[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView?.image = nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = userInfo[indexPath.row].userId
        ProfileVC.cellImageTap = true
        navigationController?.pushViewController(ProfileVC, animated: true)

    }
    
    
}

class followersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userFrontIdLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
