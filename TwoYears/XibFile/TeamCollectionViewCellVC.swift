//
//  TeamCollectionViewCellVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/26.
//

import UIKit

class TeamCollectionViewCellVC:UICollectionViewCell {
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
