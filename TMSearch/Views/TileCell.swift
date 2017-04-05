//
//  TileCell.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 29..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class TileCell: UICollectionViewCell {
    
    let drawingImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        self.contentView.addSubview(self.drawingImageView)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.drawingImageView.contentMode = .scaleAspectFit
        self.drawingImageView.backgroundColor = .white
        self.drawingImageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tradeMark: Trademark) {
        drawingImageView.setImage(with: tradeMark.drawingUrl)
    }
    
    
//    class func size(width: CGFloat) -> CGFloat {
//        
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.drawingImageView.frame = self.contentView.bounds
//    }
//    
    
    
    
}
