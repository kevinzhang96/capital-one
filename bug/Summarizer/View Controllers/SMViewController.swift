//
//  SMViewController.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class SMViewController: UIViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        configureViews()
    }
    
    func configureViews() {
        self.view.backgroundColor = SMConstants.bgColor1
    }
    
}