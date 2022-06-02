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
        let iconchoose = UserDefaults.standard.integer(forKey: "EULA")
        
        if iconchoose == 1 {
            
        } else {
            let storyboard = UIStoryboard.init(name: "EULA", bundle: nil)
            let brands = storyboard.instantiateViewController(withIdentifier: "EULAViewController")
            brands.modalPresentationStyle = .fullScreen
            self.present(brands, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
    }
}
