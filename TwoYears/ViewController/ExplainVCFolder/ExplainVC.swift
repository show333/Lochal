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
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.001.png?alt=media&token=b7f7eb75-70ca-46a5-b3c2-c4304e098d9b",//0
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.002.png?alt=media&token=cc13ed76-b4a8-42ce-989f-a613ea710108",//1
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.003.png?alt=media&token=424fe895-ef5c-4392-9684-ddae524a4a66",//2
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.004.png?alt=media&token=9cc94c7c-e664-477f-b1cb-0d8246bb8e5c",//3
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.005.png?alt=media&token=7e0dbe7a-5f0a-4f94-95a6-1d0a6ee2872d",//4
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.006.png?alt=media&token=6dfeee64-14a6-4cfd-b443-09851d85a546",//5
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.007.png?alt=media&token=bc8186e9-78ce-4c13-b513-04de6d292d37",//6
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.008.png?alt=media&token=01e4edf4-02f9-4a05-80e4-f76ffda93019",//7
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.009.png?alt=media&token=8088d622-e1f2-4a58-b72d-db61d20f1f4a",//8
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.010.png?alt=media&token=bcf345e7-f247-419c-8401-1cb1e2c714d2",//9
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FchainImagesExplain.011.png?alt=media&token=9d9973a6-1df0-4368-b691-9c6363e979b9",//10
    ]
    
    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet weak var explainSecondView: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func rightTappedButton(_ sender: Any) {
        if pageCount < 10 {
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
