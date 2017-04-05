//
//  MainTabbarController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 29..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.viewControllers = [
            UINavigationController(rootViewController: ListViewController()),
            SettingViewController(),
            


        ]
        
        
    }
    
    
}
