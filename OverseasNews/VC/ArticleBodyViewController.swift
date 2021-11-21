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
    
    var article: Article!

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
        configureArticle()
    }
    
    // MARK: - Helper
    
    func configureArticle() {
        titleLabel.text = article.title
        dateLabel.text = article.datePublished
        providerName.text = article.providerName
        bodyLabel.text = article.description
        urlLabel.text = article.url
        
        providerImage.setImage(imageUrl: article.providerImage)
        postImage.setImage(imageUrl: article.postImage)
    }
    
    // MARK: - Action
    
    @IBAction func scrapButton(_ sender: UIBarButtonItem) {
        print("스크랩")
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print("공유")
    }
}

