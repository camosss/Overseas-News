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
    @IBOutlet weak var urlLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if article != nil {
            configureArticle()
        } else {
            configureSearch()
        }
    }
    
    // MARK: - Helper
    
    func configureArticle() {
        titleLabel.text = article.title
        dateLabel.text = article.datePublished
        providerName.text = article.providerName
        bodyLabel.text = "\(article.contents)..."
        postImage.setImage(imageUrl: article.postImage)

        urlLabel.text = article.url
        urlLabel.textColor = .systemOrange
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(goArticleURL))
        tapGesture.numberOfTapsRequired = 1
        urlLabel.addGestureRecognizer(tapGesture)

    }
    
    func configureSearch() {
        titleLabel.text = search.title == "null" ? "" : search.title
        dateLabel.text = search.datePublished == "null" ? "" : search.datePublished
        providerName.text = search.providerName == "null" ? "" : search.providerName
        bodyLabel.text = search.description == "null" ? "" : "\(search.description)..."
        postImage.setImage(imageUrl: search.postImage)

        urlLabel.text = search.url == "null" ? "" : search.url
        urlLabel.textColor = .systemOrange
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(goArticleURL))
        tapGesture.numberOfTapsRequired = 1
        urlLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    
    @objc func goArticleURL() {
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

