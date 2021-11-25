//
//  TrendingCollectionViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import SnapKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TrendingCollectionViewCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black.withAlphaComponent(0.2)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isSkeletonable = true
        self.imageView.isSkeletonable = true
        self.backgroundImageView.isSkeletonable = true
        self.titleLabel.isSkeletonable = true
        
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.trailing.bottom.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Helper
    
    func configure(_ trendingModel: TrendingModel) {
        if trendingModel.postImage == "" {
            imageView.image = UIImage(named: "icon")
        } else {
            imageView.setImage(imageUrl: trendingModel.postImage)
        }
        titleLabel.text = trendingModel.title
        titleLabel.numberOfLines = 0
    }
}
