//
//  SettingViewController.swift
//  TMSearch
//
//  Created by KeonWoo HAN on 2017. 3. 29..
//  Copyright © 2017년 FunDrinker. All rights reserved.
//

import UIKit
import SafariServices

class SettingViewController: UIViewController {
    
    struct Section {
        var items: [SectionItem]
    }
    
    enum SectionItem {
        case about
        case version
        case icon
        case openSource
    }
    
    struct FileData {
        var text: String?
        var textValue: String?
    }
    
    // MARK: Properties
    
    fileprivate let sections: [Section] = [
        Section(items: [.about, .version]),
        Section(items: [.icon, .openSource]),
    ]
    
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.image = UIImage(named: "icon-setting")
        self.tabBarItem.selectedImage = UIImage(named: "icon-setting-selected")
        self.tabBarController?.tabBar.tintColor = .lightGray
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -7, right: -2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SettingCell.self, forCellReuseIdentifier: "cell")
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        self.tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }
    
    func cellData(for item: SectionItem) -> FileData {
        switch item {
        case .about:
            return FileData(text: "TM Search에 관하여", textValue: nil)
        case .version:
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            return FileData(text: "현재버젼", textValue: version)
        case .icon:
            return FileData(text: "아이콘 출처", textValue: "icons8.com")
        case .openSource:
            return FileData(text: "오픈소스 라이센스", textValue: nil)
        }
        
        
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = cellData(for: self.sections[indexPath.section].items[indexPath.row])
        cell.textLabel?.text = data.text
        cell.detailTextLabel?.text = data.textValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItem = self.sections[indexPath.section].items[indexPath.row]
        switch sectionItem {
        case .about:
            break
        case .version:
            break
        case .icon:
            let url = URL(string: "http://icons8.com")
            self.present(SFSafariViewController(url: url!), animated: true, completion: nil)
            break
        case .openSource:
            break
        }
    }
}

class SettingCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}













