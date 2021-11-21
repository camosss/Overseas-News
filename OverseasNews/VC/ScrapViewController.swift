//
//  ScrapViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import RealmSwift

class ScrapViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftTitle(title: "Scrap")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ScrapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScrapTableViewCell.identifier, for: indexPath) as! ScrapTableViewCell
        cell.titleLabel.text = "기사 제목"
        cell.providerLabel.text = "제공자"
        cell.postImageView.backgroundColor = .lightGray
        cell.postImageView.clipsToBounds = true
        cell.postImageView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fix = UIContextualAction(style: .normal, title: "") { (action, view, nil) in
            self.tableView.reloadData()
        }
        fix.image = UIImage(systemName: "pin.slash.fill")
        fix.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [fix])
    }
}
