//
//  LicenseViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/25.
//

import UIKit

class LicenseViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open Source License"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Helper
    
    private func goLicenseURL(url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LicenseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LicenseOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        guard let option = LicenseOption(rawValue: indexPath.row) else { return cell }
        cell.titleLabel.text = option.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        if row == 0 {
            goLicenseURL(url: "https://github.com/Alamofire/Alamofire/blob/master/LICENSE")
        } else if row == 1 {
            goLicenseURL(url: "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout/blob/develop/LICENSE")
        } else if row == 2 {
            goLicenseURL(url: "https://github.com/onevcat/Kingfisher/blob/master/LICENSE")
        } else if row == 3 {
            goLicenseURL(url: "https://github.com/uias/Pageboy/blob/main/LICENSE")
        } else if row == 4 {
            goLicenseURL(url: "https://github.com/realm/realm-cocoa/blob/master/LICENSE")
        } else if row == 5 {
            goLicenseURL(url: "https://github.com/Juanpe/SkeletonView/blob/main/LICENSE")
        } else if row == 6 {
            goLicenseURL(url: "https://github.com/SnapKit/SnapKit/blob/develop/LICENSE")
        } else if row == 7 {
            goLicenseURL(url: "https://github.com/SwiftyJSON/SwiftyJSON/blob/master/LICENSE")
        } else if row == 8 {
            goLicenseURL(url: "https://github.com/uias/Tabman/blob/main/LICENSE")
        } else {
            goLicenseURL(url: "https://github.com/scalessec/Toast-Swift/blob/master/LICENSE")
        }
    }
}
