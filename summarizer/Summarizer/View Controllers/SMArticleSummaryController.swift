//
//  SMArticleSummaryController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/21/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMArticleSummaryController: SMViewController {
    
    var article: Article! {
        didSet {
            summaryText.text = article.text
            
        }
    }
    
    private var titleLabel:         UILabel         = UILabel()
    private var authorLabel:        UILabel         = UILabel()
    private var hyperlink:          UIButton        = UIButton()
    private var summaryText:        UITextView      = UITextView()
    private var dismiss:            UIButton        = UIButton()
    
    override func configureViews() {
        super.configureViews()
        
        titleLabel.text = "Title: "
        
        authorLabel.text = "Author: "
        
        hyperlink.setTitle("Open in Safari", forState: .Normal)
        hyperlink.addTarget(self, action: "showInSafari", forControlEvents: .TouchUpInside)
        
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
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[tl]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[al]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[hl]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[st]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:[dm(==20)]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-20-[dm(==20)]", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-20-[tl]-10-[al]-10-[st]-10-[hl(==20)]-10-|", views: viewsDict))
    }
    
    func showInSafari() {
        UIApplication.sharedApplication().openURL(NSURL(string: article.url)!)
    }
    
    func hide() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
