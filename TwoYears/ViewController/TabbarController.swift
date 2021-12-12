//
//  TabbarController.swift
//  TwoYears
//  Created by 平田翔大 on 2021/03/16.
//

import UIKit


//TabBar
class TabbarController: UITabBarController{
    
    var color : String?
    
    
    // iconを決めてない人は画面遷移
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let iconchoose = UserDefaults.standard.bool(forKey: "userIcon")
        
        if iconchoose == true {

            
        } else {
            let storyboard = UIStoryboard.init(name: "brands", bundle: nil)
            let brands = storyboard.instantiateViewController(withIdentifier: "brandsViewController")
            brands.modalPresentationStyle = .fullScreen
            self.present(brands, animated: true, completion: nil)
            
        }
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
