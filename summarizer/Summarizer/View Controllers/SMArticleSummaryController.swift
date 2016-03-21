//
//  SMArticleSummaryController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/21/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMArticleSummaryController: SMViewController {
    
    var text: String!
    
    private var titleLabel: UILabel = UILabel()
    private var authorLabel: UILabel = UILabel()
    private var summaryText: UITextView = UITextView()
    
    override func configureViews() {
        super.configureViews()
        
        titleLabel.text = "Title: "
        
        authorLabel.text = "Author: "
        
        summaryText.text = self.text
        
        let viewsDict = [
            "tl": titleLabel,
            "al": authorLabel,
            "st": summaryText
        ]
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[tl]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[al]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[st]-20-|", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-20-[tl]-10-[al]-10-[st]-20-|", views: viewsDict))
    }

}
