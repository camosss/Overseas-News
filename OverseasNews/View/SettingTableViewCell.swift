//
//  SettingTableViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/25.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SettingTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
