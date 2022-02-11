//
//  SlideView.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/12/31.
//

import UIKit

class SlideView: UIView {
    
    // MARK: - Properties
    
    var providerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont().smallFont
        return label
    }()
    
    var snippetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var webSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go To Article", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper

    func setupConstraints() {

        let labelStack = UIStackView(arrangedSubviews: [providerLabel, titleLabel, snippetLabel, dateLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        addSubview(webSearchButton)
        webSearchButton.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(labelStack)
        }
    }
}
