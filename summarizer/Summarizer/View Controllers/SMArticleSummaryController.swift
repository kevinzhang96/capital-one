//
//  SMArticleSummaryController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/21/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SMArticleSummaryController: SMViewController {
    
    var article: Article! { didSet {
        getSummary(article.url)
        
        if let a = findAuthor(article.text) {
            authorLabel.text = "Author: " + a
        } else {
            authorLabel.text = "Author: None found"
        }
    } }
    
    private var titleLabel:         UILabel         = UILabel()
    private var authorLabel:        UILabel         = UILabel()
    private var hyperlink:          UIButton        = UIButton()
    private var summaryText:        UITextView      = UITextView()
    private var dismiss:            UIButton        = UIButton()
    
    override func configureViews() {
        super.configureViews()
        
        titleLabel.text = "Title: "
        titleLabel.font = UIFont.systemFontOfSize(10)
        titleLabel.numberOfLines = 0
        
        authorLabel.text = "Author: "
        authorLabel.font = UIFont.systemFontOfSize(10)
        authorLabel.numberOfLines = 0
        
        hyperlink.setTitle("Open article in Safari", forState: .Normal)
        hyperlink.addTarget(self, action: "showInSafari", forControlEvents: .TouchUpInside)
        hyperlink.titleLabel?.font = UIFont.systemFontOfSize(12)
        hyperlink.layer.borderColor = UIColor.whiteColor().CGColor
        hyperlink.layer.borderWidth = 2
        hyperlink.layer.cornerRadius = 5
        
        summaryText.font = UIFont.systemFontOfSize(10)
        summaryText.editable = false
        
        dismiss.setImage(UIImage(named: "exit"), forState: .Normal)
        dismiss.addTarget(self, action: "hide", forControlEvents: .TouchUpInside)
        
        let viewsDict = [
            "tl": titleLabel,
            "al": authorLabel,
            "hl": hyperlink,
            "st": summaryText,
            "dm": dismiss
        ]
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[tl]-50-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[al]-50-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[hl]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[st]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:[dm(==20)]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-20-[dm(==20)]", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-20-[tl]-10-[al]-10-[st]-10-[hl(==20)]-10-|", views: viewsDict))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        getBody(article.text)
    }
    
    func showInSafari() {
        UIApplication.sharedApplication().openURL(NSURL(string: article.url)!)
    }
    
    func hide() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func findTitle(s: String) -> String? {
        return s.getRegexCapture("<title>(.*)</title>")
    }
    
    func findAuthor(s: String) -> String? {
        return nil
    }
    
    func getBody(s: String) -> String? {
        let oneline = s.stringByReplacingOccurrencesOfString("\n", withString: "")
        let c = oneline.getRegexCapture("<body.*>(.*)</body>")
        return c
    }
    
    func getSummary(url: String) {
        let requestURL = "http://clipped.me/algorithm/clippedapi.php?url=" + url
        Alamofire.request(.GET, requestURL).response(
            completionHandler: { [unowned self]
                (request, response, data, error) in
                let json = JSON(data: data!)
                
                print(json)
                
                if let t = json["title"].string {
                    self.titleLabel.text = "Title: " + t
                }
                
                if let summary = json["summary"].array {
                    var text = ""
                    for item in summary {
                        text += "\u{2022} " + item.string! + "\n\n"
                    }
                    self.summaryText.text = text
                }
            }
        )
    }

}