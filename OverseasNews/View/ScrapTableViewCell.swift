//
//  ScrapTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class ScrapTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ScrapTableViewCell"
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
