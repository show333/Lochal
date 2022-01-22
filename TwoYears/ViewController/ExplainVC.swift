//
//  ExplainVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/22.
//



import UIKit
import Nuke

class ExplainVC:UIViewController{
    
    var pageCount: Int = 0
    
    let imageArray = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.001.png?alt=media&token=623efe75-23b4-489e-862b-6f3c43838f0c",//0
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.002.png?alt=media&token=97a4d0ee-840b-491f-bdb9-4cad10b2af6e",//1
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.003.png?alt=media&token=f9fa88d7-83cb-49d7-b984-c882ab7a94c0",//2
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.004.png?alt=media&token=94358243-0824-4898-983a-654b81566367",//3
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.005.png?alt=media&token=b410eb52-8896-4fbf-b601-2ecb0312241b",//4
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.006.png?alt=media&token=84891048-a15a-4851-9f0a-af4a4c8293a7",//5
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.007.png?alt=media&token=88f6ab83-833a-4bb4-8cee-cf4ae561908b",//6
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.008.png?alt=media&token=2d613535-1feb-489d-bd2e-8da2787ca042",//7
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.009.png?alt=media&token=77e262f5-cd2e-47a2-86be-3db3794863ce",//8
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.010.png?alt=media&token=2ab47984-355b-4159-9176-7829d73cd968",//9
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImages.011.png?alt=media&token=b6539d56-6fff-4d9f-9b7e-53ab16c3e8d4"//10
    ]
    
    @IBOutlet weak var explainImageView: UIImageView!
    
    @IBOutlet weak var explainSecondView: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func rightTappedButton(_ sender: Any) {
        if pageCount < 10 {
            pageCount += 1
        } else if pageCount == 10 {
            print("s")
        }
        
        backLabel.alpha = 1
        print(pageCount)
        
        if pageCount % 2 == 1 {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        } else {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        }
        
        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        
        if pageCount == 10 {
            if let url = URL(string:imageArray[pageCount-1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        } else {
            if let url = URL(string:imageArray[pageCount+1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        }
    }
    @IBOutlet weak var leftButton: UIButton!
    
    @IBAction func leftTappedButton(_ sender: Any) {
        if pageCount > 0 {
            pageCount -= 1
        }

        if pageCount % 2 == 1 {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        } else {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        }
        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        
        
        if pageCount == 0 {
            backLabel.alpha = 0
            if let url = URL(string:imageArray[pageCount+1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        } else {

            if let url = URL(string:imageArray[pageCount-1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        }
        
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        explainSecondView.alpha = 0
        
        backLabel.alpha = 0
        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        
        if let url = URL(string:imageArray[pageCount+1]) {
            Nuke.loadImage(with: url, into: explainSecondView)
        } else {
            explainSecondView?.image = nil
        }
        
        
    }
}
