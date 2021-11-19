//
//  SearchViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private var search = [Search]() {
        didSet { tableView.reloadData() }
    }
    
    private var filterSearch = [Search]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.contentInset.bottom = 50
        
        configureLeftTitle(title: "Search")
        configureSearchController()
    }
    
    
    // MARK: - Helper
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.search = search[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        let url = "https://bing-news-search1.p.rapidapi.com/news/search?q=\(searchText)&cc=US&freshness=Day&textFormat=Raw&safeSearch=Off"
        
        var tmp = [Search]()
        
        if searchText.isEmpty {
            search = []
        } else {
            AF.request(url, method: .get, headers: Bundle.headers).validate().responseJSON { response in
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
                        let category = "\(json["value"][idx]["category"])"
                        
                        tmp.append(Search(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage, category: category))
                        
                        DispatchQueue.main.async {
                            self.search = tmp
                        }
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
        
       
    }
}
