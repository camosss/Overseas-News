//
//  ArticleBodyViewController.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/17.
//

import UIKit

class ArticleBodyViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Helper
    
    
    // MARK: - Action
    
    @IBAction func scrapButton(_ sender: UIBarButtonItem) {
        print("스크랩")
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print("공유")
    }
}
