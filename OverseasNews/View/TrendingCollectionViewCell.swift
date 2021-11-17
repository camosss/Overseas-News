//
//  TrendingCollectionViewCell.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TrendingCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemOrange
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
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
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
}
