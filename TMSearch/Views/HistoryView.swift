//
//  HistoryView.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 11..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit
import SnapKit

class HistoryView: UIView {
    
    let cellID = "cellID"
    var searchHistory: [[String:String]]? {
        get {
            let data = loadData()?.reversed()
            return data?.enumerated().flatMap{
                if $0.offset < 5 {
                    return $0.element
                } else {
                    return nil
                }
            }
        }
    }
    
    var historyViewCellDidTap: ((String?) -> ())?
    
    let historyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색기록"
        label.backgroundColor = UIColor.lightGray
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }()
    
    
    lazy var historyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        self.historyCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: cellID)
        self.addSubview(self.historyTitleLabel)
        self.addSubview(self.historyCollectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() -> [[String:String]]? {
        let defaults = UserDefaults.standard
        layoutIfNeeded()
        return defaults.array(forKey: "history") as? [[String:String]]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.historyTitleLabel.top = 0
        self.historyTitleLabel.left = 0
        self.historyTitleLabel.height = 20
        self.historyTitleLabel.width = self.width
    
        self.historyTitleLabel.textAlignment = .center
        print(self.historyTitleLabel.width, self.width)
        
        self.historyCollectionView.top = 20
        self.historyCollectionView.left = 0
        self.historyCollectionView.height = self.height - 20
        self.historyCollectionView.width = self.width        
    }
    
    
}
extension HistoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? HistoryCell
        
        if let historyList = self.searchHistory {
            let history = historyList[indexPath.item]
            
            cell!.configure(searchText: history["searchString"] ?? "", createdAt: "\(history["year"]!).\(history["month"]!).\(history["day"]!)")
        }
        return cell!
    }
}

extension HistoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(self.searchHistory?.count ?? 0, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight: CGFloat
        
        if let searchString = self.searchHistory?[indexPath.item]["searchString"] {
            cellHeight = HistoryCell.size(with: self.width, of: searchString).height
        } else {
            cellHeight = 0
        }
        
        return CGSize(width: collectionView.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.historyCollectionView.cellForItem(at: indexPath) as? HistoryCell
        let searchString = cell?.searchLabel.text
        self.historyViewCellDidTap?(searchString)
    }
}


class HistoryCell: UICollectionViewCell {
    
    struct Metric {
        static let createdAtLabelTop = CGFloat(8)
        static let createdAtLabelLeft = CGFloat(8)
        static let createdAtLabelRight = CGFloat(8)
        
        static let searchLabelTop = CGFloat(4)
        static let searchLabelLeft = CGFloat(8)
        static let searchLabelRight = CGFloat(8)
        
        static let separatorViewTop = CGFloat(8)
        static let separatorViewLeft = CGFloat(8)
        static let separatorViewRight = CGFloat(8)
        static let separatorViewBottom = CGFloat(2)
        static let separatorViewHeight = CGFloat(1.0)
    }
    
    struct Font {
        static let createdAtLabel = UIFont.systemFont(ofSize: 10)
        static let searchLabel = UIFont.boldSystemFont(ofSize: 15)
    }
    
    let createdAtLabel = UILabel()
    let searchLabel = UILabel()
    let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createdAtLabel.font = Font.createdAtLabel
        self.searchLabel.font = Font.searchLabel
        self.searchLabel.numberOfLines = 3
        self.separatorView.backgroundColor = UIColor.bgcolorForCell
        self.addSubview(self.createdAtLabel)
        self.addSubview(self.searchLabel)
        self.addSubview(self.separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(searchText: String, createdAt: String) {
        
        self.createdAtLabel.text = createdAt
        self.searchLabel.text = searchText

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("cell layout")
        
        self.createdAtLabel.sizeToFit()
        self.createdAtLabel.top = Metric.createdAtLabelTop
        self.createdAtLabel.left = Metric.createdAtLabelLeft
        self.createdAtLabel.width = self.width
        
        self.searchLabel.top = self.createdAtLabel.bottom + Metric.searchLabelTop
        self.searchLabel.left = Metric.searchLabelLeft
        self.searchLabel.width = self.width - Metric.searchLabelLeft - Metric.searchLabelRight
        self.searchLabel.sizeToFit()
        
        self.separatorView.top = self.searchLabel.bottom + Metric.separatorViewTop
        self.separatorView.left = Metric.separatorViewLeft
        self.separatorView.width = self.width - Metric.separatorViewLeft - Metric.separatorViewRight
        self.separatorView.height = Metric.separatorViewHeight
    }
    
    class func size(with width: CGFloat, of searchText: String) -> CGSize {
        var height: CGFloat
        
        let searchLabelMaxSize = CGSize(
            width: width - Metric.searchLabelLeft - Metric.searchLabelRight,
            height: Font.searchLabel.lineHeight * 3
        )
        
        let boundingRect = (searchText as NSString).boundingRect(
            with: searchLabelMaxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSFontAttributeName: Font.searchLabel],
            context: nil
        )
        
        height = Metric.createdAtLabelTop
        height += Font.createdAtLabel.lineHeight
        
        height += Metric.searchLabelTop
        height += ceil(boundingRect.height)
        
        height += Metric.separatorViewTop
        height += Metric.separatorViewHeight
        height += Metric.separatorViewBottom
        
        return CGSize(width: width, height: height)
    }
}







