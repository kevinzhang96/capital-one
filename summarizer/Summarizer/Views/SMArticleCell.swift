//
//  SMArticleCell.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMArticleCell: UITableViewCell {
    
    var articleText: String! = nil
    private var titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(text: String) {
        self.init(style: .Default, reuseIdentifier: nil)
        articleText = text
        
        titleLabel.text = text
        titleLabel.font = UIFont.systemFontOfSize(10)
        titleLabel.numberOfLines = 0
        
        let viewsDict = [
            "tl": titleLabel
        ]
        self.contentView.prepareViewsForAutoLayout(viewsDict)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-10-[tl]-10-|", views: viewsDict))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-5-[tl]-5-|", views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
