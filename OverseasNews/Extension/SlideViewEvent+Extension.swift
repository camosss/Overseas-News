//
//  SlideViewEvent+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2022/01/10.
//

import UIKit

extension TrendingViewController {
    
    func slideViewEvent(indexPath: IndexPath) {
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
