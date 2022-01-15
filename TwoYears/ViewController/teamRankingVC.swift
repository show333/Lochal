//
//  teamRankingVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/08.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Nuke

class teamRankingVC:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var teamInfo : [Team] = []
        
    let db = Firestore.firestore()

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toriaLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamDocuments()
//        fetchFireStore()
   
        
        
        let widthImage = UIScreen.main.bounds.size.width/3.0
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        let safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        
        
        topViewConstraint.constant = safeArea/7*3
        collectionViewConstraint.constant = safeArea/7*3
        centerConstraint.constant = widthImage
        
//        backViewConstraint.constant = UIScreen.main.bounds.size.height - tabbarheight - statusBarHeight
//
//
//        backUnderConstraint.constant = safeArea/2
//        collectionViewConstraint.constant = safeArea/3
        
        
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: safeArea/14*3, height: safeArea/14*3)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        teamCollectionView.reloadData()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.55)
        
        



    }
    
    func getTeamDocuments() {
        db.collection("Team").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {

                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print("ドキュメント",document)
                    print("querySnapshot!.documents",querySnapshot!.documents)
                    print("querysnapshots!",querySnapshot as Any)
                    print(document.data()["TotalGood"]as! Int)
                    
                    let teamsDic = Team(dic: document.data())
                    
                    teamInfo.append(teamsDic)
                    self.teamInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    
                }
                teamCollectionView.reloadData()
                toriaLabel.text = String(teamInfo[0].totalGood)
                
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! rankingCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        let teamRankIndex = indexPath.row + 3
        
        
        cell.teamNameLabel.text = teamInfo[teamRankIndex].teamName
        
        if let url = URL(string:teamInfo[indexPath.row].teamImage) {
            Nuke.loadImage(with: url, into: cell.teamLogoImage!)
        } else {
            cell.teamLogoImage?.image = nil
        }
        return cell
    }
    

}

class rankingCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var teamLogoImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
        self.layer.borderWidth = 1.0
        // cellの枠の色
        self.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
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
