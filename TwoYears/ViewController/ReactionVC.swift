//
//  ReactionVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class ReactionVC: UIViewController {
    
    
    @IBOutlet weak var upView: UIView!
    
    @IBOutlet weak var upViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var reactiCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    var safeArea : CGFloat = 0
    var stampUrls : String?
    var imageUrls = [String]()
    var message: String?
    var userId: String?
    var userImage: String?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8020463346)
        reactiCollectionView.dataSource = self
        reactiCollectionView.delegate = self

        messageLabel.text = message
        
        fetchUserProfile(userId: userId ?? "")
        
        safeArea = UIScreen.main.bounds.size.width
        
        collectionViewConstraint.constant = safeArea
        upViewConstraint.constant = safeArea/4
        
       
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: safeArea/2, height: safeArea/2)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.reactiCollectionView.collectionViewLayout = flowLayout
        
        imageUrls =  ["https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FR1heart.png?alt=media&token=ce267566-cfc5-4360-93f7-1fa11d183101",//R1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FR2smile.png?alt=media&token=226eb03e-78bd-4ada-8d75-2ca47871f3cb",//R2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FR3pien.png?alt=media&token=8ed5fb31-654c-48d7-9976-412d23895bde",//R3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FR4anger.png?alt=media&token=0a473423-ab37-4c17-a29f-90b5fc75fb51",//R4
                      ]
    }
    func fetchUserProfile(userId:String){

        db.collection("users").document(userId).collection("Profile").document("profile")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                userImage = document["userImage"] as? String ?? ""
                
//                getUserTeamInfo(userId: userId, cell: cell)
                
                if let url = URL(string:userImage ?? "") {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView?.image = nil
                }
            }
    }
}

extension ReactionVC :UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReactCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        cell.backgroundColor = .clear

        if let url = URL(string:imageUrls[indexPath.row]) {
            Nuke.loadImage(with: url, into: cell.reactImage!)
        } else {
            cell.reactImage?.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        stampUrls = imageUrls[indexPath.row]
        addReactionToFirestore(urlString: stampUrls ?? "")
        dismiss(animated: true)

    }
    
    private func addReactionToFirestore(urlString: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let documentId = randomString(length: 20)
                    let docData = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "userId": uid,
                        "documentId" : documentId,
                        "reaction": urlString,
                        "theMessage":message ?? "",
                        "admin": false,
                    ] as [String: Any]
        db.collection("users").document(userId ?? "").collection("Reaction").document().setData(docData)
        dismiss(animated: true, completion: nil)

    }
    
    
}


class ReactCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var reactImage: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

//         cellの枠の太さ
//        self.layer.borderWidth = 1.0
//         cellの枠の色
//        self.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        backgroundColor = .gray

        
//        if teamName == "red" {
//            self.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 0.9030126284)
//        } else  if teamName == "yellow" {
//            self.layer.borderColor = #colorLiteral(red: 1, green: 0.992557539, blue: 0.3090870815, alpha: 1)
//        } else  if teamName == "blue" {
//            self.layer.borderColor = #colorLiteral(red: 0.4093301235, green: 0.9249009683, blue: 1, alpha: 1)
//        } else if teamName == "purple" {
//            self.layer.borderColor = #colorLiteral(red: 0.8918020612, green: 0.7076364437, blue: 1, alpha: 1)
//        }
        // cellを丸くする
//        self.layer.cornerRadius = 2.0
    }
}
