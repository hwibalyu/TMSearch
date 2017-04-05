//
//  AppDelegate.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 9..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class var singleton: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        
        UITabBar.appearance().tintColor = .gray
        
        self.window = window

        return true
    }
    
    func presentMainController() {

        let mainTabBarController = MainTabbarController()
        
//        let listViewController = ListViewController()
//        let navigationController = UINavigationController(rootViewController: listViewController)

        self.window?.rootViewController = mainTabBarController
    }
}









