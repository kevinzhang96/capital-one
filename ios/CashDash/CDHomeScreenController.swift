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

class CDHomeScreenController: CDBaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	// MARK: - Properties
	static let sharedInstance = CDHomeScreenController()
	static let screenSize = UIScreen.mainScreen().bounds
	let screenWidth = UIScreen.mainScreen().bounds.width
	let screenHeight = UIScreen.mainScreen().bounds.height
	
	let loc = CDLocationManager.sharedInstance
	var currentStage : CDHomeStage = .Cash
	
	// MARK: UI properties
	// buttons
	let bt_height: CGFloat = 40.0
	let bt_cash = UIButton()
	let bt_dash = UIButton()
	let bt_reqs = UIButton()
	let bt_acpt = UIButton()
	let bt_dcln = UIButton()
	
	let map = MKMapView()
	let logo = UILabel()
	let cashAmt = UITextField()
	let navigationStack = UIStackView()
	
	// MARK: - Control flow methods
	func setState(stage: CDHomeStage) {
		cashAmt.resignFirstResponder()
		currentStage = stage
		
		switch stage {
		case .Cash:
			// TODO
			bt_cash.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
			bt_dash.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
			
//			bt_reqs.frame = CGRect(x: 0, y: screenHeight - bt_height, width: screenWidth, height: bt_height)
			cashAmt.frame = CGRect(x: -screenWidth/2, y: screenHeight - bt_height, width: screenWidth/2, height: bt_height)
			
			bt_reqs.setTitle("SOS", forState: .Normal)
			// TODO: REMOVE TARGETS
			bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
			
			UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
				self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth, height: self.bt_height)
			})
			
			CDLog(bt_reqs.frame)
			
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
				// CGRect(x: self.screenWidth, y: self.screenHeight, width: self.screenWidth/2, height: self.bt_height)
				self.cashAmt.frame.origin = CGPoint(x: self.cashAmt.frame.origin.x, y: self.screenHeight)
				// CGRect(x: 0, y: self.screenHeight, width: self.screenWidth/2, height: self.bt_height)
			}, completion: { [unowned self] (complete) in
				self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.bt_height)
				self.cashAmt.frame = CGRect(x: -self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
			})
			
			break
		}
	}
	func moveToCash() { setState(.Cash) }
	func moveToDash() { setState(.Dash) }
	
	func acceptCashRequest() {
		// TODO
	}
	
	func declineCashRequest() {
		// TODO
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
		
		bt_reqs.setTitle("SOS", forState: .Normal)
		bt_reqs.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
		
		bt_acpt.setTitle("Accept", forState: .Normal)
		bt_acpt.backgroundColor = UIColor(r: 173, g: 76, b: 0, a: 1)
		bt_acpt.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: bt_height)
		
		bt_dcln.setTitle("Decline", forState: .Normal)
		bt_dcln.backgroundColor = UIColor(r: 173, g: 76, b: 0, a: 1)
		bt_dcln.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: bt_height)
		
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
		cashAmt.placeholder				= "Enter cash amount"
		cashAmt.font					= UIFont.systemFontOfSize(20)
		cashAmt.textColor				= UIColor.blackColor()
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
		
		// -------- Nessie API GET Request --------
		guard let location = loc.manager.location else {
			CDLog("No location was found")
			return
		}
		let lat = String(location.coordinate.latitude)
		let long = String(location.coordinate.longitude)
		
		// construct URL request
		let urlString = "http://api.reimaginebanking.com/atms?key=" + NESSIE_API_KEY + "&lat=" + lat + "&lng=" + long + "&rad=0.5"
		let url = NSURL(string: urlString)
		
		// make request to Nessie API
		let task = NSURLSession.sharedSession().dataTaskWithURL(url!){ [unowned self] (data, response, error) in
			//Add markers for nearby ATM's
			let json = JSON(data: data!)
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
	}
	
	func sendCashRequest() {
		cashAmt.resignFirstResponder()
		
		UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
			self.bt_reqs.setTitle("SOS", forState: .Normal)
			self.bt_reqs.frame = CGRect(x: 0, y: self.screenHeight - self.bt_height, width: self.screenWidth, height: self.bt_height)
			self.cashAmt.frame = CGRect(x: -self.screenWidth/2, y: self.screenHeight - self.bt_height, width: self.screenWidth/2, height: self.bt_height)
		}, completion: { [unowned self] (complete) in
			self.bt_reqs.removeTarget(self, action: #selector(CDHomeScreenController.sendCashRequest), forControlEvents: .TouchUpInside)
			self.bt_reqs.addTarget(self, action: #selector(CDHomeScreenController.showCashTextField), forControlEvents: .TouchUpInside)
		})
	}
	
	func showCashTextField() {
		UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
			self.bt_reqs.setTitle("Request SOS", forState: .Normal)
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