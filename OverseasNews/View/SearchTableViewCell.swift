//
//  SearchTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}