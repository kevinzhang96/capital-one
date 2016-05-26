//
//  CDLoginViewController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse

class CDLoginViewController: CDBaseViewController {
	
	static let sharedInstance = CDBaseViewController()
	
	enum CDLoginStage {
		case Venmo
		case Fields
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
//		let labels_stage1 = [l_venmo]
//		let labels_stage2 = labels.filter({ return labels_stage1.contains($0) })
		
		let _ = labels.map({
			// configure labels here
			$0.font = UIFont.systemFontOfSize(24)
			$0.textColor = UIColor.blackColor()
			$0.textAlignment = .Center
		})
		
		logo.text = "CashDash"
		logo.textAlignment = .Center
		logo.font = UIFont.systemFontOfSize(30)
		
		l_venmo.text = "Venmo username"
		l_fname.text = "First name"
		l_lname.text = "Last name"
		l_phone.text = "Phone number"
		l_pass1.text = "Password"
		l_pass2.text = "Confirm"
	}
	
	// configure fields for the view
	func configureFields() {
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
//		let fields_stage1 = [tf_venmo]
//		let fields_stage2 = fields.filter({ return fields_stage1.contains($0) })
		
		let _ = fields.map({
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
	
	func moveToStage(stage: CDLoginStage) {
		let labels = [l_venmo, l_fname, l_lname, l_phone, l_pass1, l_pass2, l_confirm]
		let labels_stage1 = [l_venmo]
		let labels_stage2 = labels.filter({ return !labels_stage1.contains($0) })
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		let fields_stage1 = [tf_venmo]
		let fields_stage2 = fields.filter({ return !fields_stage1.contains($0) })
		
		switch stage {
		case .Venmo:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				let _ = labels_stage1.map({ $0.alpha = 1.0 })
				let _ = fields_stage1.map({ $0.alpha = 1.0 })
				let _ = labels_stage2.map({ $0.alpha = 0.0 })
				let _ = fields_stage2.map({ $0.alpha = 0.0 })
				
				self.nextButton.setTitle("Next", forState: .Normal)
				self.nextButton.backgroundColor = UIColor.blueColor()
			}, completion: { [unowned self] (complete) in
				let _ = labels_stage1.map({ $0.userInteractionEnabled = true })
				let _ = fields_stage1.map({ $0.userInteractionEnabled = true })
				let _ = labels_stage2.map({ $0.userInteractionEnabled = false })
				let _ = fields_stage2.map({ $0.userInteractionEnabled = false })
				
				self.nextButton.removeTarget(self, action: #selector(self.verify), forControlEvents: .TouchUpInside)
				self.nextButton.addTarget(self, action: #selector(self.moveToConfirm), forControlEvents: .TouchUpInside)
			})
			
			break
		case .Fields:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				let _ = labels_stage2.map({ $0.alpha = 1.0 })
				let _ = fields_stage2.map({ $0.alpha = 1.0 })
				let _ = labels_stage1.map({ $0.alpha = 0.0 })
				let _ = fields_stage1.map({ $0.alpha = 0.0 })
				
				self.nextButton.setTitle("Register", forState: .Normal)
				self.nextButton.backgroundColor = UIColor.greenColor()
			}, completion: { [unowned self] (complete) in
				let _ = labels_stage2.map({ $0.userInteractionEnabled = true })
				let _ = fields_stage2.map({ $0.userInteractionEnabled = true })
				let _ = labels_stage1.map({ $0.userInteractionEnabled = false })
				let _ = fields_stage1.map({ $0.userInteractionEnabled = false })
				
				self.nextButton.removeTarget(self, action: "moveToConfirm", forControlEvents: .TouchUpInside)
				self.nextButton.addTarget(self, action: "verify", forControlEvents: .TouchUpInside)
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
			print("No first name")
			return
		}
		guard tf_last.text != nil && tf_last.text! != "" else {
			print("No last name")
			return
		}
		guard tf_pass1.text != nil && tf_pass1.text! != "" else {
			print("No password")
			return
		}
		guard tf_pass2.text != nil && tf_pass2.text! != "" else {
			print("No password confirmation")
			return
		}
		guard tf_phone.text != nil && tf_phone.text! != "" else {
			print("No phone number")
			return
		}
		guard tf_pass1.text! == tf_pass2.text! else {
			print("Passwords don't match")
			return
		}
		
		let new_user = PFUser()
		new_user.username = tf_venmo.text!
		new_user.password = tf_pass1.text!
		new_user["first_name"] = tf_first.text!
		new_user["last_name"] = tf_last.text!
		new_user["phone"] = Int(tf_phone.text!)
		
		new_user.signUpInBackgroundWithBlock { [unowned self] (success, error) in
			guard error == nil else {
				print("Login in the background failed with error \(error!.localizedDescription)")
				return
			}
			
			NSUserDefaults.standardUserDefaults().setValue(self.tf_venmo.text!, forKey: "username")
			NSUserDefaults.standardUserDefaults().setValue(self.tf_pass1.text!, forKey: "password")
		}
	}
	
	func dismissKeyboard() {
		let fields = [tf_venmo, tf_first, tf_last, tf_phone, tf_pass1, tf_pass2]
		let _ = fields.map({ $0.resignFirstResponder() })
	}
	
	// MARK: - Configure views for project
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
			
//			"lv": l_venmo,
//			"lf": l_fname,
//			"ll": l_lname,
//			"lph": l_phone,
//			"lp1": l_pass1,
//			"lp2": l_pass2,
//			"lcf": l_confirm,
			
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
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		moveToStage(.Venmo)
		
		CDLocationManager.sharedInstance.requestPermissions()
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
	
}