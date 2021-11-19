//
//  EntertainmentViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class EntertainmentViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionName = ["Entertainment", "Movie/TV", "Music"]
    let urlStrings = ["Entertainment", "Entertainment_MovieAndTV", "Entertainment_Music"]
    
    private var categoryEntertainment = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryMovieTv = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    private var categoryMusic = [Category]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        
        fetchDate(urlString: "Entertainment")
        fetchDate(urlString: urlStrings[1])
        fetchDate(urlString: urlStrings[2])
    }
    
    // MARK: - Helper
    
    func fetchDate(urlString: String) {
        let url = "https://bing-news-search1.p.rapidapi.com/news?category=\(urlString)&cc=US&safeSearch=Off&textFormat=Raw"
        
        AF.request(url, method: .get, headers: Bundle.headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                for idx in 0..<3 {
                    let title = "\(json["value"][idx]["name"])"
                    let description = "\(json["value"][idx]["description"])"
                    let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                    let url = "\(json["value"][idx]["url"])"
                    let datePublished = "\(json["value"][idx]["datePublished"])"
                    let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                    let providerImage = "\(json["value"][idx]["provider"][0]["image"]["thumbnail"]["contentUrl"])"
                
                    if urlString == self.urlStrings[0] {
                        self.categoryEntertainment.append(Category(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                    } else if urlString == self.urlStrings[1] {
                        self.categoryMovieTv.append(Category(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                    } else if urlString == self.urlStrings[2] {
                        self.categoryMusic.append(Category(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                    }
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
        vc.sectionTitle = urlStrings[button.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EntertainmentViewController: UITableViewDataSource, UITableViewDelegate {
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
        return section == 0 ? categoryEntertainment.count : section == 1 ? categoryMovieTv.count : categoryMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntertainmentTableViewCell.identifier, for: indexPath) as! EntertainmentTableViewCell
        let row = indexPath.section == 0 ? categoryEntertainment[indexPath.row] : indexPath.section == 1 ? categoryMovieTv[indexPath.row] : categoryMusic[indexPath.row]
        cell.category = row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
