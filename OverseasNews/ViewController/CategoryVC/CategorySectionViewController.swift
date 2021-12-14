//
//  CategorySectionViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SkeletonView

class CategorySectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionURL = [String]()
    var sectionName = [String]()
    
    let localRealm = try! Realm()
    var tasks: Results<SaveArticle>?
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
        
        fetchDate()
    }
    
    // MARK: - Helper
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.contentInset.bottom = 50
    }
    
    func handleHideSkeleton() {
        tableView.stopSkeletonAnimation()
        view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        tableView.reloadData()
    }

    func fetchDate() {
        let todayDateString = DateFormatter.currentFormatter.string(from: Date())
        
        for urlString in sectionURL {
            if localRealm.objects(SaveArticle.self).filter("saveDate == '\(todayDateString)' AND sectionName == '\(urlString)'").isEmpty {
                
                AF.request(URL.categoryURL(urlString: urlString), method: .get, headers: Bundle.categoryHeaders).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        
                        let json = JSON(value)
                        var tempArticle: [ArticleModel] = []
                        
                        for idx in 0..<json["value"].count {
                            let title = "\(json["value"][idx]["name"])"
                            let description = "\(json["value"][idx]["description"])"
                            let postImage = "\(json["value"][idx]["image"]["thumbnail"]["contentUrl"])"
                            let url = "\(json["value"][idx]["url"])"
                            let providerName = "\(json["value"][idx]["provider"][0]["name"])"
                            
                            let datePublished = "\(json["value"][idx]["datePublished"])"
                            let endIndex: String.Index = datePublished.index(datePublished.startIndex, offsetBy: 18)
                            let datePublish = String(datePublished[...endIndex])
                            
                            let articles = ArticleModel(sectionName: urlString, title: title, contents: description, postImage: postImage, url: url, datePublished: datePublished.toDate(stringValue: datePublish) ?? Date(), providerName: providerName)
                            tempArticle.append(articles)
                            
                        }
                        
                        try! self.localRealm.write {
                            let saveArticle: SaveArticle = .init(sectionName: urlString, saveDate: todayDateString, articleModels: tempArticle)
                            self.localRealm.add(saveArticle)
                        }
                        
                        DispatchQueue.main.async {
                            self.tasks = self.localRealm.objects(SaveArticle.self).filter("saveDate == '\(todayDateString)'")
                            self.handleHideSkeleton()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            } else {
                tasks = localRealm.objects(SaveArticle.self).filter("saveDate == '\(todayDateString)'")
                handleHideSkeleton()
            }
        }
        
    }
    
    // MARK: - Action
    
    @objc func handleSeeMore(button: UIButton) {
        let sb = UIStoryboard(name: "SeeMorePage", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "SeeMorePageViewController") as! SeeMorePageViewController
        
        let sectionData = tasks?.filter("sectionName == %@", sectionURL[button.tag]).first?.articleModels
        vc.article = sectionData ?? List<ArticleModel>()
        vc.sectionTitle = sectionName[button.tag]

        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CategorySectionViewController: SkeletonTableViewDataSource, UITableViewDelegate {
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
        let cnt = tasks?.filter("sectionName == %@", sectionURL[section]).first?.articleModels.count
        return (cnt ?? 0)/4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CategoryTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        guard let row = tasks?.filter("sectionName == %@", sectionURL[indexPath.section]).first?.articleModels[indexPath.row] else { return UITableViewCell() }
        cell.configure(row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        let row = tasks?.filter("sectionName == %@", sectionURL[indexPath.section]).first?.articleModels[indexPath.row]
        vc.article = row
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
