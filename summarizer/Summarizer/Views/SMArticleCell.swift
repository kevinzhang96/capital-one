//
//  SMArticleCell.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMArticleCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
