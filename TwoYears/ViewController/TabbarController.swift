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
        let teamName = UserDefaults.standard.string(forKey: "color")
        
        if teamName == "red" {
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
            UITabBar.appearance().tintColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            let tab_layer: CALayer = self.tabBar.layer
            tab_layer.shadowColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 1)
            tab_layer.shadowOffset = CGSize(width: 0.0, height: -9.0)
            tab_layer.shadowRadius = 5.0
            tab_layer.shadowOpacity = 0.6
        } else if teamName == "blue" {
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
            UITabBar.appearance().tintColor = #colorLiteral(red: 0.4093301235, green: 0.9249009683, blue: 1, alpha: 1)
            let tab_layer: CALayer = self.tabBar.layer
            tab_layer.shadowColor = #colorLiteral(red: 0.4093301235, green: 0.9249009683, blue: 1, alpha: 1)
            tab_layer.shadowOffset = CGSize(width: 0.0, height: -9.0)
            tab_layer.shadowRadius = 5.0
            tab_layer.shadowOpacity = 0.7
        } else if teamName == "yellow" {
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.03137254902, green: 0.01176470588, blue: 0, alpha: 1)
            UITabBar.appearance().tintColor = #colorLiteral(red: 0.9869695684, green: 0.76390437, blue: 0.3090870815, alpha: 1)
            let tab_layer: CALayer = self.tabBar.layer
            tab_layer.shadowColor = #colorLiteral(red: 0.9869695684, green: 0.76390437, blue: 0.3090870815, alpha: 1)
            tab_layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
            tab_layer.shadowRadius = 5.0
            tab_layer.shadowOpacity = 0.7
        } else if teamName == "purple" {
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
            UITabBar.appearance().tintColor = #colorLiteral(red: 0.7549457672, green: 0.5, blue: 1, alpha: 1)
            let tab_layer: CALayer = self.tabBar.layer
            tab_layer.shadowColor = #colorLiteral(red: 0.7549457672, green: 0.5, blue: 1, alpha: 1)
            tab_layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
            tab_layer.shadowRadius = 5.0
            tab_layer.shadowOpacity = 0.7
        }
    }
}
