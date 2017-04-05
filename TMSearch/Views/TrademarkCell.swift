//
//  TrademarkCell.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 10..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit
import ManualLayout
import SnapKit

class TrademarkCell: UICollectionViewCell {
    
    struct Metric {
        static let containerViewTop = CGFloat(4)
        static let containerViewLeft = CGFloat(4)
        static let containerViewRight = CGFloat(4)
        static let containerViewBottom = CGFloat(4)
        
        static let drawingViewTop = CGFloat(10)
        static let drawingViewLeft = CGFloat(10)
        static let drawingViewWidth = CGFloat(70)
        static let drawingViewHeight = CGFloat(70)
        static let drawingViewBottom = CGFloat(10)
        
        static let drawingRightBorderWidth = CGFloat(0.5)
        
        static let applicationNumberTop = CGFloat(10)
        static let applicationNumberLeft = CGFloat(20)
        
        static let titleLabelTop = CGFloat(10)
        static let titleLabelLeft = CGFloat(20)
        static let titleLabelRight = CGFloat(10)
        
        static let productLabelTop = CGFloat(10)
        static let productLabelRight = CGFloat(10)
        
        static let statusLabelBottom = CGFloat(4)
        static let statusLabelTop = CGFloat(40)
        
        static let statusImageViewRight = CGFloat(18)
        static let statusImageViewSize = CGFloat(25)
    }
    
    struct Font {
        
        static let applicationNumberLabel = UIFont.boldSystemFont(ofSize: 14)
        static let titleLabel = UIFont.systemFont(ofSize: 13)
        static let productLabel = UIFont.systemFont(ofSize: 13)
        static let statusLabel = UIFont.boldSystemFont(ofSize: 12)
    }
    
    fileprivate lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 0.5
        return container
    }()
    
    fileprivate let drawingView = UIImageView()
    fileprivate let drawingRightBorder = UIView()
    fileprivate let applicationNumberLabel = UILabel()
    fileprivate let titleLabel = UILabel()
    fileprivate let productLabel = UILabel()
    fileprivate let applicantLabel = UILabel()
    fileprivate let statusLabel = UILabel()
    fileprivate let statusImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.bgcolorForCell
        self.contentView.addSubview(self.containerView)

        
        self.drawingRightBorder.backgroundColor = .lightGray
        
        self.applicationNumberLabel.font = Font.applicationNumberLabel
        self.titleLabel.font = Font.titleLabel
        
        self.productLabel.font = Font.productLabel
        self.statusLabel.font = Font.statusLabel
        
        self.drawingView.layer.cornerRadius = Metric.statusImageViewSize / 5
        self.drawingView.contentMode = .scaleAspectFit
        
        self.containerView.addSubview(self.drawingView)
        self.containerView.addSubview(self.drawingRightBorder)
        self.containerView.addSubview(self.applicationNumberLabel)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.statusLabel)
        self.containerView.addSubview(self.statusImageView)
        self.containerView.addSubview(self.productLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with trademark: Trademark) {
        self.drawingView.image = nil
        self.drawingView.setImage(with: trademark.drawingUrl)
        
        if trademark.status.contains("등록") {
            statusImageView.image = UIImage(named: "icon-registered")
        } else {
            statusImageView.image = UIImage(named: "icon-notRegistered")
        }
        
        self.applicationNumberLabel.text = "출원 제\(trademark.appNumber)호"
        self.statusLabel.text = trademark.status
        self.titleLabel.text = trademark.title
        
        // 류구분 불필요한 숫자 제거
        let productCode = trademark.productCode.components(separatedBy: " ")
            .map {
                String(Int($0)!) + "류"
            }
            .joined(separator: ", ")
        self.productLabel.text = productCode
        
        self.setNeedsLayout()
    }
    
    static func sizeForTrademarkCell() -> CGFloat {
        
        var height = Metric.containerViewTop + Metric.containerViewBottom
        height += Metric.drawingViewHeight + Metric.drawingViewTop + Metric.drawingViewBottom
        return height
    }
        
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = CGRect(x: Metric.containerViewLeft, y: Metric.containerViewTop, width: self.contentView.width - Metric.containerViewLeft - Metric.containerViewRight, height: self.contentView.height - Metric.containerViewTop - Metric.containerViewBottom)


        self.drawingView.top = Metric.drawingViewTop
        self.drawingView.left = Metric.drawingViewLeft
        self.drawingView.width = Metric.drawingViewWidth
        self.drawingView.height = Metric.drawingViewHeight
        
        self.applicationNumberLabel.sizeToFit()
        self.applicationNumberLabel.top = Metric.applicationNumberTop
        self.applicationNumberLabel.left = self.drawingView.right + Metric.applicationNumberLeft
        
        self.drawingRightBorder.left = (self.drawingView.right + self.applicationNumberLabel.left) / 2
        self.drawingRightBorder.top = 3.0
        self.drawingRightBorder.width = Metric.drawingRightBorderWidth
        self.drawingRightBorder.height = self.containerView.height - 6
        
        self.statusImageView.top = Metric.statusLabelTop
        self.statusImageView.width = Metric.statusImageViewSize
        self.statusImageView.height = Metric.statusImageViewSize
        self.statusImageView.right = self.containerView.width - Metric.statusImageViewRight
        
        self.statusLabel.sizeToFit()
        self.statusLabel.bottom = self.statusImageView.top - Metric.statusLabelBottom
        self.statusLabel.centerX = self.statusImageView.centerX
        
        self.titleLabel.sizeToFit()
        self.titleLabel.top = self.applicationNumberLabel.bottom + Metric.titleLabelTop
        self.titleLabel.left = self.drawingView.right + Metric.titleLabelLeft
        self.titleLabel.width = min(self.titleLabel.width, self.containerView.width - self.titleLabel.left - Metric.titleLabelRight - Metric.statusImageViewRight - Metric.statusImageViewSize)
        
        self.productLabel.sizeToFit()
        self.productLabel.top = self.titleLabel.bottom + Metric.productLabelTop
        self.productLabel.left = self.titleLabel.left
        self.productLabel.width = min(self.productLabel.width, self.containerView.width - self.productLabel.left - Metric.productLabelRight - Metric.statusImageViewRight - Metric.statusImageViewSize)
    }
}

extension UIColor {
    
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor{
        return UIColor(red: r / 256, green: g / 256, blue: b / 256, alpha: 1.0)
    }
    static let bgcolorForCell = rgb(240, 240, 245) // 테마컬러
}




