//
//  SearchViewController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 11..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    //MARK: Properties
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요"
        return textField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.searchTextField)
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchTextField.width = 150
        self.searchTextField.height = 50
        self.searchTextField.center = self.view.center

    }
    
    
    
}
