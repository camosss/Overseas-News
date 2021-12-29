//
//  ReusableView+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/12/30.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
