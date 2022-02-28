//
//  detailPostVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import ImageViewer
import Nuke

class detailPostVC:UIViewController {
    
//    var postInfo: PostInfo?
    var sendedBool:Bool?
    var postInfoTitle: String?
    var postInfoImage: String?
    var postInfoDoc: String?
    var profileUserId:String?
    var userId: String?
    var userName: String?
    var userImage: String?
    var userFrontId: String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var userFrontIdLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
//    @IBOutlet weak var userImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    

    @IBOutlet weak var TPButton: UIButton!
    
    @IBAction func TPTappedButton(_ sender: Any) {
        alertAction()
    }
    
    @IBOutlet weak var transitionReMemoConstraint: NSLayoutConstraint!
    @IBOutlet weak var transitionReMemoWidth: NSLayoutConstraint!
    @IBOutlet weak var trainsitionReMemoButton: UIButton!
    
    @IBAction func transitionTappedReMemoButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "ReMemoPost", bundle: nil)
        let ReMemoPostVC = storyboard.instantiateViewController(withIdentifier: "ReMemoPostVC") as! ReMemoPostVC
        ReMemoPostVC.postInfoTitle = postInfoTitle
        ReMemoPostVC.postInfoImage = postInfoImage
        ReMemoPostVC.userId = self.userId
        ReMemoPostVC.userFrontId = self.userFrontId
        ReMemoPostVC.userName = self.userName
        ReMemoPostVC.userImage = self.userImage

        self.present(ReMemoPostVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var storyShareConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storyShareWidth: NSLayoutConstraint!
    @IBOutlet weak var storyShareButton: UIButton!
    
    @IBAction func tappedStoryShareButton(_ sender: Any) {
        TPButton.alpha = 0
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        shareStickerImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 30
        backGroundView.backgroundColor = .clear
        
        titleLabel.font = UIFont(name:"03SmartFontUI", size:22)
        
        trainsitionReMemoButton.backgroundColor = .white
        trainsitionReMemoButton.clipsToBounds = true
        trainsitionReMemoButton.layer.masksToBounds = false
        trainsitionReMemoButton.layer.cornerRadius = 10
        trainsitionReMemoButton.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        trainsitionReMemoButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        trainsitionReMemoButton.layer.shadowOpacity = 0.7
        trainsitionReMemoButton.layer.shadowRadius = 5
        
        storyShareButton.backgroundColor = .white
        storyShareButton.clipsToBounds = true
        storyShareButton.layer.masksToBounds = false
        storyShareButton.layer.cornerRadius = 10
        storyShareButton.layer.shadowColor = #colorLiteral(red: 1, green: 0.2916699052, blue: 0.7794274092, alpha: 1)
        storyShareButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        storyShareButton.layer.shadowOpacity = 0.7
        storyShareButton.layer.shadowRadius = 5
        
        let safeAreaWidth = UIScreen.main.bounds.size.width

        transitionReMemoWidth.constant = safeAreaWidth/2.5
        transitionReMemoConstraint.constant = safeAreaWidth/16
        storyShareWidth.constant = safeAreaWidth/2.5
        storyShareConstraint.constant = safeAreaWidth/16
        
//        trainsitionReMemoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        trainsitionReMemoButton.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 15)
//        storyShareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        storyShareButton.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 15)


        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        if uid == profileUserId {
            trainsitionReMemoButton.alpha = 1
            storyShareButton.alpha = 1
//        } else {
//            trainsitionReMemoButton.alpha = 0
//            storyShareButton.alpha = 0
//        }
        if uid == userId || uid == profileUserId {
             TPButton.alpha = 1

         } else {
             TPButton.alpha = 0
         }
        backGroundView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0.9)

        
        setSwipeBack()
        if let url = URL(string:postInfoImage ?? "") {
            Nuke.loadImage(with: url, into: postImageView)
        } else {
            postImageView.image = nil
        }
        
        let postTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(postTap(_:)))
        postImageView.addGestureRecognizer(postTapGesture)
        postImageView.isUserInteractionEnabled = true
        
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 16
        
        
        
        let userTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(userTap(_:)))
        
        userImageView.addGestureRecognizer(userTapGesture)
        userImageView.isUserInteractionEnabled = true

        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 30
        
        titleLabel.text = postInfoTitle
        getUserInfo()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("aaa")
    }
    
    func shareStickerImage() {
        let image = backGroundView.asImage()
        let backGroundImage:UIImage = UIImage(url:UserDefaults.standard.string(forKey: "userBackGround") ?? "")
        let url = URL(string: "instagram-stories://share")
        let items: NSArray = [["com.instagram.sharedSticker.stickerImage": image,
                               "com.instagram.sharedSticker.backgroundImage": backGroundImage,
                               "com.instagram.sharedSticker.backgroundTopColor": "#00ff00",
                               "com.instagram.sharedSticker.backgroundBottomColor": "#ff00ff"]]
        UIPasteboard.general.setItems(items as! [[String : Any]], options: [:])
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        

    }
    
    func getUserInfo(){
        db.collection("users").document(userId ?? "").collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                

                
                let userNameString = document["userName"] as? String ?? ""
                let userImageString = document["userImage"] as? String ?? ""
                let userFrontIdString = document["userFrontId"] as? String ?? ""
                
                userName = userNameString
                userImage = userImageString
                userFrontId = userFrontIdString
                
                
                
                userNameLabel.text = userNameString
                userFrontIdLabel.text = userFrontIdString
                if let url = URL(string:userImageString) {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView.image = nil
                }
                
            }
        }
    }
    @objc private func postTap(_ sender: UITapGestureRecognizer) {
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
    
    @objc private func userTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        ProfileVC.userId = userId
        ProfileVC.userName = userName
        ProfileVC.userImage = userImage
        ProfileVC.userFrontId = userFrontId
        ProfileVC.cellImageTap = true
        
        navigationController?.pushViewController(ProfileVC, animated: true)
        
    }
    
    func alertAction() {
        let alertController:UIAlertController =
        UIAlertController(title:"削除しますか？",
                          message: "投稿をしたユーザーと受け付けたユーザーのみ選択可能です",
                          preferredStyle: .actionSheet)

        
        // Destructive のaction
        let destructiveAction:UIAlertAction =
        UIAlertAction(title: "削除",
                      style: .destructive,
                      handler:{
            (action:UIAlertAction!) -> Void in
            self.deleteDoc()
        })
        
        // Cancel のaction
        let cancelAction:UIAlertAction =
        UIAlertAction(title: "Cancel",
                      style: .cancel,
                      handler:{
            (action:UIAlertAction!) -> Void in
            // 処理
        })
        
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
    

        alertController.popoverPresentationController?.sourceView = self.view

        let screenSize = UIScreen.main.bounds
        alertController.popoverPresentationController?.sourceRect=CGRect(x:screenSize.size.width/2,y:screenSize.size.height,width:0,height:0)
        
        // UIAlertControllerの起動
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteDoc(){
        db.collection("users").document(profileUserId ?? "").collection("SendedPost").document(postInfoDoc ?? "").delete()
        self.navigationController?.popToRootViewController(animated: true)
//        // Create a reference to the file to delete
//        let storageRef = Storage.storage().reference().child("Unit_Post_Image").child(postInfo?.postImage ?? "")
//        // Delete the file
//        storageRef.delete { error in
//          if let error = error {
//            // Uh-oh, an error occurred!
//              print(error)
//          } else {
//            // File deleted successfully
//          }
//        }
            
    }
    
}
extension detailPostVC: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.postImageView.image!) }
    }
}
extension detailPostVC: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return postImageView
    }
}
extension UIView {
    //UIViewをUIImageに変換するコード
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
