//
//  MyTabBarController.swift
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 10/08/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.gray
        
        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                item.image = image.withRenderingMode(.alwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
