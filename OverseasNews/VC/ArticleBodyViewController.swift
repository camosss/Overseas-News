//
//  ArticleBodyViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import RealmSwift

class ArticleBodyViewController: UIViewController {
    
    // MARK: - Properties
    
    let localRealm = try! Realm()
    var tasks: Results<RealmModel>!
    
    var article: Article!
    var search: Search!

    @IBOutlet weak var scrapButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var providerName: UILabel!
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
        bodyLabel.text = "\(article.description)..."
        postImage.setImage(imageUrl: article.postImage)

        urlLabel.text = article.url
        urlLabel.textColor = .systemOrange
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(goArticleURL))
        tapGesture.numberOfTapsRequired = 1
        urlLabel.addGestureRecognizer(tapGesture)

    }
    
    func configureSearch() {
        titleLabel.text = search.title
        dateLabel.text = search.datePublished
        providerName.text = search.providerName
        bodyLabel.text = "\(search.description)..."
        postImage.setImage(imageUrl: search.postImage)

        urlLabel.text = search.url
        urlLabel.textColor = .systemOrange
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(goSearchURL))
        tapGesture.numberOfTapsRequired = 1
        urlLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    
    @objc func goArticleURL() {
        guard let url = URL(string: article.url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func goSearchURL() {
        guard let url = URL(string: search.url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func handleScrapButton(_ sender: UIBarButtonItem) {
        print("스크랩")
    }
    
    
    @IBAction func handleShareButton(_ sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [article.url], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}

