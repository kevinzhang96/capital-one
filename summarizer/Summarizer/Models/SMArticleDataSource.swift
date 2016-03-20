//
//  SMArticleDataSource.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMArticleDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = SMArticleDataSource()
    
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
        print("New article")
    }
}