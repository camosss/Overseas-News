//
//  TrendingViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import Network
import RealmSwift
import Toast
import Alamofire
import CHTCollectionViewWaterfallLayout
import SkeletonView
import IAMPopup

class TrendingViewController: UIViewController {
    
    // MARK: - Properties
    
    let networkMoniter = NWPathMonitor() // 네트워크 변경 감지
    
    var urlString: String?

    let slideView = SlideView()
    let slideUpViewHeight: CGFloat = 450
    
    let localRealm = try! Realm()
    var tasks: Results<SaveTrending>?
    
    let todayDateString = DateFormatter.currentFormatter.string(from: Date())
        
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(localRealm.configuration.fileURL!)

        handleNetwork()
        configureLeftTitle(title: "Trending Topic")
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
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
    }
    
    private func handleNetwork() {
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
    
    func configureSlideViewUI(row: TrendingModel?) {
        urlString = row?.url
        slideView.providerLabel.text = row?.provider
        slideView.titleLabel.text = row?.title
        slideView.snippetLabel.text = row?.snippet
        slideView.dateLabel.text = row?.datePublished.toString(dateValue: row?.datePublished ?? Date())
        slideView.webSearchButton.addTarget(self, action: #selector(goWebSearch), for: .touchUpInside)
    }
    
    private func handleHideSkeleton() {
        collectionView.stopSkeletonAnimation()
        collectionView.hideSkeleton(reloadDataAfter: true)
        collectionView.reloadData()
    }
    
    // MARK: - Fetch Data
    
    private func fetchTrendingTopicData() {
        if localRealm.objects(SaveTrending.self).filter("saveDate == '\(todayDateString)'").isEmpty {
            
            APIService.shared.requestTrending { tempTrendingTopic in
                try! self.localRealm.write {
                    let saveTrending: SaveTrending = .init(saveDate: self.todayDateString, trendingModels: tempTrendingTopic)
                    self.localRealm.add(saveTrending)
                }

                DispatchQueue.main.async {
                    self.tasks = self.localRealm.objects(SaveTrending.self).filter("saveDate == '\(self.todayDateString)'")
                    self.handleHideSkeleton()
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
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrendingViewController: SkeletonCollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return UICollectionViewCell.reuseIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseIdentifier, for: indexPath) as! TrendingCollectionViewCell
        guard let row = tasks?.filter("saveDate == %@", todayDateString).first?.trendingModels[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.IAM_bottom(height: slideUpViewHeight) { popupView in
            
            popupView.addSubview(self.slideView)
            self.slideView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            let row = self.tasks?.filter("saveDate == %@", self.todayDateString).first?.trendingModels[indexPath.row]
            self.configureSlideViewUI(row: row)
        }
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout

extension TrendingViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 150...250))
    }
}
