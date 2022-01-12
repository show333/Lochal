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
//        self.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        
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
//        coverView.backgroundColor = .clear
//        coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 0.1秒後に実行したい処理（あとで変えるこれは良くない)
            self.getUserTeamInfo(userId: self.outMemo?.userId ?? "")
        }
        
    }
    
    
    
    @IBOutlet weak var backBack: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var coverView: UIView!
    
    
    @IBOutlet weak var textMaskLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    @IBOutlet weak var flagButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        
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
        
        print("awakenoyatu")
        
        
        self.teamCollectionView.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//             0.1秒後に実行したい処理（あとで変えるこれは良くない)
            self.getUserTeamInfo(userId: self.outMemo?.userId ?? "unKnwon")
        }
    }
    
    
    func getUserTeamInfo(userId:String){
        db.collection("users").document(userId).collection("belong_Team").document("teamId").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")

                let teamIdArray = document.data()!["teamId"] as! Array<String>
                print(teamIdArray)
                print(teamIdArray[0])

                print("カカかっかっっっカカかかかあいあいいあいいえいえいえおをを")
                
                self.teamInfo.removeAll()
                
                    teamIdArray.forEach{
                        self.getTeamInfo(teamId: $0)
                    }
                

            } else {
                print("Document does not exist")
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
//                self.teamCollectionView.alpha = 1

                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = outMemo?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
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
        
        //        getTeamInfo(teamId: outMemo?.userId ?? "")
        return cell
    }
    
}




