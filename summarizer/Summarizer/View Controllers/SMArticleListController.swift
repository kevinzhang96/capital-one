//
//  SMArticleListController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class SMArticleListController: SMViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let sharedInstance = SMArticleListController()
    var articleList: UITableView = UITableView()
    
    // MARK: Private properties
    private let prefs = NSUserDefaults.standardUserDefaults()
    private var articles:       NSMutableArray          = NSMutableArray()
    private var urls:           NSMutableArray          = NSMutableArray()
    private var navBar:         UINavigationBar         = UINavigationBar()
    private var urlField:       UITextField             = UITextField()
    private let refreshControl: UIRefreshControl        = UIRefreshControl()
    
    // MARK: - Configure views for project
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
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        articleList.addSubview(refreshControl)
        
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
        refresh()
    }
    
    // MARK: - Configure article alerts
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
    
    func refresh() {
        guard let s = prefs.valueForKey("articles") as? NSArray else {
            print("Unable to serialize saved urls as NSMutableArray object")
            return
        }
        guard let u = prefs.valueForKey("urls") as? NSArray else {
            print("Unable to serialize saved urls as NSMutableArray object")
            return
        }
        
        articles = NSMutableArray(array: s)
        urls = NSMutableArray(array: u)
        articleList.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Update and clear articles
    func clearArticles() {
        articles = NSMutableArray()
        urls = NSMutableArray()
        prefs.setValue(articles, forKey: "articles")
        prefs.setValue(urls, forKey: "urls")
        articleList.reloadData()
    }
    
    // MARK: Handle a new article request
    func handleArticleRequest(url: String, completion: (() -> ())? = nil) {
        Alamofire.request(.GET, url).response { [unowned self] (request, response, data, error) in
            guard error == nil else {
                self.showErrorAlert()
                return
            }
            
            let html = NSString(data: data!, encoding: NSASCIIStringEncoding)! as String
            
            dispatch_async(dispatch_get_main_queue(), { [unowned self, html] in
                self.articles.addObject(html)
                self.urls.addObject(url)
                
                self.prefs.setValue(self.articles, forKey: "articles")
                self.prefs.setValue(self.urls, forKey: "urls")
                completion?()
            })
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return SMArticleCell(text: articles[indexPath.row] as! String)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let smvc = SMArticleSummaryController()
        smvc.article = Article(text: articles[indexPath.row] as! String, url: urls[indexPath.row] as! String)
        self.presentViewController(smvc, animated: true, completion: nil)
    }
    
}
