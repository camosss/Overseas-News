//
//  SeeMorePageViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class SeeMorePageViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitle = ""
    
    private var category = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = sectionTitle
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        
        fetchNewsDate(urlString: sectionTitle)
    }
    
    // MARK: - Helper
    
    func fetchNewsDate(urlString: String) {
        let url = "https://bing-news-search1.p.rapidapi.com/news?category=\(urlString)&cc=US&safeSearch=Off&textFormat=Raw"
        let headers: HTTPHeaders = ["x-rapidapi-host": "bing-news-search1.p.rapidapi.com",
                       "x-rapidapi-key": Bundle.main.bingApiKey]
        
        AF.request(url, method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                for idx in 0..<json["value"].count {
                    let title = "\(json["value"][idx]["name"])"
                    let description = "\(json["value"][idx]["description"])"
                    let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                    let url = "\(json["value"][idx]["url"])"
                    let datePublished = "\(json["value"][idx]["datePublished"])"
                    let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                    let providerImage = "\(json["value"][idx]["provider"][0]["image"]["thumbnail"]["contentUrl"])"
                    
                    self.category.append(Category(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SeeMorePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeeMorePageTableViewCell.identifier, for: indexPath) as! SeeMorePageTableViewCell
        
        let category = category[indexPath.row]
        cell.category = category
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
        fix.image = UIImage(systemName: "pin")
        fix.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [fix])
    }
}
