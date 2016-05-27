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
import CoreLocation
import SwiftyJSON

enum CDHomeStage {
	case Cash
	case Dash
}

enum CDActiveAction {
	case CashPending
	case Cashing
	case DashInvite
	case Dashing
	case None
}

class CDHomeScreenController: CDBaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	// MARK: - Properties
	static let sharedInstance = CDHomeScreenController()
	static let screenSize = UIScreen.mainScreen().bounds
	let screenWidth = UIScreen.mainScreen().bounds.width
	let screenHeight = UIScreen.mainScreen().bounds.height
	
	let loc = CDLocationManager.sharedInstance
	var currentStage : CDHomeStage = .Cash
	var currentAction: CDActiveAction = .None
	
	// MARK: UI properties
	// buttons
	let bt_height: CGFloat = 40.0
	let bt_cash = UIButton()
	let bt_dash = UIButton()
	let bt_reqs = UIButton()
	let bt_acpt = UIButton()
	let bt_dcln = UIButton()
	
	// info panel
	var panel: UIView = UIView()
	var panel_phone: UIButton = UIButton()
	var panel_text: UITextView = UITextView()
	var panel_cancel: UIButton = UIButton()
	var panel_finish: UIButton = UIButton()
	
	// miscellaneous UI elements
	let map = MKMapView()
	let logo = UILabel()
	let cashAmt = UITextField()
	let navigationStack = UIStackView()
	
	// MARK: - Control flow methods
	func setState(stage: CDHomeStage) {
		cashAmt.resignFirstResponder()
		currentStage = stage
		panel.frame.origin.y = screenHeight
		
		switch stage {
		case .Cash:
			// TODO
			bt_cash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
			bt_dash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
			bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
			
			cashAmt.frame = CGRect(x: -screenWidth/2, y: screenHeight - bt_height, width: screenWidth/2, height: bt_height)
			
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth, height: self.bt_height)
				self.bt_acpt.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth/2, height: self.bt_height)
				self.bt_dcln.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight, width: self.screenWidth/2, height: self.bt_height)
			})
			
			// center map on current location
			guard let coors = loc.manager.location?.coordinate else {
				CDLog("No coordinates exist; unable to adjust map")
				return
			}
			
			let viewRegion = MKCoordinateRegionMakeWithDistance(coors, 2000, 2000)
			let adjustedRegion = map.regionThatFits(viewRegion)
			map.setRegion(adjustedRegion, animated: true)
			map.showsUserLocation = true
			
			break
		case .Dash:
			// TODO
			bt_dash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
			bt_cash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
			
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				self.bt_reqs.frame.origin = CGPoint(x: self.bt_reqs.frame.origin.x, y: self.screenHeight)
				self.cashAmt.frame.origin = CGPoint(x: self.cashAmt.frame.origin.x, y: self.screenHeight)
				self.bt_acpt.frame.origin = CGPointMake(0, self.screenHeight)
				self.bt_dcln.frame.origin = CGPointMake(self.screenWidth/2, self.screenHeight)
			}, completion: { [unowned self] (complete) in
				self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.bt_height)
				self.cashAmt.frame = CGRect(x: -self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
			})
			
			break
		}
	}
	func moveToCash() { setState(.Cash) }
	func moveToDash() { setState(.Dash) }
	
	func setActiveAction(act: CDActiveAction) {
		switch act {
		case .CashPending:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: {
				self.bt_cash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
				self.bt_dash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
				self.panel.frame.origin.y = self.screenHeight
				self.bt_acpt.frame.origin.y = self.screenHeight
				self.bt_dcln.frame.origin.y = self.screenHeight
				self.bt_reqs.frame.origin.y = self.screenHeight - self.bt_height
				self.cashAmt.frame.origin.y = self.screenHeight - self.bt_height
			})
		case .Cashing:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: {
				self.bt_cash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
				self.bt_dash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
				self.panel.frame.origin.y = self.screenHeight - self.panel.frame.size.height
				self.bt_acpt.frame.origin.y = self.screenHeight
				self.bt_dcln.frame.origin.y = self.screenHeight
				self.bt_reqs.frame.origin.y = self.screenHeight
				self.cashAmt.frame.origin.y = self.screenHeight
			})
		case .DashInvite:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: {
				self.bt_dash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
				self.bt_cash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
				self.panel.frame.origin.y = self.screenHeight
				self.bt_acpt.frame.origin.y = self.screenHeight - self.bt_height
				self.bt_dcln.frame.origin.y = self.screenHeight - self.bt_height
				self.bt_reqs.frame.origin.y = self.screenHeight
				self.cashAmt.frame.origin.y = self.screenHeight
			})
		case .Dashing:
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: {
				self.bt_dash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
				self.bt_cash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
				self.panel.frame.origin.y = self.screenHeight - self.panel.frame.size.height
				self.bt_acpt.frame.origin.y = self.screenHeight
				self.bt_dcln.frame.origin.y = self.screenHeight
				self.bt_reqs.frame.origin.y = self.screenHeight
				self.cashAmt.frame.origin.y = self.screenHeight
			})
		case .None:
			setState(currentStage)
		}
	}
	
	func hidePanel() {
		setActiveAction(.None)
		setState(currentStage)
	}
	
	func acceptCashRequest() {
		setActiveAction(.Dashing)
	}
	
	func declineCashRequest() {
		setActiveAction(.None)
	}
	
	// MARK: - UI configuration methods
	func configureButtons() {
		bt_cash.setTitle("Cash", forState: .Normal)
		bt_cash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		bt_cash.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: bt_height)
		
		bt_dash.setTitle("Dash", forState: .Normal)
		bt_dash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		bt_dash.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: bt_height)
		
		navigationStack.addSubview(bt_cash)
		navigationStack.addSubview(bt_dash)
		navigationStack.axis = .Horizontal
		navigationStack.distribution = .FillEqually
		navigationStack.alignment = .Fill
		navigationStack.backgroundColor = UIColor.blackColor()
		
		bt_reqs.setTitle("Request", forState: .Normal)
		bt_reqs.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		
		bt_acpt.setTitle("Accept", forState: .Normal)
		bt_acpt.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		bt_acpt.frame = CGRect(x: 0, y: screenHeight, width: screenWidth/2, height: bt_height)
		bt_acpt.addTarget(self, action: #selector(CDHomeScreenController.acceptCashRequest), forControlEvents: .TouchUpInside)
		
		bt_dcln.setTitle("Decline", forState: .Normal)
		bt_dcln.backgroundColor = UIColor(r: 203, g: 0, b: 0, a: 1)
		bt_dcln.frame = CGRect(x: screenWidth/2, y: screenHeight, width: screenWidth/2, height: bt_height)
		bt_dcln.addTarget(self, action: #selector(CDHomeScreenController.declineCashRequest), forControlEvents: .TouchUpInside)
		
		bt_cash.addTarget(self, action: #selector(CDHomeScreenController.moveToCash), forControlEvents: .TouchUpInside)
		bt_dash.addTarget(self, action: #selector(CDHomeScreenController.moveToDash), forControlEvents: .TouchUpInside)
		bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
		bt_acpt.addTarget(self, action: #selector(CDHomeScreenController.acceptCashRequest), forControlEvents: .TouchUpInside)
		bt_dcln.addTarget(self, action: #selector(CDHomeScreenController.declineCashRequest), forControlEvents: .TouchUpInside)
	}
	
	func configureLogo() {
		logo.text			= "CashDash"
		logo.textAlignment 	= .Center
		logo.font			= UIFont(name: "KaushanScript-Regular", size: 44)
		logo.textColor		= UIColor(r: 76, g: 173, b: 0, a: 1)
	}
	
	func configureFields() {
		cashAmt.placeholder				= "Amount"
		cashAmt.font					= UIFont.systemFontOfSize(18)
		cashAmt.textColor				= UIColor.whiteColor()
		cashAmt.keyboardType			= UIKeyboardType.NumberPad
		cashAmt.backgroundColor			= UIColor(r: 76, g: 173, b: 0, a: 1)
		cashAmt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
	}
	
	override func configureViews() {
		super.configureViews()
		configureLogo()
		configureFields()
		configureButtons()
		self.view.backgroundColor = UIColor.whiteColor()
		
		let viewsDict = [
			"logo": logo,
			"navs": navigationStack,
			"map": map,
		]
		self.view.prepareViewsForAutoLayout(viewsDict)
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[navs]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[map]|", views: viewsDict))
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]-20-[navs][map]|", views: viewsDict))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[navs(==40)]", views: viewsDict))
		
		self.view.addSubview(bt_reqs)
		self.view.addSubview(cashAmt)
		self.view.addSubview(bt_acpt)
		self.view.addSubview(bt_dcln)
		
		// panel configuration
		panel.frame = CGRectMake(0, screenHeight, screenWidth, 3 * bt_height)
		panel.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		
		panel_text.frame = CGRectMake(0, 0, screenWidth, 1.25 * bt_height)
		panel_text.textColor = UIColor.whiteColor()
		panel_text.textAlignment = .Center
		panel_text.font = UIFont.systemFontOfSize(18)
		
		panel_phone.frame = CGRectMake(0, 1.35 * bt_height, screenWidth, bt_height * 0.6)
		panel_phone.addTarget(self, action: #selector(CDHomeScreenController.callNumber), forControlEvents: .TouchUpInside)
		panel_phone.titleLabel?.font = UIFont.systemFontOfSize(18)
		
		panel_cancel.frame = CGRectMake(0, 2 * bt_height, screenWidth/2, bt_height)
		panel_cancel.setTitle("Cancel", forState: .Normal)
		panel_cancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		panel_cancel.addTarget(self, action: #selector(CDHomeScreenController.hidePanel), forControlEvents: .TouchUpInside)
		
		panel_finish.frame = CGRectMake(screenWidth/2, 2 * bt_height, screenWidth/2, bt_height)
		panel_finish.setTitle("Finish", forState: .Normal)
		panel_finish.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		panel_finish.addTarget(self, action: #selector(CDHomeScreenController.hidePanel), forControlEvents: .TouchUpInside)
		
		let _ = [panel_text, panel_phone, panel_cancel, panel_finish].map({
			panel.addSubview($0)
			$0.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		})
		panel_cancel.backgroundColor = UIColor(r: 203, g: 0, b: 0, a: 1)
		
		self.view.addSubview(panel)
		
		// -------- Nessie API GET Request --------
		guard let location = loc.manager.location else {
			CDLog("No location was found")
			return
		}
		let lat = String(location.coordinate.latitude)
		let long = String(location.coordinate.longitude)
		
		// construct URL request
		let urlString = "http://api.reimaginebanking.com/atms?key=" + NESSIE_API_KEY + "&lat=" + lat + "&lng=" + long + "&rad=1.0"
		let url = NSURL(string: urlString)
		
		// make request to Nessie API
		let task = NSURLSession.sharedSession().dataTaskWithURL(url!){ [unowned self] (data, response, error) in
			//Add markers for nearby ATM's
			guard let d = data else {
				CDLog("Unable to retrieve data from Nessie API")
				return
			}
			let json = JSON(data: d)
			var annotations = [MKAnnotation]()
			
			for (_, subJSON):(String, JSON) in json["data"] {
				let annotation = MKPointAnnotation()
				annotation.coordinate.latitude = subJSON["geocode"]["lat"].double!
				annotation.coordinate.longitude = subJSON["geocode"]["lng"].double!
				annotation.title = subJSON["name"].string!
				annotations.append(annotation)
			}
			self.map.addAnnotations(annotations)
		}
		task.resume()
	}
	
	// MARK: - Map navigation functions
	func handlePush(data : [String:String]) {
		let annotation = MKPointAnnotation()
		annotation.coordinate.latitude = Double(data["latitude"]!)!
		annotation.coordinate.longitude = Double(data["longitude"]!)!
		annotation.title = data["username"]!
		annotation.subtitle = "Needs $" + data["cash"]! + "\nPhone #: " + data["phone"]!
		self.map.addAnnotation(annotation)
		
		panel_phone.setTitle(data["phone"]!, forState: .Normal)
		panel_text.text = data["name"]! + ": " + data["username"]! + "\n" + "Transaction amount: " + data["cash"]!
		
		if data["username"] != CDAuthenticationConstants.username {
			if data["cashordash"]! == "dash" {
				setActiveAction(.Cashing)
			} else {
				setActiveAction(.DashInvite)
			}
		}
	}
	
	func sendCashRequest() {
		cashAmt.resignFirstResponder()
		setActiveAction(.CashPending)
		
		UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
			self.bt_reqs.setTitle("Requesting...", forState: .Normal)
			self.bt_reqs.backgroundColor = UIColor(r: 204, g: 0, b: 0, a: 1)
			self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth, height: self.bt_height)
			self.cashAmt.frame.origin.x = -self.screenWidth/2
			// CGRect(x: -self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
		}, completion: { [unowned self] (complete) in
			self.bt_reqs.removeTarget(self, action: #selector(CDHomeScreenController.sendCashRequest), forControlEvents: .TouchUpInside)
			self.bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
		})
	}
	
	func showCashTextField() {
		setActiveAction(.None)
		UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
			self.bt_reqs.setTitle("Request", forState: .Normal)
			self.bt_reqs.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
			self.bt_reqs.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
			self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
		}, completion: { [unowned self] (complete) in
			self.bt_reqs.removeTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
			self.bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.sendCashRequest), forControlEvents: .TouchUpInside)
		})
	}
	
	func adjustingHeight(show:Bool, notification:NSNotification) {
		UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { () -> Void in
			if (show) {
				var userInfo = notification.userInfo!
				let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
				let changeInHeight = (CGRectGetHeight(keyboardFrame) + self.bt_height)
				self.bt_reqs.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - changeInHeight, width: self.screenWidth/2, height: self.bt_height)
				self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - changeInHeight, width: self.screenWidth/2, height: self.bt_height)
			} else {
				self.bt_reqs.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
				self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
			}
		})
	}
	
	func callNumber(sender: UIButton) {
		let uri = "tel://" + sender.titleLabel!.text!
		UIApplication.sharedApplication().openURL(NSURL(string: uri)!)
	}
	
	// MARK: - MKMapViewDelegate methods
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		CDLog("map view clicked")
		if (currentStage == .Dash) {
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				self.bt_acpt.frame   = CGRect(
					x:		0,
					y:		self.screenHeight - self.bt_height,
					width:	self.screenWidth/2,
					height:	self.bt_height
				)
				self.bt_dcln.frame  = CGRect(
					x:		self.screenWidth/2,
					y:		self.screenHeight - self.bt_height,
					width:	self.screenWidth/2,
					height:	self.bt_height
				)
			})
		}
	}
	
	// MARK: - UIViewController methods
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		map.delegate = self
		setState(.Cash)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		cashAmt.resignFirstResponder()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDHomeScreenController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDHomeScreenController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	// adjust button heights
	func keyboardWillShow(notification:NSNotification) {
		adjustingHeight(true, notification: notification)
	}
	func keyboardWillHide(notification:NSNotification) {
		adjustingHeight(false, notification: notification)
	}
}