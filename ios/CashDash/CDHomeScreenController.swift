//
//  CDHomeScreenController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse

class CDHomeScreenController: CDBaseViewController {
	
    //buttons
    let cashBtn = UIButton()
    let dashBtn = UIButton()
    let sosBtn = UIButton()
    
    //labels
    let logo = UILabel()
    
    func configureButtons() {
        
        
        cashBtn.setTitle("Cash", forState: .Normal)
        dashBtn.setTitle("Dash", forState: .Normal)
        sosBtn.setTitle("SOS", forState: .Normal)
        
        cashBtn.addTarget(self, action: #selector(CDHomeScreenController.showAtmMap), forControlEvents: .TouchUpInside)
        dashBtn.addTarget(self, action: #selector(CDHomeScreenController.showSosMap), forControlEvents: .TouchUpInside)
        sosBtn.addTarget(self, action: #selector(CDHomeScreenController.startSosRequest), forControlEvents: .TouchUpInside)
    }
    
    override func configureViews() {
		CDParseInterface.logout()
        super.configureViews()
        
		self.view.backgroundColor = UIColor.whiteColor()
        
        logo.text = "Cash Dash"
        logo.textAlignment = .Center
        logo.font = UIFont.systemFontOfSize(30)
        
        configureButtons()
        
        let viewsDict = [
            "logo": logo,
            
            "cb": cashBtn,
            "db": dashBtn,
            "sb": sosBtn
        ]
        
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|[logo(==40)]", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[sb]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[sb(==40)]|", views: viewsDict))
    }
    
    func showAtmMap() {
        
    }
    
    func showSosMap() {
        
    }
    
    func startSosRequest() {
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            self.sosBtn.setTitle("Request SOS", forState: .Normal)
            
            
            }, completion: { [unowned self] (complete) in
                
            })

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

	
}
