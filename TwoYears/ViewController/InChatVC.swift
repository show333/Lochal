//
//  InChat.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class InChat:  UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    var imageUrls = [String]()
    var teamInfo : [Team] = []
    var reaction : [Reaction] = []
    let db = Firestore.firestore()
    private let cellId = "cellId"

    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reactionTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserTeamInfo()
        fetchReaction()
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
        reactionTableView.dataSource = self
        reactionTableView.delegate = self
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        let safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        
        collectionViewConstraint.constant = safeArea/4
        
       
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: safeArea/4, height: safeArea/4)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .blue
        
        
        
        view.backgroundColor = #colorLiteral(red: 0.984652102, green: 0.5573557019, blue: 0, alpha: 1)
        
//        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//        teamCollectionView.collectionViewLayout = layout
        

    }
    func fetchReaction() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("Reaction").addSnapshotListener{ [self] ( snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let reactionDic = Reaction(dic: dic)
                    
//                    let date: Date = rarabai.zikokudosei.dateValue()
//                    let momentType = moment(date)
                    
//                    if blockList[rarabai.userId] == true {
//
//                    } else {
//                        if momentType >= moment() - 14.days {
//                            if rarabai.admin == true {
//                            }
//                            self.animals.append(rarabai)
//                        }
//                    }
                    
                    self.reaction.append(reactionDic)
                    
//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
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
    
    func fetchUserTeamInfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("belong_Team").document("teamId")
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
                let teamIdArray = data["teamId"] as! Array<String>
                print(teamIdArray)
                print(teamIdArray[0])
                
                teamIdArray.forEach{
                    self.getTeamInfo(teamId: $0)

                }
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
                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  teamInfo.count// 表示するセルの数
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let horizontalSpace : CGFloat = 50
            let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
            return CGSize(width: cellSize, height: cellSize)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! teamCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        
        var imageString = String()
        imageString = teamInfo[indexPath.row].teamImage
                
        print("どどん",teamInfo[indexPath.row])
        
        if let url = URL(string:imageString) {
            Nuke.loadImage(with: url, into: cell.teamCollectionImage!)
        } else {
            cell.teamCollectionImage?.image = nil
        }
        print("aa",imageString)
   
        
        print(indexPath.row)
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
//            self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            self.imageView.alpha = 1
//
//
//        }) { bool in
//        // ②アイコンを大きくする
//            UIView.animate(withDuration: 0.1, delay: 0, animations: {
//                self.imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
//
//        }) { bool in
//            // ②アイコンを大きくする
//            UIView.animate(withDuration: 0.1, delay: 0, animations: {
//                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
//
//            })
//            }
//        }
//
//        laLabel.alpha = 1
//        cancelButton.alpha = 0.7
//
//        stampUrls = imageUrls[indexPath.row]
//
//        if let url = URL(string:imageUrls[indexPath.row]) {
//            Nuke.loadImage(with: url, into: imageView)
//        }
        let teamRoomId = teamInfo[indexPath.row].teamId
        UserDefaults.standard.set(teamRoomId, forKey: "teamRoomId")
        
        let storyboard = UIStoryboard.init(name: "InChatRoom", bundle: nil)
        let InChatRoomVC = storyboard.instantiateViewController(withIdentifier: "InChatRoomVC") as! InChatRoomVC
        
        InChatRoomVC.teamRoomDic = teamInfo[indexPath.row]
        print(teamInfo[indexPath.row].teamId)

        navigationController?.pushViewController(InChatRoomVC, animated: true)

        print(indexPath.row)
        print("怒る")
    }

}

class teamCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var teamCollectionImage: UIImageView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
        self.layer.borderWidth = 1.0
        // cellの枠の色
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundColor = .gray
        
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

extension InChat:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reactionTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InChatTableViewCell
        cell.messageLabel.text = reaction[indexPath.row].userId
        return cell
    }
    
    
}

class InChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
