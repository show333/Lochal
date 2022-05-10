//
//  OutmMemoCellVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke
import ImageViewer
import AVKit
import AVFoundation


class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
    }
}



class OutmMemoCellVC: UITableViewCell {
    
    
    let db = Firestore.firestore()
    var teamInfo : [Team] = []
    var outMemo : OutMemo?
    var indexPath : [Int] = []
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.backgroundColor = .clear
    }
    
    @IBOutlet weak var shareButton: UIButton!
    

    @IBOutlet weak var storyBackView: UIView!
    
    @IBOutlet weak var userFrontIdLabel: UILabel!
    @IBOutlet weak var backBack: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendImageView: UIImageView!
    
    @IBOutlet weak var sendImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var sendImageConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playCircleImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var coverView: UIView!
    
    
    @IBOutlet weak var textMaskLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    @IBOutlet weak var flagButton: UIButton!
    
    
    @IBOutlet weak var graffitiBackGroundView: UIView!
    @IBOutlet weak var graffitiBackGroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiUserImageView: UIImageView!
    
    @IBOutlet weak var graffitiUserFrontIdLabel: UILabel!
    
    @IBOutlet weak var graffitiContentsImageView: UIImageView!
    
    @IBOutlet weak var graffitiTitleLabel: UILabel!
    
    @IBOutlet weak var graffitiLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.font = UIFont(name:"03SmartFontUI", size:19)
        graffitiTitleLabel.font = UIFont(name:"03SmartFontUI", size:16)
        
        print("愛絵愛フォイアジョイsj絵おいファj添えfじゃおふぇいj",outMemo?.anonymous)
        
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userImageTapped(_:))))
                
        graffitiUserImageView.isUserInteractionEnabled = true
        graffitiUserImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(graffitiUserimageTapped(_:))))
                
        graffitiBackGroundView.isUserInteractionEnabled = true
        graffitiBackGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(graffitiBackGroundTapped(_:))))
        
        sendImageView.isUserInteractionEnabled = true
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendImageViewTapped(_:))))
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
        let nib = UINib(nibName: "TeamCollectionViewCell", bundle: nil)
        teamCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        mainBackground.backgroundColor = .tertiarySystemGroupedBackground
        
//        coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        //
        //        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        //        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        //
        //        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        //
        //        safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        //
        //        collectionViewConstraint.constant = safeArea/4
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear
        
        self.teamCollectionView.alpha = 1
        
        teamInfo.removeAll()
    }
    
    func getUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let teamId = document.data()["teamId"] as? String ?? ""
                        getTeamInfo(teamId: teamId)
                    }
                }
            }
        }
    }
    
    func fetchUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let teamInfoDic = Team(dic: dic)
                    
                    let teamId = Naruto.document.data()["teamId"] as? String ?? ""
                    getTeamInfo(teamId: teamId)
                    self.teamInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                case .modified, .removed:
                    print("noproblem")
                }
            })
        }
    }
    
    func getTeamInfo(teamId:String){
        db.collection("Team").document(teamId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let teamDic = Team(dic: document.data()!)
                self.teamInfo.append(teamDic)
                print("翼をください！",teamId)
                print("翼をください！",document.data()!)
                print("asefiosejof",teamDic)
                
                self.teamInfo.sort { (m1, m2) -> Bool in
                    let m1Date = m1.createdAt.dateValue()
                    let m2Date = m2.createdAt.dateValue()
                    return m1Date > m2Date
                }
                
                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func userImageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        if outMemo?.anonymous == false {
        ProfileVC.userId = outMemo?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
        }
    }
    
    @objc func sendImageViewTapped(_ sender: UITapGestureRecognizer) {
        
        if outMemo?.assetsType == "image" {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
        ViewController()?.presentImageGallery(viewController)
        } else if outMemo?.assetsType == "movie" {
            playMovieFromUrl(movieUrl: URL(string: outMemo!.sendMovieURL))
        }
    }
    func playMovieFromUrl(movieUrl: URL?) {
        if let movieUrl = movieUrl {
            let videoPlayer = AVPlayer(url: movieUrl)
            let playerController = AVPlayerViewController()
            playerController.player = videoPlayer
            ViewController()?.present(playerController, animated: true, completion: {
                videoPlayer.play()
            })
        } else {
            print("cannot play")
        }
    }
    
    func playMovieFromPath(moviePath: String?) {
        if let moviePath = moviePath {
            self.playMovieFromUrl(movieUrl: URL(fileURLWithPath: moviePath))
        } else {
            print("no such file")
        }
    }
    
    @objc func graffitiUserimageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = outMemo?.graffitiUserId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
    }
    @objc func graffitiBackGroundTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "detailPost", bundle: nil)
        let detailPostVC = storyboard.instantiateViewController(withIdentifier: "detailPostVC") as! detailPostVC
        guard let uid = Auth.auth().currentUser?.uid else {return}
//        var postInfo: PostInfo?
//        var profileUserId:String?
//        var userId: String?
//        var userName: String?
//        var userImage: String?
//        var userFrontId: String?
        detailPostVC.postUserId = outMemo?.graffitiUserId
        detailPostVC.userName = outMemo?.graffitiUserName
        detailPostVC.userImage = outMemo?.graffitiUserImage
        detailPostVC.userFrontId = outMemo?.graffitiUserFrontId
        detailPostVC.postInfoTitle = outMemo?.graffitiTitle
        detailPostVC.postTextFontName = outMemo?.textFontName
        detailPostVC.postInfoDoc = outMemo?.documentId
        detailPostVC.postInfoImage = outMemo?.graffitiContentsImage
        detailPostVC.profileUserId = uid
        detailPostVC.postHexColor = outMemo?.hexColor
        detailPostVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(detailPostVC, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
   
}

extension OutmMemoCellVC :UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TeamCollectionViewCellVC
        cell.teamImageView.clipsToBounds = true
        cell.teamImageView.layer.cornerRadius = 10
        
        cell.teamImageView.image = nil
        
        
        if let url = URL(string: teamInfo[indexPath.row].teamImage) {
            Nuke.loadImage(with: url, into: cell.teamImageView)
        } else {
            cell.teamImageView?.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "UnitHome", bundle: nil)
        let UnitHomeVC = storyboard.instantiateViewController(withIdentifier: "UnitHomeVC") as! UnitHomeVC
        UnitHomeVC.teamInfo = teamInfo[indexPath.row]
        
        ViewController()?.navigationController?.pushViewController(UnitHomeVC, animated: true)
    }
    
}
extension OutmMemoCellVC: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.sendImageView.image!) }
    }
}

// MARK: GalleryDisplacedViewsDataSource
extension OutmMemoCellVC: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return sendImageView
    }
}
