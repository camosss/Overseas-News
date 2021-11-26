//
//  ArticleBodyViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class ArticleBodyViewController: UIViewController {
    
    // MARK: - Properties
    
    var article: ArticleModel!
    var search: Search!

    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureURLButton()
        
        if article != nil {
            configureArticle()
        } else {
            configureSearch()
        }
    }
    
    // MARK: - Helper
    
    func configureURLButton() {
        urlButton.setTitle("Go To Article", for: .normal)
        urlButton.setTitleColor(.label, for: .normal)
        urlButton.backgroundColor = .systemGray6
        urlButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        urlButton.layer.cornerRadius = 10
        urlButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func configureArticle() {
        titleLabel.text = article.title
        dateLabel.text = article.datePublished.toString()
        providerName.text = article.providerName
        bodyLabel.text = "\(article.contents)..."
        
        if article.postImage == "null" {
            postImage.image = UIImage(named: "icon")
        } else {
            postImage.setImage(imageUrl: article.postImage)
        }
    }
    
    func configureSearch() {
        titleLabel.text = search.title == "null" ? "" : search.title
        dateLabel.text = search.datePublished == "null" ? "" : search.datePublished
        providerName.text = search.providerName == "null" ? "" : search.providerName
        bodyLabel.text = search.description == "null" ? "" : "\(search.description)..."
        postImage.setImage(imageUrl: search.postImage)
    }
    
    // MARK: - Action
    
    @IBAction func handleGoURL(_ sender: UIButton) {
        let urlString = article != nil ? article.url : search.url
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func handleShareButton(_ sender: UIBarButtonItem) {
        let urlString = article != nil ? article.url : search.url
        let activityController = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}

