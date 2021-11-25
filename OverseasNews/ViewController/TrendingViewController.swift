//
//  TrendingViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import Network
import RealmSwift
import SnapKit
import Toast
import Alamofire
import SwiftyJSON
import CHTCollectionViewWaterfallLayout
import SkeletonView

class TrendingViewController: UIViewController {
    
    // MARK: - Properties
    
    let networkMoniter = NWPathMonitor() // 네트워크 변경 감지
    
    var urlString: String?

    var containerView = UIView()
    var slideUpView = UIView()
    let slideUpViewHeight: CGFloat = 450
    
    let localRealm = try! Realm()
    var tasks: Results<SaveTrending>?
    
    let todayDateString = DateFormatter.currentFormatter.string(from: Date())
    
    // MARK: - SlideView Properties
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var providerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private var snippetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var webSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go To Article", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(goWebSearch), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(localRealm.configuration.fileURL!)

        handleNetwork()
        configureLeftTitle(title: "Trending Topic")
        configureSlideView()
        configureCollectionView()
        
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton()
        fetchTrendingTopicData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func handleNetwork() {
        networkMoniter.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("network connected")
                if path.usesInterfaceType(.cellular) {
                    print("cellular status")
                } else if path.usesInterfaceType(.wifi) {
                    print("wifi status")
                } else {
                    print("others")
                }
            } else {
                print("network disconnected")
                DispatchQueue.main.async {
                    self.view.makeToast("네트워크 연결이 불안정합니다 ‼️")
                }
            }
        }
        networkMoniter.start(queue: DispatchQueue.global())
    }
    
    func configureSlideView() {
        let labelStack = UIStackView(arrangedSubviews: [providerLabel, titleLabel, snippetLabel, dateLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        slideUpView.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        slideUpView.addSubview(webSearchButton)
        webSearchButton.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(labelStack)
        }
    }
    
    func configureSlideViewUI(row: TrendingModel?) {
        urlString = row?.url
        providerLabel.text = row?.provider
        titleLabel.text = row?.title
        snippetLabel.text = row?.snippet
        dateLabel.text = row?.datePublished.toString()
    }
    
    func handleHideSkeleton() {
        collectionView.stopSkeletonAnimation()
        collectionView.hideSkeleton(reloadDataAfter: true)
        collectionView.reloadData()
    }
    
    func fetchTrendingTopicData() {
        if localRealm.objects(SaveTrending.self).filter("saveDate == '\(todayDateString)'").isEmpty {
            let url = "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/search/TrendingNewsAPI?pageNumber=1&pageSize=10&withThumbnails=false&location=us"
            
            AF.request(url, method: .get, headers: Bundle.trendingHeaders).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    var tempTrendingTopic: [TrendingModel] = []
                    
                    for idx in 0..<json["value"].count {
                        let title = "\(json["value"][idx]["title"])"
                        let snippet = "\(json["value"][idx]["snippet"])"
                        let postImage = "\(json["value"][idx]["image"]["url"])"
                        let url = "\(json["value"][idx]["url"])"
                        let provider = "\(json["value"][idx]["provider"]["name"])"
                        let datePublished = "\(json["value"][idx]["datePublished"])"
                                                
                        let trendingTopic = TrendingModel(title: title, snippet: snippet, postImage: postImage, url: url, datePublished: datePublished.toDate() ?? Date(), provider: provider)
                        tempTrendingTopic.append(trendingTopic)
                    }

                    try! self.localRealm.write {
                        let saveTrending: SaveTrending = .init(saveDate: self.todayDateString, trendingModels: tempTrendingTopic)
                        self.localRealm.add(saveTrending)
                    }
                    
                    DispatchQueue.main.async {
                        self.tasks = self.localRealm.objects(SaveTrending.self).filter("saveDate == '\(self.todayDateString)'")
                        self.handleHideSkeleton()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            tasks = localRealm.objects(SaveTrending.self).filter("saveDate == '\(todayDateString)'")
            handleHideSkeleton()
        }
    }
    
    // MARK: - Action
    
    @objc func goWebSearch() {
        guard let url = URL(string: urlString ?? ""), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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

extension TrendingViewController: SkeletonCollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TrendingCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as! TrendingCollectionViewCell
        guard let row = tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(row)
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
        slideUpView.backgroundColor = .systemGray6
        slideUpView.layer.cornerRadius = 15
        slideUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        slideUpView.frame = CGRect(x: 0, y: screenSize.height,
                                   width: screenSize.width, height: slideUpViewHeight)
        
        let row = tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels[indexPath.row]
        
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.configureSlideViewUI(row: row)
            self.tabBarController?.tabBar.isHidden = true
            self.containerView.alpha = 0.8
            self.slideUpView.frame = CGRect(x: 0,
                                            y: screenSize.height - self.slideUpViewHeight,
                                            width: screenSize.width,
                                            height: self.slideUpViewHeight)
        }, completion: nil)
        
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension TrendingViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 150...250))
    }
}
