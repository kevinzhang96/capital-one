//
//  SMArticleListController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit

class SMArticleListController: SMViewController {
    
    private var articleList: UITableView = UITableView()
    private var navBar: UINavigationBar = UINavigationBar()
    
    override func configureViews() {
        super.configureViews()
        
        articleList.backgroundColor = SMConstants.bgColor2
        articleList.separatorStyle = .None
        articleList.delegate = SMArticleDataSource.sharedInstance
        articleList.dataSource = SMArticleDataSource.sharedInstance
        
        let navItem = UINavigationItem()
        navItem.title = "Articles"
        let addArticleButton = UIBarButtonItem(barButtonSystemItem: .Add, target: SMArticleDataSource.sharedInstance, action: "addNewArticle")
        navItem.rightBarButtonItem = addArticleButton
        
        navBar.backgroundColor = SMConstants.bgColor1
        navBar.items = [navItem]
        
        let viewsDict = [
            "al": articleList,
            "nb": navBar
        ]
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[al]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-60-[al]|", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[nb]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|[nb(==60)]", views: viewsDict))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        articleList.addDashedBorder()
    }
}
