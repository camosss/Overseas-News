//
//  CategoryTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
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
    
    func configure(_ articleModel: ArticleModel) {
        titleLabel.text = articleModel.title
        providerLabel.text = articleModel.providerName
        
        if articleModel.postImage == "null" {
            postImageView.image = UIImage(named: "icon")
        } else {
            postImageView.setImage(imageUrl: articleModel.postImage)
        }
        
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
    }
}
