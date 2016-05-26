//
//  CDHomeScreenController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CDHomeScreenController: CDBaseViewController {
	
    static let screenSize = UIScreen.mainScreen().bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height

    //buttons
    let cashBtn = UIButton()
    let dashBtn = UIButton()
    let sosBtn = UIButton()
    
    //labels
    let logo = UILabel()
    
    //text fields
    let cashAmt = UITextField()
    
    //views
    let navigationStack = UIStackView()
    
    //maps
    let atmMap = MKMapView()
    let sosMap = MKMapView()
    
    func configureButtons() {
        
        
        cashBtn.setTitle("Cash", forState: .Normal)
        cashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        dashBtn.setTitle("Dash", forState: .Normal)
        dashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        sosBtn.setTitle("SOS", forState: .Normal)
        sosBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        
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
        super.configureViews()
        
		self.view.backgroundColor = UIColor.whiteColor()
        
        logo.text = "Cash Dash"
        logo.textAlignment = .Center
        logo.font = UIFont.systemFontOfSize(30)
        
        configureButtons()
        
        let viewsDict = [
            "logo": logo,
            
//            "sb": sosBtn,
            
            "ns": navigationStack,
            
            "am": atmMap,
        ]
        
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]-20-[ns][am]|", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[am(==120)]", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[am]|", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[ns]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[ns(==40)]", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[cb][db]|", views: viewsDict))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[cb(==40)]", views: viewsDict))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[db(==40)]", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]", views: viewsDict))
        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[sb]|", views: viewsDict))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[sb(==40)]|", views: viewsDict))
        
        self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight - 40, width: self.screenWidth, height: 40)
        self.view.addSubview(sosBtn)
        
    }
    
    func showAtmMap() {
        cashBtn.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
        dashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        
        //Show atm markers
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            //self.sosBtn.setTitle("Request SOS", forState: .Normal)
            self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight - 40, width: self.screenWidth, height: 40)
            
            }, completion: { [unowned self] (complete) in
                
            })

    }
    
    func showSosMap() {
        dashBtn.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
        cashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        
        //Show users in area
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            //self.sosBtn.setTitle("Request SOS", forState: .Normal)
            self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: 40)
            
            }, completion: { [unowned self] (complete) in
                
            })
    }
    
    func startSosRequest() {
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            self.sosBtn.setTitle("Request SOS", forState: .Normal)
            self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight - 120, width: self.screenWidth, height: 40)
            
            }, completion: { [unowned self] (complete) in
                
            })

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        showAtmMap()
    }

	
}
