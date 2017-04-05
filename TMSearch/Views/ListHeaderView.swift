//
//  ListHeaderView.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 10..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class ListHeaderView: UICollectionReusableView {
    
    struct Metric {
        static let searchTextFieldTop = CGFloat(10)
        static let searchTextFieldLeft = CGFloat(10)
        static let searchTextFieldRight = CGFloat(10)
        static let searchTextFieldHeight = CGFloat(30)
        static let searchTextFieldBottom = CGFloat(10)
    }
    
    struct Font {
        static let searchTextField = UIFont.systemFont(ofSize: 13)
    }
    
    var searchTextFieldDidTap: ((String) -> ())?
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = " 검색어를 입력하세요(예:시선 특허)"
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.clearButtonMode = .whileEditing
        
        let searchButton = UIButton()
        searchButton.size = CGSize(width: 20, height: 20)
        searchButton.setImage(UIImage(named: "icon-search" ), for: .normal)
        
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)

        textfield.leftView = searchButton
        textfield.leftViewMode = .whileEditing
        
        textfield.font = Font.searchTextField
        textfield.delegate = self
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.bgcolorForCell
        self.addSubview(self.searchTextField)
//        self.addSubview(self.countLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.searchTextField.left = Metric.searchTextFieldLeft
        self.searchTextField.width = self.width - Metric.searchTextFieldLeft - Metric.searchTextFieldRight
        self.searchTextField.top = Metric.searchTextFieldTop
        self.searchTextField.height = Metric.searchTextFieldHeight
        //        countLabel.sizeToFit()
//        countLabel.centerX = self.width / 2
//        countLabel.centerY = self.height / 2
    }
    
    func searchButtonDidTap() {
        // 키워드 입력 구현
        if let text = self.searchTextField.text, text != "" {
            self.searchTextFieldDidTap?(text)
        }
    
        self.searchTextField.resignFirstResponder()
    }
    
}

extension ListHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.backgroundColor = UIColor.bgcolorForCell
        self.layer.borderWidth = 0.0
        self.searchButtonDidTap()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.backgroundColor = UIColor.rgb(220, 220, 220)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.bgcolorForCell.cgColor
    }
    
    
}








