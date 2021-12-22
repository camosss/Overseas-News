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
import SkeletonView

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchStringText: String?

    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private var search = [Search]() {
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
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
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
        searchController.searchBar.placeholder = "English only"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
    
    func fetchData(searchText: String) {        
        var tmp = [Search]()
        
        if searchText.isEmpty {
            search = []
        } else {
            AF.request(URL.searchURL(searchText: searchText), method: .get, headers: Bundle.searchHeaders).validate().responseJSON { response in
                switch response.result {
                case .success(let value):

                    let json = JSON(value)

                    if json == [] {
                        print("no result")
                    }

                    for idx in 0..<json["articles"].count {
                        let category = "\(json["articles"][idx]["topic"])"
                        let title = "\(json["articles"][idx]["title"])"
                        let description = "\(json["articles"][idx]["summary"])"
                        let postImage = "\(json["articles"][idx]["media"])"
                        let url = "\(json["articles"][idx]["link"])"
                        let datePublished = "\(json["articles"][idx]["published_date"])"
                        let providerName = "\(json["articles"][idx]["author"])"

                        tmp.append(Search(category: category, title: title, description: description, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName))

                        DispatchQueue.main.async {
                            self.search = tmp

                            self.tableView.stopSkeletonAnimation()
                            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                            self.tableView.reloadData()
                        }
                    }

                case .failure(let error):
                    print(error)
                    AlertHelper.defaultAlert(title: "No Result", message: "No results were found for your search (Please enter in English only)", okMessage: "OK", over: self)

                    DispatchQueue.main.async {
                        self.tableView.stopSkeletonAnimation()
                        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.search = search[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "ArticleBody", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ArticleBodyViewController") as! ArticleBodyViewController
        vc.search = search[indexPath.row]
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
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
        
        fetchData(searchText: self.searchStringText ?? "")
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
