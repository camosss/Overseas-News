//
//  CategorySectionViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategorySectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionURL = [String]()
    var sectionName = [String]()
    
    private var article = [Article]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
//        for idx in sectionURL {
//            fetchDate(urlString: idx)
//        }

//        fetchDate()
    }
    
    // MARK: - Helper
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
    }
    
    func realmDate() {
        
        // List Object에 현재 시간과 같이 테이블 짜고
        // 조건문으로 저장된 시간에서 24시간이 지나면 이전꺼 삭제하고, 새로운 테이블 저장
        
    }
    
    func fetchDate() {
        
        for urlString in sectionURL {
            let url = "https://bing-news-search1.p.rapidapi.com/news?category=\(urlString)&cc=US&safeSearch=Off&textFormat=Raw"
            
            AF.request(url, method: .get, headers: Bundle.categoryHeaders).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    var tmp = [Article]()
                    
                    for idx in 0..<json["value"].count {
                        let title = "\(json["value"][idx]["name"])"
                        let description = "\(json["value"][idx]["description"])"
                        let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                        let url = "\(json["value"][idx]["url"])"
                        let datePublished = "\(json["value"][idx]["datePublished"])"
                        let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                        
                        let articleDate = Article(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName)
                        tmp.append(articleDate)
                    }
                    print(tmp)
                    
                    
                    // realm 데이터에 저장

                case .failure(let error):
                    print(error)
                }
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

extension CategorySectionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("View all", for: .normal)
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
        return article.count/4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        cell.article = article[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        vc.article = article[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
