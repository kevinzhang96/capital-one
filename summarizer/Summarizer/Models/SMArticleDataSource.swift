//
//  SMArticleDataSource.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SMArticleDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = SMArticleDataSource()
    
    private var urlField: UITextField!
    private lazy var addAlert: UIAlertController = { [unowned self] in
        let alert = UIAlertController(title: "Add an article", message: "Enter an article URL here", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Add", style: .Default, handler: { [unowned self] (action) in
            self.handleArticleRequest(self.urlField.text!)
        })
        alert.addAction(action)
        alert.addTextFieldWithConfigurationHandler(self.addTextField)
        alert.view.setNeedsLayout()
        return alert
    }()
    private lazy var errorAlert: UIAlertController = { [unowned self] in
        let alert = UIAlertController(title: "Add an article", message: "URL was invalid, try again!", preferredStyle:  .Alert)
        let action = UIAlertAction(title: "Add", style: .Default, handler: { [unowned self] (action) in
            self.handleArticleRequest(self.urlField.text!)
        })
        alert.addAction(action)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        alert.addTextFieldWithConfigurationHandler(self.addTextField)
        alert.view.setNeedsLayout()
        return alert
    }()
    
    func addTextField(textField: UITextField!) {
        textField.placeholder = "URL"
        self.urlField = textField
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return SMArticleCell()
    }
    
    func addNewArticle() {
        let rvc = UIApplication.sharedApplication().keyWindow?.rootViewController
        rvc?.presentViewController(addAlert, animated: true, completion: nil)
    }
    
    func handleArticleRequest(url: String) {
        Alamofire.request(.GET, url).response { [unowned self] (request, response, data, error) in
            if (error != nil) {
                let rvc = UIApplication.sharedApplication().keyWindow?.rootViewController
                rvc?.presentViewController(self.errorAlert, animated: true, completion: nil)
            }
            print(request)
            print(response)
            let html = String(data: data!, encoding: NSASCIIStringEncoding)
            print(html)
            print(error)
        }
    }
}