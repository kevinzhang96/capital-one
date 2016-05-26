//
//  CDLoginViewController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit

class CDLoginViewController: CDBaseViewController {
	
	static let sharedInstance = CDBaseViewController()
	
	enum CDLoginStage {
		case Venmo
		case Fields
		case Confirm
	}
	var currentStage: CDLoginStage = .Venmo
	
	// buttons
	let nextButton = UIButton()
	
	// labels
	let logo = UILabel()
	let l_venmo = UILabel()
	let l_fname = UILabel()
	let l_lname = UILabel()
	let l_phone = UILabel()
	let l_pass1 = UILabel()
	let l_pass2 = UILabel()
	let l_confirm = UILabel()
	
	// text fields
	let tf_venmo = UITextField()
	let tf_first = UITextField()
	let tf_last  = UITextField()
	let tf_phone = UITextField()
	let tf_pass1 = UITextField()
	let tf_pass2 = UITextField()
	
	// configure labels for the view
	func configureLabels() {
		let labels = [l_venmo, l_fname, l_lname, l_phone, l_pass1, l_pass2, l_confirm]
		
		let _ = labels.map({
			// configure labels here
			$0.font = UIFont.systemFontOfSize(12)
			$0.textColor = UIColor.blackColor()
		})
	}
	
	// configure fields for the view
	func configureFields() {
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		
		let _ = fields.map({
			// configure fields here
			$0.font = UIFont.systemFontOfSize(12)
			$0.textColor = UIColor.blackColor()
		})
		
		tf_venmo.placeholder = "Venmo username"
		tf_first.placeholder = "First name"
		tf_last.placeholder = "Last name"
		tf_phone.placeholder = "Phone number"
		tf_pass1.placeholder = "Password"
		tf_pass2.placeholder = "Confirm"
	}
	
	func moveToStage(stage: CDLoginStage) {
		switch stage {
		case .Venmo:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: {
				
			}, completion: { (complete) in
					
			})
			
			break
		case .Fields:
			
			break
		case .Confirm:
			
			break
		}
	}
	
	// MARK: - Configure views for project
	override func configureViews() {
		super.configureViews()
		configureLabels()
		configureFields()
		
		let viewsDict = [
			"lv": l_venmo,
			"lf": l_fname,
			"ll": l_lname,
			"lph": l_phone,
			"lp1": l_pass1,
			"lp2": l_pass2,
			"lcf": l_confirm,
			
			"tfv":  tf_venmo,
			"tff":  tf_first,
			"tfl":  tf_last,
			"tfph": tf_phone,
			"tfp1": tf_pass1,
			"tfp2": tf_pass2,
			
			"nb": nextButton
		]
		self.view.prepareViewsForAutoLayout(viewsDict)
		
		
		
		//		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[al]|", views: viewsDict))
		//		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-60-[al]|", views: viewsDict))
		//		
		//		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[nb]|", views: viewsDict))
		//		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|[nb(==60)]", views: viewsDict))
	}
	
}