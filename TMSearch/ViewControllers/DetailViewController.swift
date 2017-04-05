//
//  DetailViewController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 12..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class DetailViewController: UIViewController {
    
    struct Metric {
        static let drawingImageViewTop = CGFloat(4)
        static let drawingImageViewLeft = CGFloat(0)
        static let drawingImageViewRight = CGFloat(0)
        static let drawingImageViewHeight = CGFloat(230)
        
        static let contentViewTop = CGFloat(4)
        static let contentViewLeft = CGFloat(0)
        static let contentViewRight = CGFloat(0)
        static let contentViewBottom = CGFloat(4)
    }
    
    lazy var itemsForSelected = [(String, String)]()
    
    
    // MARK: Properties
    
    var trademark: Trademark?
    
    // MARK: UI Properties
    
    let drawingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let contentView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return view
    }()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let trademark = self.trademark {
            
            self.itemsForSelected = [
                ("출원번호", trademark.appNumber),
                ("등록번호", trademark.regNumber),
                ("출원인(상표권자)", trademark.applicant),
                ("상표명", trademark.title),
                ("지정상품 코드", trademark.productCode.replacingOccurrences(of: " ", with: ", ")),
                ("현재상태", trademark.status)
            ]
        }
        
        
        self.view.backgroundColor = UIColor.bgcolorForCell
        self.contentView.delegate = self
        self.contentView.dataSource = self
        self.contentView.register(DetailContentCell.self, forCellReuseIdentifier: "contentCell")
        self.navigationItem.title = self.trademark?.title
        self.setupViews()
    }
    
    func setupViews() {
        if let drawingImageURL = self.trademark?.thumbnailUrl {
            self.drawingImageView.setImage(with: drawingImageURL)
        }
        self.view.addSubview(self.drawingImageView)
        self.view.addSubview(self.contentView)
        self.contentView.frame = self.view.frame

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.drawingImageView.top = Metric.drawingImageViewTop + (self.navigationController?.navigationBar.bottom)!
        self.drawingImageView.left = Metric.drawingImageViewLeft
        self.drawingImageView.width = self.view.width
        self.drawingImageView.height = Metric.drawingImageViewHeight

        self.contentView.top = self.drawingImageView.bottom + Metric.contentViewTop
        self.contentView.left = Metric.contentViewLeft
        self.contentView.width = self.view.width - Metric.contentViewLeft - Metric.contentViewRight
        self.contentView.height = self.view.height - self.drawingImageView.bottom - Metric.contentViewTop - Metric.contentViewBottom - (self.tabBarController?.tabBar.height ?? 0)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsForSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contentView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! DetailContentCell

        cell.configure(title: self.itemsForSelected[indexPath.row].0, content: self.itemsForSelected[indexPath.row].1)
        
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailContentCell.height()
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}













