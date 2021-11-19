//
//  WorldTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit

class WorldTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var category: Category? {
        didSet { configure() }
    }
    
    static let identifier = "WorldTableViewCell"
    
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
        guard let category = category else { return }
        
        titleLabel.text = category.title
        providerLabel.text = category.providerName
        
        postImageView.setImage(imageUrl: category.postImage)
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
    }
}
