//
//  ExplainVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/22.
//



import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class ExplainVC:UIViewController{
    
    var pageCount: Int = 0
    
    let db = Firestore.firestore()
    
    let imageArray = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FnewExplain3.001.png?alt=media&token=e974e6a0-fcd6-4748-80a2-6aa1f4270f8b",//0
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FnewExplain3.002.png?alt=media&token=e68bccab-ebcc-4613-ac81-d0c1f0a77a16",//1
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FnewExplain3.003.png?alt=media&token=023962d9-0520-4c49-b090-8cc0eac0d3e7",//2
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FnewExplain3.004.png?alt=media&token=3db62849-daa1-4638-95a6-b6e27f424737",//3
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FnewExplain3.005.png?alt=media&token=c5c0cd30-cb7b-48ea-a9f3-8d05967d53df",//4

    ]
    
    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet weak var explainSecondView: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func rightTappedButton(_ sender: Any) {
        if pageCount < 4 {
            pageCount += 1
        } else {
            
            let storyboard = UIStoryboard.init(name: "FirstSetName", bundle: nil)
            let FirstSetNameVC = storyboard.instantiateViewController(withIdentifier: "FirstSetNameVC") as! FirstSetNameVC
            navigationController?.pushViewController(FirstSetNameVC, animated: true)
            
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

        if pageCount == 4 {
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
    

    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let iconchoose = UserDefaults.standard.integer(forKey: "EULA")
        if iconchoose == 1 {
        } else {
            let storyboard = UIStoryboard.init(name: "EULA", bundle: nil)
            let brands = storyboard.instantiateViewController(withIdentifier: "EULAViewController")
            brands.modalPresentationStyle = .fullScreen
            self.present(brands, animated: true, completion: nil)
        }
    }
    
}
