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
    var unitPostInfo: [PostInfo] = []
    var galleyItem: GalleryItem!
    
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var newPostButton: UIButton!
    
    @IBAction func newPostTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "CollectionPost", bundle: nil)
        let CollectionPostVC = storyboard.instantiateViewController(withIdentifier: "CollectionPostVC") as! CollectionPostVC
        
        CollectionPostVC.postDocString = teamInfo?.teamId
        
        self.present(CollectionPostVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var postCollectionView: UICollectionView!

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

        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        teamImageView.addGestureRecognizer(tapGesture)
        teamImageView.isUserInteractionEnabled = true
        
        
        
        
        
        teamImageView.clipsToBounds = true
        teamImageView.layer.cornerRadius = headerHeight/8
        
        setSwipeBack()
        
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
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
    
    func fetchUnitPostInfo(teamId:String){
        
        
        db.collection("Team").document(teamId).collection("UnitPost").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let unitPostInfoDoc = PostInfo(dic: dic)
                    self.unitPostInfo.append(unitPostInfoDoc)
                    
                    self.userInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }

                case .modified, .removed:
                    print("noproblem")
                }
            })
            postCollectionView.reloadData()
        }
    }
    
    
}

extension UnitHomeVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.userCollectionView {
            return userInfo.count

        }
        return 2

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let horizontalSpace : CGFloat = 50
            let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.userCollectionView {
            let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as!  UserCollectionViewCell
            let statusbarHeight = UIApplication.shared.statusBarFrame.height
            let safeAreaHeight = UIScreen.main.bounds.size.height - statusbarHeight
            let headerHeight = safeAreaHeight/3
            userCell.clipsToBounds = true
            userCell.layer.cornerRadius = headerHeight/8
            userCell.userImageView.image = nil

            print("uuuuu",userInfo)
            if let url = URL(string:userInfo[indexPath.row].userImage) {
                Nuke.loadImage(with: url, into: userCell.userImageView)
            } else {
                userCell.userImageView.image = nil
            }
            return userCell
        } else {
            
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as!  PostCollectionViewCell

            return postCell
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.userCollectionView {
            
            let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
            let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            
            ProfileVC.userId = userInfo[indexPath.row].userId
            ProfileVC.userName = userInfo[indexPath.row].userName
            ProfileVC.userImage = userInfo[indexPath.row].userImage
            ProfileVC.userFrontId = userInfo[indexPath.row].userFrontId
            ProfileVC.cellImageTap = true
            
            navigationController?.pushViewController(ProfileVC, animated: true)
        } else {
            let storyboard = UIStoryboard.init(name: "detailPost", bundle: nil)
            let detailPostVC = storyboard.instantiateViewController(withIdentifier: "detailPostVC") as! detailPostVC
            
            navigationController?.pushViewController(detailPostVC, animated: true)
        }
    }
    
    
}
class UserCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
