//
//  SearchViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchStringText: String?

    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private var article = [Article]() {
        didSet { tableView.reloadData() }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(EmptySearchCollectionViewCell.self, forCellWithReuseIdentifier: EmptySearchCollectionViewCell.identifier)
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.contentInset.bottom = 50
        
        configureLeftTitle(title: "Search")
        configureSearchController()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helper
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
    
    func fetchData(searchText: String) {
        let url = "https://bing-news-search1.p.rapidapi.com/news/search?q=\(searchText)&cc=US&freshness=Day&textFormat=Raw&safeSearch=Off"
        
        var tmp = [Article]()
        
        if searchText.isEmpty {
            article = []
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
                        
                        tmp.append(Article(title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage))
                        
                        DispatchQueue.main.async {
                            self.article = tmp
                        }
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
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

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        searchStringText = searchText
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        fetchData(searchText: searchStringText ?? "")
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySearchCollectionViewCell.identifier, for: indexPath) as! EmptySearchCollectionViewCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}
