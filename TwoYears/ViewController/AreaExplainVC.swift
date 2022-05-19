//
//  AreaExplainVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/05/11.
//

import UIKit
import Nuke
class AreaExplainVC:UIViewController {
    
    var areaName:String?
    
    @IBOutlet weak var areaImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        switch areaName {
        case "tokyo":
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FtokyoArea.001.png?alt=media&token=c3dc08d4-b738-458a-9cc5-608e6ad29505") {
                Nuke.loadImage(with: url, into: areaImageView)
            } else {
                areaImageView?.image = nil
            }
        case "saitama":

            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FsaitamaArea.001.png?alt=media&token=3b768e53-08c9-4a33-aa66-66e78a3e5d52") {
                Nuke.loadImage(with: url, into: areaImageView)
            } else {
                areaImageView?.image = nil
            }
        case"chiba":

            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FchibaArea.001.png?alt=media&token=f08bee12-8170-49d9-b1b4-f76034c24a76") {
                Nuke.loadImage(with: url, into: areaImageView)
            } else {
                areaImageView?.image = nil
            }
        case "kanagawa":

            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FkanagawaArea.001.png?alt=media&token=17eaaf2c-6771-4a59-9a95-5efc318a2188") {
                Nuke.loadImage(with: url, into: areaImageView)
            } else {
                areaImageView?.image = nil
            }
        default:
            print("あしおえjf")
        }
    }
}
