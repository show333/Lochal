//
//  AreaRankingVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/04/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke


class AreaRankingVC:UIViewController {
    
    var newPostAreaRank : [Area] = []
    var anonymousAreaRank : [Area] = []
    var selfArea : Area?
    
    let usersAreaEn:String? = UserDefaults.standard.object(forKey: "areaNameEn") as? String
    let usersAreaJa:String? = UserDefaults.standard.object(forKey: "areaNameJa") as? String
    let db = Firestore.firestore()

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var areaNameLabel: UILabel!
    
    @IBOutlet weak var rankCountLabel: UILabel!
    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var anonymousExplainLabel: UILabel!
    @IBOutlet weak var backViewWidthConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        areaNameLabel.text = usersAreaEn
        rankCountLabel.text = ""
        explainLabel.text = "通常投稿とラクがき投稿の合計"
        anonymousExplainLabel.text = "匿名での順位: 21"
        
        let width = self.view.bounds.width
        backViewWidthConstraint.constant = width/2
        
        backView.clipsToBounds = true
        backView.layer.cornerRadius = width/16
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FbackGround%2Fnihonchizu-color-deformed.png?alt=media&token=138e5ea9-0d59-4703-9131-1941ff6e7069") {
            Nuke.loadImage(with: url, into: backImageView)
        } else {
            backImageView?.image = nil
        }
        areaRankStatus()
    }
    
    func areaRankStatus() {
        
        
        db.collection("Area").document("japan").collection("Prefectures").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dic = document.data()
                    let newPostCount = document.data()["newPostCount"] as? Int ?? 0
                    let graffitiCount = document.data()["graffitiCount"] as? Int ?? 0
                    
                    let areaNameEn = document.data()["areaNameEn"] as? String ?? ""
                    
            
                    
                    let addPostCount = newPostCount + graffitiCount
                    let areaDic = Area(dic: dic,addPostCount: addPostCount)
                    
                    if areaNameEn == self.usersAreaEn {
                        self.selfArea = areaDic
                    }
                    
                    self.newPostAreaRank.append(areaDic)
                    self.anonymousAreaRank.append(areaDic)

                    
                    self.newPostAreaRank.sort { (m1, m2) -> Bool in
                        let m1addPostCount = m1.addPostCount
                        let m2addPostCount = m2.addPostCount
                        return m1addPostCount > m2addPostCount
                    }
                    self.anonymousAreaRank.sort { (m1, m2) -> Bool in
                        let m1anonymousPostCount = m1.anonymousPostCount
                        let m2anonymousPostCount = m2.anonymousPostCount
                        return m1anonymousPostCount > m2anonymousPostCount
                    }
                }
                
                let newPostAreaRankIndex = Int(self.newPostAreaRank.firstIndex(of: self.selfArea!) ?? 46) + 1
                let anonymousPostRankIndex = Int(self.anonymousAreaRank.firstIndex(of: self.selfArea!) ?? 46) + 1
                print("drrrd",newPostAreaRankIndex as Array<Area>.Index? ?? 0)
                
                self.rankCountLabel.text = String(newPostAreaRankIndex as Array<Area>.Index? ?? 0)
                self.anonymousExplainLabel.text = String(anonymousPostRankIndex as Array<Area>.Index? ?? 0)
            }
        }
    }
}
