//
//  FontCollectionVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/03/09.
//

import UIKit
import Nuke

class FontCollectionVC:UIViewController {
    
    
    let fontArray = [
        "Southpaw",
        "Bearandloupe-Bold",
        "BistroSketch",
        "Camden-Regular",
        "Daniel-Bold",
        "Debby",
        "DoodlePen",
        "GrutchShaded",
        "MyFont-Regular",
        "Julies",
        "KBCuriousSoul",
        "KeyTabMetal",
        "Lackey",
        "LoveYaLikeASister",
        "LovingYou",
        "LunaBar",
        "MadeWithB",
        "mami-candy",
        "Mayonaise",
        "MonikaItalic",
        "MoonFlower",
        "MTFCupcake",
        "Pappo'sBluesBandOfficialFont",
        "pastel",
        "Paulson",
        "REIS-Regular",
        "Sketchica",
        "SweetPineapple-Regular",
    ]
    
    
    @IBOutlet weak var fontCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       // ナビゲーションバーの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        let safeAreaHeight = UIScreen.main.bounds.size.height-statusBarHeight-navigationBarHeight
        
        
        
        
        
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: safeAreaHeight/5, height: safeAreaHeight/5)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.fontCollectionView.collectionViewLayout = flowLayout
//        // 背景色を設定
//        self.fontCollectionView?.backgroundColor = .clear
    }
}

extension FontCollectionVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fontArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! fontCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        
        cell.fontNameLabel.text = fontArray[indexPath.row]
        cell.fontLabel.font = UIFont(name:fontArray[indexPath.row], size:40)
        print(indexPath.row)
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.presentingViewController as! CollectionPostVC
        vc.fontString = fontArray[indexPath.row]
        vc.fontedLabel.font = UIFont(name:fontArray[indexPath.row], size:40)
        vc.fontedSecondLabel.font = UIFont(name:fontArray[indexPath.row], size:20)
        vc.graffitiFontName = fontArray[indexPath.row]
        
        self.dismiss(animated: true, completion: nil)

        print(fontArray[indexPath.row])
    }
    
    
}

class fontCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontNameLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

//         cellの枠の太さ
        self.layer.borderWidth = 1.0
//         cellの枠の色
        self.layer.borderColor = UIColor.white.cgColor

    }
}
