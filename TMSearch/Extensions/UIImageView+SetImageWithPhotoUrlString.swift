//
//  UIImageView+SetImageWithPhotoUrlString.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 10..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with photoURLString: String?) {
        if let photoURLString = photoURLString {
            let url = URL(string: photoURLString)
            self.kf.setImage(with: url)
        } else {
            self.kf.setImage(with: nil)
        }
        
        
    }
    
    
}
