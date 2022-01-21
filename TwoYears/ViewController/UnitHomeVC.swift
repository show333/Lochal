//
//  UnitHomeVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke


class UnitHomeVC:UIViewController {
    
    var teamInfo : Team?
    var userInfo : [UserInfo] = []

    let db = Firestore.firestore()
    
    @IBOutlet weak var headerBackView: UIView!
    @IBOutlet weak var headerBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userCollectionViewConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
        let headerHeight = safeAreaHeight/3
        
        headerBackViewConstraint.constant = headerHeight
        teamImageViewConstraint.constant = headerHeight/2
        userCollectionViewConstraint.constant = headerHeight/4
        
        teamNameLabel.text = teamInfo?.teamName
        if let url = URL(string:teamInfo?.teamImage ?? "") {
            Nuke.loadImage(with: url, into: teamImageView)
        } else {
            teamImageView.image = nil
        }
        
        teamImageView.clipsToBounds = true
        teamImageView.layer.cornerRadius = headerHeight/8
        
        setSwipeBack()


        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: headerHeight/4, height: headerHeight/4)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.userCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.userCollectionView.backgroundColor = .clear
        
        teamImageView.backgroundColor = .yellow
        
        fetchTeamInfo(teamId: teamInfo?.teamId ?? "")
    }
    func fetchTeamInfo(teamId:String){
        
        
        self.db.collection("Team").document(teamId).collection("MembersId").document("membersId")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                let userIdArray = data["userId"] as! Array<String>

                
                self.userInfo.removeAll()
                self.userCollectionView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    userIdArray.forEach{
                        self.getUserInfo(userId: $0)
                    }
                }
            }
        
    }
    
    func getUserInfo(userId:String){
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let userInfoDic = UserInfo(dic: document.data()!)
                self.userInfo.append(userInfoDic)
  
                self.userCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension UnitHomeVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let horizontalSpace : CGFloat = 50
            let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
            return CGSize(width: cellSize, height: cellSize)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!  UserCollectionViewCell
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
        let headerHeight = safeAreaHeight/3
        cell.clipsToBounds = true
        cell.layer.cornerRadius = headerHeight/8
        cell.userImageView.image = nil
        if let url = URL(string:userInfo[indexPath.row].userImage) {
            Nuke.loadImage(with: url, into: cell.userImageView)
        } else {
            cell.userImageView.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        ProfileVC.userId = userInfo[indexPath.row].userId
        ProfileVC.userName = userInfo[indexPath.row].userName
        ProfileVC.userImage = userInfo[indexPath.row].userImage
        ProfileVC.userFrontId = userInfo[indexPath.row].userFrontId
        ProfileVC.cellImageTap = true


        navigationController?.pushViewController(ProfileVC, animated: true)
    }
    
    
}
class UserCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

