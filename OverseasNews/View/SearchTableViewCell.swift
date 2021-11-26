//
//  SearchTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var search: Search? {
        didSet { configure() }
    }
    
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
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
        guard let search = search else { return }
        
        categoryLabel.text = search.category
        titleLabel.text = search.title
        providerLabel.text = search.providerName == "null" ? "" : search.providerName
        
        postImageView.setImage(imageUrl: search.postImage)
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10
    }

}
