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
import ImageViewer

extension UIImageView: DisplaceableView {}

class UnitHomeVC:UIViewController, GalleryItemsDataSource, GalleryDisplacedViewsDataSource {
    func itemCount() -> Int {
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        GalleryItem.image { $0(self.teamImageView.image!) }
    }
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return teamImageView
    }
    
    
    var teamInfo : Team?
    var userInfo : [UserInfo] = []
    var galleyItem: GalleryItem!
    
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var buildingImageView: UIImageView!
    

    @IBOutlet weak var headerBackView: UIView!
    @IBOutlet weak var headerBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userCollectionViewConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true

        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headerBackView.clipsToBounds = true
        headerBackView.layer.masksToBounds = false
        headerBackView.layer.cornerRadius = 30
        headerBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        headerBackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerBackView.layer.shadowOpacity = 0.4
        headerBackView.layer.shadowRadius = 5

        
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
        
//        let image:UIImage = UIImage(url: teamInfo?.teamImage ?? "")
//        galleyItem = GalleryItem.image{ $0(image) }
//
//        teamImageView.isUserInteractionEnabled = true
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//        teamImageView.addGestureRecognizer(recognizer)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        teamImageView.addGestureRecognizer(tapGesture)
        teamImageView.isUserInteractionEnabled = true
        
        
        
        
        
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
        
        
        fetchUserTeamInfo(teamId: teamInfo?.teamId ?? "")
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2F%20building.001.png?alt=media&token=fc8ff7f1-e980-4d30-b3f0-494970e76882") {
            Nuke.loadImage(with: url, into: buildingImageView)
        } else {
            buildingImageView.image = nil
        }
 
        
        print("あああいあいあ")
    }
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
        presentImageGallery(viewController)
    }
    
    func fetchUserTeamInfo(teamId:String){
        
        print("トレジャー")
        
        db.collection("Team").document(teamId).collection("MembersId").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let userInfoDic = UserInfo(dic: dic)
                    self.userInfo.append(userInfoDic)
                    
                    self.userInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }

                case .modified, .removed:
                    print("noproblem")
                }
            })
            userCollectionView.reloadData()
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
        
        print("usera",userInfo)
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
