//
//  DetailContentCell.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 25..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

class DetailContentCell: UITableViewCell {
    
    struct Metric {
        static let titleLabelTop = CGFloat(20)
        static let titleLabelBottom = CGFloat(20)
        static let titleLabelLeft = CGFloat(20)
        
//        static let contentLabelTop = CGFloat(20)
        static let contentLabelLeft = CGFloat(20)
//        static let contentLabelBottom = CGFloat(20)
        static let contentLabelRight = CGFloat(40)

    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 12)
        static let contentLabel = UIFont.boldSystemFont(ofSize: 16)
        
    }
    
    let containerView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = Font.titleLabel
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.font = Font.contentLabel
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.containerView.frame = self.contentView.bounds

        self.backgroundView = self.containerView
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func height() -> CGFloat {
        var height: CGFloat = 0
        
        height += Metric.titleLabelTop
        height += Font.titleLabel.lineHeight
        height += Metric.titleLabelBottom
        
        return ceil(height)
    }
    
    func configure(title: String, content: String) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.sizeToFit()
        self.titleLabel.top = Metric.titleLabelTop
        self.titleLabel.left = Metric.titleLabelLeft
        
        self.contentLabel.sizeToFit()
        self.contentLabel.width = min(self.contentLabel.width, self.contentView.width - self.titleLabel.right - Metric.contentLabelRight - Metric.contentLabelLeft)
        
        self.contentLabel.centerY = self.titleLabel.centerY

        self.contentLabel.right = self.contentView.width - Metric.contentLabelRight
        
    }
}















