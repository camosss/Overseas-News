//
//  TrendingViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import CHTCollectionViewWaterfallLayout

class TrendingViewController: UIViewController {
    
    // MARK: - Properties
    
    var containerView = UIView()
    var slideUpView = UIView()
    let slideUpViewHeight: CGFloat = 350
    
    private var trendingTopic = [TrendingTopic]() {
        didSet { collectionView.reloadData() }
    }
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var providerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var webSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("키워드 검색", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(goWebSearch), for: .touchUpInside)
        return button
    }()
    
    private lazy var newsSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("관련 기사 검색", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(goNewsSearch), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftTitle(title: "Trending Topic")
        configureSlideView()
        handleRefresh()
        fetchTrendingTopicData()
        
        view.addSubview(collectionView)
        collectionView.contentInset.top = 20
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper
    
    func handleRefresh() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefreshEvent), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    func configureSlideView() {
        let labelStack = UIStackView(arrangedSubviews: [mainLabel, providerLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        slideUpView.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [webSearchButton, newsSearchButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        
        slideUpView.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(labelStack)
        }
    }
    
    func fetchTrendingTopicData() {
        let url = "https://bing-news-search1.p.rapidapi.com/news/trendingtopics?cc=US&textFormat=Raw&safeSearch=Off"
        
        AF.request(url, method: .get, headers: Bundle.headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                for idx in 0..<json["value"].count {
                    let title = "\(json["value"][idx]["query"]["text"])"
                    let postImage = "\(json["value"][idx]["image"]["url"])"
                    let newsSearchUrl = "\(json["value"][idx]["newsSearchUrl"])"
                    let webSearchUrl = "\(json["value"][idx]["webSearchUrl"])"
                    let provider = "\(json["value"][idx]["image"]["provider"][0]["name"])"
                    
                    self.trendingTopic.append(TrendingTopic(title: title, postImage: postImage, newsSearchUrl: newsSearchUrl, webSearchUrl: webSearchUrl, provider: provider))
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Action
    
    @objc func handleRefreshEvent() {
        trendingTopic.removeAll()
        fetchTrendingTopicData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func goWebSearch() {
        print("WebSearch")
    }
    
    @objc func goNewsSearch() {
        print("NewsSearch")
    }
    
    @objc func slideViewDown() {
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.tabBarController?.tabBar.isHidden = false
            self.containerView.alpha = 0
        }, completion: nil)
        
        // 슬라이드 뷰 내려감
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0
            self.slideUpView.frame = CGRect(x: 0,
                                            y: screenSize.height,
                                            width: screenSize.width,
                                            height: self.slideUpViewHeight)
        }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrendingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingTopic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as! TrendingCollectionViewCell
  
        let trendingTopic = trendingTopic[indexPath.row]
        cell.trendingTopic = trendingTopic
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        view.addSubview(containerView)
        containerView.frame = self.view.frame
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideViewDown))
        containerView.addGestureRecognizer(tapGesture)
        containerView.alpha = 0

        let screenSize = UIScreen.main.bounds.size
        view.addSubview(slideUpView)
        slideUpView.backgroundColor = .systemBackground
        slideUpView.layer.cornerRadius = 15
        slideUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        slideUpView.frame = CGRect(x: 0, y: screenSize.height,
                                   width: screenSize.width, height: slideUpViewHeight)

        let trendingTopic = trendingTopic[indexPath.row]

        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.tabBarController?.tabBar.isHidden = true
            self.containerView.alpha = 0.8
            self.slideUpView.frame = CGRect(x: 0,
                                            y: screenSize.height - self.slideUpViewHeight,
                                            width: screenSize.width,
                                            height: self.slideUpViewHeight)
            
            self.mainLabel.text = trendingTopic.title
            self.providerLabel.text = trendingTopic.provider
            
        }, completion: nil)
        
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension TrendingViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 150...250))
    }
}
