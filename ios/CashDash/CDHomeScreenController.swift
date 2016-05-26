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
    
    //views
    let navigationStack = UIStackView()
    
    func configureButtons() {
        
        
        cashBtn.setTitle("Cash", forState: .Normal)
        cashBtn.backgroundColor = UIColor.greenColor()
        dashBtn.setTitle("Dash", forState: .Normal)
        dashBtn.backgroundColor = UIColor.greenColor()
        sosBtn.setTitle("SOS", forState: .Normal)
        sosBtn.backgroundColor = UIColor.greenColor()
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = Int(screenSize.width)
        let screenHeight = Int(screenSize.height)
        
        cashBtn.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: 40)
        dashBtn.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: 40)
        
        navigationStack.addSubview(cashBtn)
        navigationStack.addSubview(dashBtn)
        navigationStack.axis = .Horizontal
        navigationStack.distribution = .FillEqually
        navigationStack.alignment = .Fill
        navigationStack.backgroundColor = UIColor.blackColor()
        
        
        
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
            
            "sb": sosBtn,
            
            "ns": navigationStack
        ]
        
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]-20-[ns]", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[ns]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[ns(==40)]", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[cb][db]|", views: viewsDict))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[cb(==40)]", views: viewsDict))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[db(==40)]", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[sb]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[sb(==40)]|", views: viewsDict))
        
    }
    
    func showAtmMap() {
        cashBtn.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.5)
    }
    
    func showSosMap() {
        
    }
    
    func startSosRequest() {
        print("yo")
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            self.sosBtn.setTitle("Request SOS", forState: .Normal)
            
            
            }, completion: { [unowned self] (complete) in
                
            })

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("hi")
    }

	
}
