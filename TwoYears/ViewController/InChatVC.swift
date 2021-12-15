//
//  InChat.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/08.
//

import UIKit
import Nuke

class InChat:  UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{
    
    var imageUrls = [String]()
    

    @IBOutlet weak var teamCollectionView: UICollectionView!

    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        
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
        
        imageUrls =  ["https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA1osusume.png?alt=media&token=0da0367d-af96-4f12-b660-52388bf955d7",//A1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA2itiosi.png?alt=media&token=2883e323-af38-4678-9e20-a0cc85fa980f",//A2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA3maru.png?alt=media&token=5e92bbeb-7ca3-461a-964d-f1165259065a",//A3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA4batu.png?alt=media&token=39d0493e-9362-404d-a628-de514f9a417c",//A4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA5extu.png?alt=media&token=64e2ff4e-b14d-4f11-9ab3-8e61350388f5",//A5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA6pinn.png?alt=media&token=d2f2fb68-522b-4c55-b85d-60ee56b25737",//A6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA7atafuta.png?alt=media&token=3409716e-a480-44de-925d-d44ee0bd1ab9",//A7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA8u-nn.png?alt=media&token=7e996956-c7e8-41fb-8a3c-a2f095ad78c0",//A8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA9sikusiku.png?alt=media&token=4d4c811a-dfba-4024-bf32-718670af68ae",//A9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA10punpun.png?alt=media&token=acbef5d9-fb46-4575-841c-800e5fc89344",//A10
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA11gusya.png?alt=media&token=fc744cee-7365-441c-81d4-8f877076ec13",//A11
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA12iine.png?alt=media&token=f344a8bc-368c-4ce9-9f3e-9980a0705266",//A12
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB1gimonn.png?alt=media&token=8edd18a4-d8c1-4aa3-a147-90a92e73c84e",//B1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB2hyokkori.png?alt=media&token=13eb5fa7-d790-451b-a7a2-43c1b1b532f8",//B2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB3korede.png?alt=media&token=70a31f21-728b-4339-93f1-7984ac7f635a",//B3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB4ha-to.png?alt=media&token=22cb5c5e-d4f1-4a46-be32-5c708f669473",//B4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB5bi-ru.png?alt=media&token=54044c91-32de-4365-851e-823c46c84d05",//B5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB6runnrunn.png?alt=media&token=3f52c1c9-16fd-493f-b5f8-3e2e5cbab034",//B6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB7dogeza.png?alt=media&token=99799883-d9e9-4758-8a7c-3dc7844115b5",//B7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB8nemasu.png?alt=media&token=ecdd59e8-7445-4a69-81e1-4a9efc7735e8",//B8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB9genkai.png?alt=media&token=047a11fe-abe4-4c9b-95dd-fca81e5c089b",//B9
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  imageUrls.count// 表示するセルの数
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let horizontalSpace : CGFloat = 50
            let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
            return CGSize(width: cellSize, height: cellSize)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! teamCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        
        if let url = URL(string:imageUrls[indexPath.row]) {
            Nuke.loadImage(with: url, into: cell.teamCollectionImage!)
        } else {
            cell.teamCollectionImage?.image = nil
        }
        
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
        print(indexPath.row)
        print("怒る")
    }

}

class teamCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var teamCollectionImage: UIImageView!
    
    @IBOutlet weak var teamCollectionView: teamCollectionViewCell!
    
    
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

