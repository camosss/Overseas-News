//
//  NewsViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionName = ["Business", "Politics"]
    
    private var categoryBusiness = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryPolitics = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        
        fetchNewsDate(categorySection: "Business", category: categoryBusiness)
        fetchNewsDate(categorySection: "Politics", category: categoryPolitics)
    }
    
    // MARK: - Helper
    
    func fetchNewsDate(categorySection: String, category: [Category]) {
        var category = category
        let url = "https://bing-news-search1.p.rapidapi.com/news?category=\(categorySection)&cc=US&safeSearch=Off&textFormat=Raw"
        let headers: HTTPHeaders = ["x-rapidapi-host": "bing-news-search1.p.rapidapi.com",
                       "x-rapidapi-key": Bundle.main.bingApiKey]
        
        AF.request(url, method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                for idx in 0..<2 {
                    let title = "\(json["value"][idx]["name"])"
                    let description = "\(json["value"][idx]["description"])"
                    let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                    let url = "\(json["value"][idx]["url"])"
                    let datePublished = "\(json["value"][idx]["datePublished"])"
                    let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                    let providerImage = "\(json["value"][idx]["provider"][0]["image"]["thumbnail"]["contentUrl"])"
                    
                    category.append(Category(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                }

            case .failure(let error):
                print(error)
            }
        }
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

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        if indexPath.section == 0 {
//            let categoryBusiness = categoryBusiness[indexPath.row]

            
        }
        
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
