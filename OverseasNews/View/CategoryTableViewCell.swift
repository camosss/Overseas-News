//
//  CategoryTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var article: Article? {
        didSet { configure() }
    }
    
    static let identifier = "CategoryTableViewCell"
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - Helper
    
    func configure() {
        guard let article = article else { return }
        
        titleLabel.text = article.title
        providerLabel.text = article.providerName
        
        postImageView.setImage(imageUrl: article.postImage)
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
    }
}
