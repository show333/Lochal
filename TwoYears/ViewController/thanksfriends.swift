//
//  thanksfriends.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/19.
//

import UIKit

class thanksfriends: UIViewController {
    var friendbool : Bool?
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var unlimitedLabel: UILabel!
    @IBOutlet weak var museigenLabel: UILabel!
    
    @IBOutlet weak var friendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(friendbool!)
        detailLabel.text = "このサービスは\n・全ての投稿が5日間で削除されます\n・招待IDが他人に公開されることはありません\n・右下の「新規投稿」ボタンで新たな投稿をすることができます\n・左上の「招待」ボタンで招待をすることが可能です\n・チャットルーム内では自作自演を防ぐため、そのルーム内限定のIDが発行され識別に使われます\n・同じチーム色の投稿のみコメントをすることができます\n・チャットルーム内の全てのコメントのいいねを合計した値がRANKINGに反映されます"
        if friendbool == false {
            thanksLabel.text = "Thank You!"
            unlimitedLabel.text = ""
            museigenLabel.text = ""
            friendsLabel.text = ""
        } else {
            friendsLabel.text = "このアカウントは\n一般アカウントと異なり、招待枠が無制限なのでたくさん招待してくれると嬉しいです！\n(一般アカウントは2週間に1度,1人分の招待をすることが可能となっています.)\nそれでは!"
        }
        
    }
}
