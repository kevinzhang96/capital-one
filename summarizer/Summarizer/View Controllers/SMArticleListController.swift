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
    private var navBar:         UINavigationBar         = UINavigationBar()
    private var urlField:       UITextField             = UITextField()
    private let refreshControl: UIRefreshControl        = UIRefreshControl()
    
    // Need to store article components separately because of NSUserDefault restrictions
    private var texts:          NSMutableArray          = NSMutableArray()
    private var urls:           NSMutableArray          = NSMutableArray()
    private var titles:         NSMutableArray          = NSMutableArray()
    private var summaries:      NSMutableArray          = NSMutableArray()
    
    // MARK: - Configure views for project
    override func configureViews() {
        super.configureViews()
        
        articleList.backgroundColor = SMConstants.bgColor1
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
        
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        navBar.items = [navItem]
        
        self.view.backgroundColor = SMConstants.bgColor2
        
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
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
        guard let s = prefs.valueForKey("texts") as? NSArray else {
            print("Could not find existing texts")
            return
        }
        guard let u = prefs.valueForKey("urls") as? NSArray else {
            print("Could not find existing urls")
            return
        }
        guard let t = prefs.valueForKey("titles") as? NSArray else {
            print("Could not find existing titles")
            return
        }
        guard let m = prefs.valueForKey("summaries") as? NSArray else {
            print("Could not find existing summaries")
            return
        }
        
        texts = NSMutableArray(array: s)
        urls = NSMutableArray(array: u)
        titles = NSMutableArray(array: t)
        summaries = NSMutableArray(array: m)
        
        articleList.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SMArticleCell()
        cell.article = articleForIndex(indexPath.row)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let smvc = SMArticleSummaryController()
        smvc.article = articleForIndex(indexPath.row)
        self.presentViewController(smvc, animated: true, completion: nil)
    }
    
    // MARK: - Article manipulation methods
    func articleForIndex(i: Int) -> Article {
        return Article(
            text:       texts[i]        as! String,
            url:        urls[i]         as! String,
            title:      titles[i]       as! String,
            author:     "",
            summary:    summaries[i]    as! String
        )
    }
    
    func clearArticles() {
        texts = NSMutableArray()
        urls = NSMutableArray()
        titles = NSMutableArray()
        summaries = NSMutableArray()
        
        saveArticleValues()
        
        articleList.reloadData()
    }
    
    func saveArticleValues() {
        prefs.setValue(texts, forKey: "texts")
        prefs.setValue(urls, forKey: "urls")
        prefs.setValue(titles, forKey: "titles")
        prefs.setValue(summaries, forKey: "summaries")
    }
    
    func handleArticleRequest(url: String, completion: (() -> ())? = nil) {
        self.urls.addObject(url)
        
        var summaryDone = false
        var htmlDone = false
        
        let requestURL = "http://clipped.me/algorithm/clippedapi.php?url=" + url
        
        let checkForCompletion: (() -> ()) = {
            if summaryDone && htmlDone {
                self.saveArticleValues()
                dispatch_async(dispatch_get_main_queue(), {
                    completion?()
                })
            }
        }
        
        Alamofire.request(.GET, requestURL).response(
            completionHandler: { [unowned self]
                (request, response, data, error) in
                let json = JSON(data: data!)
                
                if let t = json["title"].string {
                    self.titles.addObject(t)
                }
                
                if let summary = json["summary"].array {
                    var text = ""
                    for item in summary {
                        text += "\u{2022} " + item.string! + "\n\n"
                    }
                    self.summaries.addObject(text)
                }
                
                summaryDone = true
                
                checkForCompletion()
            }
        )
        
        Alamofire.request(.GET, url).response(
            completionHandler: { [unowned self]
                (request, response, data, error) in
                guard error == nil else {
                    self.showErrorAlert()
                    return
                }
                
                self.texts.addObject(NSString(data: data!, encoding: NSASCIIStringEncoding)! as String)
                
                htmlDone = true
                
                checkForCompletion()
            }
        )
    }
    
}
