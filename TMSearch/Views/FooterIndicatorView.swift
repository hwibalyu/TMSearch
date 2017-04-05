//
//  FooterIndicatorView.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 4. 4..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class FooterIndicatorView: UICollectionReusableView {
    
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.activityIndicator.frame = .zero
        self.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.activityIndicator.centerX = self.centerX
        self.activityIndicator.centerY = self.bounds.height / 2
    }
    
}
