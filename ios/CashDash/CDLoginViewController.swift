//
//  CDLoginViewController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse

// Login stages
enum CDLoginStage {
	case Venmo
	case Fields
}

class CDLoginViewController: CDBaseViewController {
	
	// MARK: - Properties
	static let sharedInstance = CDBaseViewController()
	
	var currentStage: CDLoginStage = .Venmo
	let nextButton = UIButton()
	let logo = UILabel()
	
	// text fields
	let tf_venmo = UITextField()
	let tf_first = UITextField()
	let tf_last  = UITextField()
	let tf_phone = UITextField()
	let tf_pass1 = UITextField()
	let tf_pass2 = UITextField()
	
	// MARK: - UI configuration methods
	func configureLabels() {
		logo.text = "CashDash"
		logo.textAlignment = .Center
		logo.font = UIFont.systemFontOfSize(30)
	}
	
	func configureFields() {
		let _ = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2].map({
			// configure fields here
			$0.font = UIFont.systemFontOfSize(20)
			$0.textColor = UIColor.blackColor()
			$0.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		})
		
		tf_venmo.placeholder = "Venmo username"
		tf_first.placeholder = "First name"
		tf_last.placeholder  = "Last name"
		tf_phone.placeholder = "Phone number"
		tf_pass1.placeholder = "Password"
		tf_pass2.placeholder = "Confirm"
	}
	
	override func configureViews() {
		super.configureViews()
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
		
		tf_pass1.secureTextEntry = true
		tf_pass2.secureTextEntry = true
		
		configureLabels()
		configureFields()
		
		let viewsDict = [
			"logo": logo,
			
			"tfv":  tf_venmo,
			"tff":  tf_first,
			"tfl":  tf_last,
			"tfph": tf_phone,
			"tfp1": tf_pass1,
			"tfp2": tf_pass2,
			
			"nb": nextButton
		]
		self.view.prepareViewsForAutoLayout(viewsDict)
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tfv]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tff]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tfl]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tfph]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tfp1]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[tfp2]|", views: viewsDict))
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[logo(==40)]", views: viewsDict))
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tfv(==40)]", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tff(==40)]", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tfl(==40)]", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tfph(==40)]", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tfp1(==40)]", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[tfp2(==40)]", views: viewsDict))
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo]-100-[tfv]", views: viewsDict))
		self.view.addConstraints(
			NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo]-40-[tff]-10-[tfl]-10-[tfph]-10-[tfp1]-10-[tfp2]",
			views: viewsDict)
		)
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[nb]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[nb(==40)]|", views: viewsDict))
	}
	
	// MARK: - UIViewController methods
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		moveToStage(.Venmo)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		let _ = fields.map({
			let bottomBorder = CALayer()
			bottomBorder.frame = CGRectMake(-10, $0.frame.size.height - 1, $0.frame.size.width, 1)
			bottomBorder.backgroundColor = UIColor.blackColor().CGColor
			$0.layer.addSublayer(bottomBorder)
		})
	}
	
	// MARK: - Control flow methods
	func moveToStage(stage: CDLoginStage) {
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		let fields_stage1 = [tf_venmo]
		let fields_stage2 = fields.filter({ return !fields_stage1.contains($0) })
		
		switch stage {
		case .Venmo:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				let _ = fields_stage1.map({ $0.alpha = 1.0 })
				let _ = fields_stage2.map({ $0.alpha = 0.0 })
				
				self.nextButton.setTitle("Next", forState: .Normal)
				self.nextButton.backgroundColor = UIColor.blueColor()
				}, completion: { [unowned self] (complete) in
					let _ = fields_stage1.map({ $0.userInteractionEnabled = true })
					let _ = fields_stage2.map({ $0.userInteractionEnabled = false })
					
					self.nextButton.removeTarget(self, action: #selector(self.verify), forControlEvents: .TouchUpInside)
					self.nextButton.addTarget(self, action: #selector(self.moveToConfirm), forControlEvents: .TouchUpInside)
				})
			
			break
		case .Fields:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				let _ = fields_stage2.map({ $0.alpha = 1.0 })
				let _ = fields_stage1.map({ $0.alpha = 0.0 })
				
				self.nextButton.setTitle("Register", forState: .Normal)
				self.nextButton.backgroundColor = UIColor.greenColor()
				}, completion: { [unowned self] (complete) in
					let _ = fields_stage2.map({ $0.userInteractionEnabled = true })
					let _ = fields_stage1.map({ $0.userInteractionEnabled = false })
					
					self.nextButton.removeTarget(self, action: #selector(self.moveToConfirm), forControlEvents: .TouchUpInside)
					self.nextButton.addTarget(self, action: #selector(self.verify), forControlEvents: .TouchUpInside)
				})
			
			break
		}
	}
	
	func moveToConfirm() {
		if tf_venmo.text != nil && tf_venmo.text! != "" {
			moveToStage(.Fields)
		}
	}
	
	func verify() {
		guard tf_first.text != nil && tf_first.text! != "" else {
			CDLog("No first name")
			return
		}
		guard tf_last.text != nil && tf_last.text! != "" else {
			CDLog("No last name")
			return
		}
		guard tf_pass1.text != nil && tf_pass1.text! != "" else {
			CDLog("No password")
			return
		}
		guard tf_pass2.text != nil && tf_pass2.text! != "" else {
			CDLog("No password confirmation")
			return
		}
		guard tf_phone.text != nil && tf_phone.text! != "" else {
			CDLog("No phone number")
			return
		}
		guard tf_pass1.text! == tf_pass2.text! else {
			CDLog("Passwords don't match")
			return
		}
		
		let un = tf_venmo.text!
		let pw = tf_pass1.text!
		let ph = tf_phone.text!
		let fr = tf_first.text!
		let ls = tf_last.text!
		
		CDParseInterface.register(un, pw: pw, phone: Int(ph)!, first: fr, last: ls, completion: {
			self.presentViewController(CDHomeScreenController.sharedInstance, animated: true, completion: nil)
		})
	}
	
	func dismissKeyboard() {
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		let _ = fields.map({ $0.resignFirstResponder() })
	}
	
}