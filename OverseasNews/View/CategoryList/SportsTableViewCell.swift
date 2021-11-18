//
//  SportsTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/18.
//

import UIKit

class SportsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SportsTableViewCell"
    
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

}
