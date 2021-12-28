//
//  CategoryViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit
import Tabman
import Pageboy

class CategoryViewController: TabmanViewController {
    
    // MARK: - Properties
    
    private var viewControllers: Array<UIViewController> = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftTitle(title: "Category")
        configureViewControllers()
        self.dataSource = self

        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    // MARK: - Helper
    
    private func configureViewControllers() {
        let newsVC = UIStoryboard.init(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "CategorySectionViewController") as! CategorySectionViewController
        let entertainmentVC = UIStoryboard.init(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "CategorySectionViewController") as! CategorySectionViewController
        let sportsVC = UIStoryboard.init(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "CategorySectionViewController") as! CategorySectionViewController
        let scienceTechnologyVC = UIStoryboard.init(name: "Category", bundle: nil).instantiateViewController(withIdentifier: "CategorySectionViewController") as! CategorySectionViewController
        
        viewControllers.append(newsVC)
        viewControllers.append(entertainmentVC)
        viewControllers.append(sportsVC)
        viewControllers.append(scienceTechnologyVC)
    }
    
    private func settingTabBar(ctBar: TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        ctBar.layout.interButtonSpacing = 20
        ctBar.backgroundView.style = .blur(style: .light)
        
        ctBar.buttons.customize { button in
            button.tintColor = .lightGray
            button.selectedTintColor = .label
            button.font = UIFont.systemFont(ofSize: 14)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = .systemOrange
    }
}

// MARK: - PageboyViewControllerDataSource, TMBarDataSource

extension CategoryViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "News")
        case 1:
            return TMBarItem(title: "Entertainment")
        case 2:
            return TMBarItem(title: "Sports")
        case 3:
            return TMBarItem(title: "Science&Technology")
        default:
            return TMBarItem(title: "\(index)")
        }
        
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        let vc = viewControllers[index] as? CategorySectionViewController
        vc?.sectionURL = Category.allCases[index].description
        vc?.sectionName = CategorySectionName.allCases[index].description
        return vc
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
