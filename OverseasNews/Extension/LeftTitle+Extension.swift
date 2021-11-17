//
//  LeftTitle+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

extension UIViewController {
    
    func configureLeftTitle(title: String) {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 30)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.leftItemsSupplementBackButton = true
    }
}
