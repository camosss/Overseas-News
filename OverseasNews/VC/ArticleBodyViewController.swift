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
        configureArticle()
//        print(localRealm.configuration.fileURL!)
    }
    
    // MARK: - Helper
    
    func configureArticle() {
        titleLabel.text = article.title
        dateLabel.text = article.datePublished
        providerName.text = article.providerName
        bodyLabel.text = "\(article.description)..."
        
        urlLabel.text = article.url
        urlLabel.textColor = .systemOrange
        urlLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(goArticleURL))
        tapGesture.numberOfTapsRequired = 1
        urlLabel.addGestureRecognizer(tapGesture)

        providerImage.setImage(imageUrl: article.providerImage)
        postImage.setImage(imageUrl: article.postImage)
    }
    
    // MARK: - Action
    
    @objc func goArticleURL() {
        guard let url = URL(string: article.url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func handleScrapButton(_ sender: UIBarButtonItem) {
        print("스크랩")
                
        let title = article.title
        let contents = article.description
        let postImage = article.postImage
        let url = article.url
        let datePublished = article.datePublished
        let providerName = article.providerName
        let providerImage = article.providerImage
        
        let task = RealmModel(title: title, contents: contents, postImage: postImage, url: url, datePublished: datePublished, providerName: providerName, providerImage: providerImage)
        
        try! localRealm.write {
            localRealm.add(task)
            
            // Realm 데이터안의 indexPath가 있어야 해당 데이터의 토클이 진행된다
            task.scrap.toggle()
        }
        tasks = localRealm.objects(RealmModel.self)
        
        DispatchQueue.main.async {
            self.scrapButton.image = task.scrap ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }
    
    
    @IBAction func handleShareButton(_ sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [article.url], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}

