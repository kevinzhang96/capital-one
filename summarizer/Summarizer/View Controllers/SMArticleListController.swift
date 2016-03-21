//
//  SMArticleListController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class SMArticleListController: SMViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let sharedInstance = SMArticleListController()
    var articleList:            UITableView             = UITableView()
    
    private let prefs = NSUserDefaults.standardUserDefaults()
    private var articles: [String]! = nil
    private var navBar:         UINavigationBar         = UINavigationBar()
    private var urlField:       UITextField             = UITextField()
    
    func createAlert(withCancel: Bool = false) -> UIAlertController {
        let action = UIAlertAction(title: "Add", style: .Default, handler: { [unowned self] (action) in
            self.handleArticleRequest(self.urlField.text!, completion: {
                self.articleList.reloadData()
            })
        })
        
        let alert = UIAlertController(
            title: "Add an article",
            message: withCancel ? "URL was invalid, try again!" : "Enter an article URL here",
            preferredStyle: .Alert
        )
        alert.addAction(action)
        if withCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        }
        alert.addTextFieldWithConfigurationHandler(self.addTextField)
        alert.view.setNeedsLayout()
        return alert
    }
    
    func addTextField(textField: UITextField!) {
        textField.placeholder = "URL"
        self.urlField = textField
    }
    
    func showAddAlert() {
        let rvc = UIApplication.sharedApplication().keyWindow?.rootViewController
        rvc?.presentViewController(createAlert(), animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let rvc = UIApplication.sharedApplication().keyWindow?.rootViewController
        rvc?.presentViewController(createAlert(true), animated: true, completion: nil)
    }
    
    override func configureViews() {
        super.configureViews()
        
        articleList.backgroundColor = SMConstants.bgColor2
        articleList.separatorStyle = .None
        
        articleList.delegate = self
        articleList.dataSource = self
        
        let navItem = UINavigationItem(title: "Articles")
        let addArticleButton = UIBarButtonItem(
            barButtonSystemItem : .Add,
            target              : self,
            action              : "showAddAlert"
        )
        navItem.rightBarButtonItem = addArticleButton
        
        let clearButton = UIBarButtonItem(
            title: "Clear",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "clearArticles"
        )
        navItem.leftBarButtonItem = clearButton
        
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
        
        pullArticles()
        articleList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        articleList.addSubview(refreshControl)
    }
    
    func clearArticles() {
        articles = []
        prefs.setValue([], forKey: "articles")
        articleList.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        pullArticles()
        articleList.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles == nil {
            pullArticles()
        }
        return articles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return SMArticleCell(text: articles[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let smvc = SMArticleSummaryController()
        smvc.text = articles[indexPath.row]
        self.presentViewController(smvc, animated: true, completion: nil)
    }
    
    func pullArticles() {
        if let d = prefs.valueForKey("articles") as? [String] {
            articles = d
        } else {
            articles = []
        }
    }
    
    func handleArticleRequest(url: String, completion: (() -> ())? = nil) {
        Alamofire.request(.GET, url).response { [unowned self] (request, response, data, error) in
            guard error == nil else {
                self.showErrorAlert()
                return
            }
            
            let html = NSString(data: data!, encoding: NSASCIIStringEncoding)! as String
            
            dispatch_async(dispatch_get_main_queue(), { [unowned self, html] in
                self.articles.append(html)
                self.prefs.setValue(self.articles, forKey: "articles")
                completion?()
            })
        }
    }
    
}
