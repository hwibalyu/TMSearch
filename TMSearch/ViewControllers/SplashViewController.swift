//
//  SplashViewController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 11..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit
import Alamofire

class SplashViewController: UIViewController {
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.indicator)
        self.indicator.frame = self.view.bounds
        self.indicator.startAnimating()
        
       
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let singleton = AppDelegate.singleton {
            singleton.presentMainController()
        }
    }
    
}
