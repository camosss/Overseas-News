//
//  EmptySearchCollectionViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/19.
//

import UIKit
import SnapKit

class EmptySearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
        
    let iconimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemOrange
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Search the news"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI() {
        addSubview(iconimageView)
        iconimageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconimageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
