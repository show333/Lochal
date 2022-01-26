//
//  FollowingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke
import DZNEmptyDataSet


class FollowingsVC:UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
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
        userListTableView.emptyDataSetDelegate = self
        userListTableView.emptyDataSetSource = self
        fetchUserInfo(uid: uid)
    }
    
//     blankword for tableview
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
    
    
    func fetchUserInfo(uid:String){
        
        self.db.collection("users").document(uid).collection("Following").getDocuments() { [self] (querySnapshot, err) in
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
    
//    func fetchUserInfo(userId:String){
//
//        self.db.collection("users").document(userId).collection("Following").document("following_Id")
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                guard let data = document.data() else {
//                    print("Document data was empty.")
//                    return
//                }
//                print("Current data: \(data)")
//                let userIdArray = data["userId"] as! Array<String>
//
//                self.userInfo.removeAll()
//                self.userListTableView.reloadData()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    userIdArray.forEach{
//                        self.getUserInfo(userId: $0)
//                    }
//                }
//            }
//    }
    
    func getUserInfo(userId:String){
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let userInfoDic = UserInfo(dic: document.data()!)
                self.userInfo.append(userInfoDic)
                self.userListTableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}



extension FollowingsVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FollowingsTableViewCell
        
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

class FollowingsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFrontIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
