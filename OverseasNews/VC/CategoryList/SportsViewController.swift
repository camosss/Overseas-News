//
//  SportsViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class SportsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionName = ["Sports", "Soccer", "NBA", "MLB", "NFL", "Golf", "Tennis", "NHL"]
    let urlStrings = ["Sports", "Sports_Soccer", "Sports_NBA", "Sports_MLB", "Sports_NFL", "Sports_Tennis", "Sports_NHL"]

    private var categorySports = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categorySoccer = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryNBA = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryMLB = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryNFL = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryTennis = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryNHL = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
    }
    
    // MARK: - Action
    
    @objc func handleSeeMore(button: UIButton) {
        print("더보기", button.tag)
        let sb = UIStoryboard(name: "SeeMorePage", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "SeeMorePageViewController") as! SeeMorePageViewController
        vc.sectionTitle = sectionName[button.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SportsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("see more", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSeeMore(button:)), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SportsTableViewCell.identifier, for: indexPath) as! SportsTableViewCell
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
}

