//
//  ListViewController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 9..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit

import Alamofire
import Kingfisher
import SWXMLHash

enum ListViewMode {
    case card
    case tile
}

final class ListViewController: UIViewController {
    
    fileprivate struct Key {
        static let apiKey = "T9XoLq9LdEBOVN4JDzepDZjiBanO5AeQI8wyzLmDQhY="
    }
    
    struct Metric {
        static let minumumSpacingForTileCell = CGFloat(4)
        static let numberOfCellsForTileMode = 3
    }
    
    //MARK: Properties
    
    fileprivate var viewMode: ListViewMode = .card
    fileprivate var isLoading = false
    
    fileprivate var currentCount: Int = 1 {
        didSet {
            self.urlString = "http://plus.kipris.or.kr/openapi/rest/trademarkInfoSearchService/freeSearchInfo?word=\(self.searchString)&docsStart=\(self.currentCount)&accessKey=\(Key.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
    }
    fileprivate var totalCount: Int = 0
    
    fileprivate lazy var urlString: String? = "http://plus.kipris.or.kr/openapi/rest/trademarkInfoSearchService/freeSearchInfo?word=\(self.searchString)&docsStart=\(self.currentCount)&accessKey=\(Key.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    fileprivate var trademarks: [Trademark] = []
    fileprivate var historyArray = [[String:String]]()
    
    fileprivate var searchString: String = "삼성" {
        didSet {
            self.urlString = "http://plus.kipris.or.kr/openapi/rest/trademarkInfoSearchService/freeSearchInfo?word=\(self.searchString)&docsStart=\(self.currentCount)&accessKey=\(Key.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
    }
    
    //MARK: UI
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    let tradeMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    fileprivate var shadowView: UIView?
    fileprivate var historyView: HistoryView?
    fileprivate var isHistoryButtonInPressing = false
    
    
    //MARK: initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.image = UIImage(named: "icon-tabbarsearch")
        self.tabBarItem.selectedImage = UIImage(named: "icon-tabbarsearch-selected")
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.bgcolorForCell
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.setupView()
        self.loadFeed()
        self.setupNavBarItem()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.frame
        self.historyView?.width = self.view.width - 80
        
        //데이터를 시간 역순으로 소팅하여 5건만 뽑아냄
        let searchHistory: [[String:String]] = self.loadData().reversed().enumerated().flatMap {
            if $0.offset < 5 {
                return $0.element
            } else {
                return nil
            }
        }
        var cellsHeight: CGFloat = 0
        
        searchHistory.forEach{
            let searchString = $0["searchString"]
            cellsHeight += HistoryCell.size(with: self.view.width - 120, of:searchString ?? "").height
        }
        cellsHeight += 40

        self.historyView?.height = min(cellsHeight, self.view.height - 200)
        self.historyView?.center = self.view.center
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.refreshControl.addTarget(self, action: #selector(refreshControlDidActivate), for: .valueChanged)
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.frame = self.view.frame
        
        self.collectionView.register(TrademarkCell.self, forCellWithReuseIdentifier: "listCellID")
        self.collectionView.register(TileCell.self, forCellWithReuseIdentifier: "tilecell")
        self.collectionView.register(ListHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "listCellHeadID")
        self.collectionView.register(FooterIndicatorView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "listCellFootID")
        self.view.addSubview(self.collectionView)
    }
    
    func loadFeed(more: Bool = false) {
        
        if let header = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? ListHeaderView {
            header.searchTextField.isEnabled = false
        }
        
        
        if !more { self.currentCount = 1 }
        
        guard !self.isLoading, (self.currentCount < self.totalCount || self.currentCount == 1) else { return }
        self.isLoading = true
        
        guard let url = self.urlString else { return }
        print(url)
        Alamofire.request(url).responseData { response in
            switch response.result {
            case .success(let value):
                print("성공")
                if let header = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? ListHeaderView {
                    header.searchTextField.isEnabled = true
                }
                self.refreshControl.endRefreshing()
                let xml = SWXMLHash.parse(value)
                do {
                    let trademarks: [Trademark] = try xml["response"]["body"]["items"]["TradeMarkInfo"].value()
                    
                    if more {
                        guard self.currentCount < self.totalCount else { return }
                        
                        trademarks.forEach({ (trademark) in
                            self.trademarks.append(trademark)
                        })
                    } else {
                        
                        if let totalCount = xml["response"]["body"]["items"]["TotalSearchCount"].element?.text {
                            self.totalCount = Int(totalCount)!
                        }
                        self.trademarks = trademarks
                    }
                } catch (let error) {
                    print("에러발생\(error)")
                }
                self.collectionView.reloadData()
                self.currentCount += 30
                self.isLoading = false

                
                
            case .failure(let error):
                print("실패\(error)")
            }
        }
        
    }
    
    func setupNavBarItem() {
        self.navigationItem.title = "상표검색"
        
        self.navigationController?.navigationBar.tintColor = .lightGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-history"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonDidTap))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(viewModeBarButtonDidTap))
    }
    
    func rightBarButtonDidTap() {
        if !self.isHistoryButtonInPressing{
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.isHistoryButtonInPressing = true
            
            self.shadowView = UIView()
            self.shadowView?.backgroundColor = UIColor.bgcolorForCell.withAlphaComponent(0.8)
            
            self.historyView = HistoryView(frame: .zero)
            self.historyView?.historyViewCellDidTap = { search in
                let headerView = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? ListHeaderView
                headerView?.searchTextField.text = search
                headerView?.searchButtonDidTap()
                self.shadowViewDidTap()
            }
            
            if let shadow = self.shadowView {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(shadowViewDidTap))
                shadow.addGestureRecognizer(gesture)
                self.view.addSubview(shadow)
                shadow.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            if let history = self.historyView {
                self.view.addSubview(history)
            }
        }
    }
    func viewModeBarButtonDidTap() {
        if self.viewMode == .card {
            self.viewMode = .tile
        } else {
            self.viewMode = .card
        }
        self.collectionView.reloadData()
    }
    
    
    func shadowViewDidTap() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.shadowView?.alpha = 0.0
                self.historyView?.origin = CGPoint(x: self.historyView?.x ?? 0, y: self.view.height)
        },
            completion: {
                success in
                self.shadowView?.removeFromSuperview()
                self.historyView?.removeFromSuperview()
                self.historyView?.gestureRecognizers?.removeAll()
                self.isHistoryButtonInPressing = false
                self.navigationItem.leftBarButtonItem?.isEnabled = true
        })
    }
    
    func refreshControlDidActivate() {
        self.loadFeed()
    }
    
    func orientationDidChange() {
        print("orientation changed")
        self.collectionView.collectionViewLayout.invalidateLayout()
        if let historyView = self.historyView {
            
            historyView.historyTitleLabel.setNeedsDisplay()
            historyView.historyCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - CollectionView Delegate

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trademarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trademark = self.trademarks[indexPath.item]
        switch self.viewMode {
        case .card:
        
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "listCellID", for: indexPath) as! TrademarkCell
            
            cell.configure(with: trademark)
            return cell
        case .tile:
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "tilecell", for: indexPath) as! TileCell
            cell.configure(with: trademark)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if kind == UICollectionElementKindSectionHeader {
            let supplementaryView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "listCellHeadID", for: indexPath) as! ListHeaderView
            supplementaryView.countLabel.text = "203 건 검색됨"
            supplementaryView.searchTextFieldDidTap = { (searchText) in
                print("검색어가 입력되었습니다.")
                self.searchString = searchText
                self.trademarks.removeAll()
                self.collectionView.reloadData()
                self.loadFeed()
                // 검색 히스토리에 저장코드 구현!!
                self.saveHistory()

            }
            return supplementaryView
            
        } else {
            let supplementaryView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "listCellFootID", for: indexPath) as! FooterIndicatorView
            return supplementaryView
        }
    }
    
    func hideKeyboard() {
        let headerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader)
        headerView.first?.backgroundColor = UIColor.bgcolorForCell
        collectionView.endEditing(true)
    }
    
    func saveHistory() {
        // 검색 생성 날짜 저장
        let date = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let year = String(calendar.component(.year, from: date))
        
        let historyDict = [
            "searchString":self.searchString,
            "year":year,
            "month":month,
            "day":day,
            ]
        
        self.historyArray = self.loadData()
        self.historyArray.append(historyDict)
        self.saveData()
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        defaults.setValue(self.historyArray, forKey: "history")
        defaults.synchronize()
    }
    
    func loadData() -> [[String:String]] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "history") as? [[String:String]] ?? []
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        switch self.viewMode {
        case .card:
            let height = TrademarkCell.sizeForTrademarkCell()
            return CGSize(width: self.collectionView.frame.width, height: height)
        case .tile:
            let width = round(
                (self.collectionView.width - (CGFloat(Metric.numberOfCellsForTileMode - 1) * Metric.minumumSpacingForTileCell)) / CGFloat(Metric.numberOfCellsForTileMode)
            )
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch self.viewMode {
        case .card:
            return 0
        case .tile:
            return Metric.minumumSpacingForTileCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.viewMode {
        case .card:
            return 0
        case .tile:
            return Metric.minumumSpacingForTileCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height = ListHeaderView.Metric.searchTextFieldTop + ListHeaderView.Metric.searchTextFieldHeight + ListHeaderView.Metric.searchTextFieldBottom
        return CGSize(width: self.collectionView.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // headerview textfield 에 포커스되지 않은 경우에만 detailview
        let headerIndexPath = IndexPath(item: 0, section: 0)
        
        if let headerViewTextfield = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: headerIndexPath)?.subviews.first {
            if !headerViewTextfield.isFirstResponder {
                let detailViewController = DetailViewController()
                detailViewController.trademark = self.trademarks[indexPath.item]
                self.show(detailViewController, sender: self)
            }
        } else {
            let detailViewController = DetailViewController()
            detailViewController.trademark = self.trademarks[indexPath.item]
            self.show(detailViewController, sender: self)
        }
        self.hideKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.hideKeyboard()
        if (scrollView.contentOffset.y - scrollView.contentHeight + scrollView.height) > -200 {
            self.loadFeed(more: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
//        if self.currentCount == 1 {
//            return CGSize(width: self.collectionView.width, height: self.collectionView.height)
//        }
        if self.currentCount > self.totalCount {
            return .zero
        } else {
            return CGSize(width: self.collectionView.width, height: 44)
        }
    }
}





