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

class CDHomeScreenController: CDBaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	static let sharedInstance = CDHomeScreenController()
    static let screenSize = UIScreen.mainScreen().bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    
    enum CDHomeStage {
        case cash
        case dash
    }
    
    var currentStage : CDHomeStage = .dash
    
    //location management
    let CDLocManager = CDLocationManager.sharedInstance

    //buttons
    let cashBtn = UIButton()
    let dashBtn = UIButton()
    let sosBtn = UIButton()
    let acceptBtn = UIButton()
    let declineBtn = UIButton()
    let uiHeight = CGFloat(floatLiteral: 40.0)
    
    //labels
    let logo = UILabel()
    
    //text fields
    let cashAmt = UITextField()
    
    //stacks
    let navigationStack = UIStackView()
    
    //maps
    let atmMap = MKMapView()
    let sosMap = MKMapView()
    
    func configureButtons() {
        
        cashBtn.setTitle("Cash", forState: .Normal)
        cashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        cashBtn.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: uiHeight)
        
        dashBtn.setTitle("Dash", forState: .Normal)
        dashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        dashBtn.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: uiHeight)
        
        navigationStack.addSubview(cashBtn)
        navigationStack.addSubview(dashBtn)
        navigationStack.axis = .Horizontal
        navigationStack.distribution = .FillEqually
        navigationStack.alignment = .Fill
        navigationStack.backgroundColor = UIColor.blackColor()
        
        sosBtn.setTitle("SOS", forState: .Normal)
        sosBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
        
        acceptBtn.setTitle("Accept", forState: .Normal)
        acceptBtn.backgroundColor = UIColor(r: 173, g: 76, b: 0, a: 1)
        acceptBtn.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: uiHeight)
        
        declineBtn.setTitle("Decline", forState: .Normal)
        declineBtn.backgroundColor = UIColor(r: 173, g: 76, b: 0, a: 1)
        declineBtn.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: uiHeight)
        
        cashBtn.addTarget(self, action: #selector(CDHomeScreenController.showAtmMap), forControlEvents: .TouchUpInside)
        dashBtn.addTarget(self, action: #selector(CDHomeScreenController.showSosMap), forControlEvents: .TouchUpInside)
        sosBtn.addTarget(self, action: #selector(CDHomeScreenController.showTextFieldForSos), forControlEvents: .TouchUpInside)
        acceptBtn.addTarget(self, action: #selector(CDHomeScreenController.acceptSosRequest), forControlEvents: .TouchUpInside)
        declineBtn.addTarget(self, action: #selector(CDHomeScreenController.declineSosRequest), forControlEvents: .TouchUpInside)
    }
    
    func configureLabels() {
        logo.text = "Cash Dash"
        logo.textAlignment = .Center
        logo.font = UIFont.systemFontOfSize(30)
    }
    
    func configureFields() {
        cashAmt.font = UIFont.systemFontOfSize(20)
        cashAmt.textColor = UIColor.blackColor()
        cashAmt.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        cashAmt.keyboardType = UIKeyboardType.NumberPad
        
        cashAmt.placeholder = "Enter cash amount"
        cashAmt.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
    }
    
    override func configureViews() {

        super.configureViews()
        
		self.view.backgroundColor = UIColor.whiteColor()
        
        configureLabels()
        configureFields()
        configureButtons()
        
        let viewsDict = [
            "logo": logo,
            
            "ns": navigationStack,
            
            "am": atmMap,
        ]
        
        self.view.prepareViewsForAutoLayout(viewsDict)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|-20-[logo]-20-|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:|-40-[logo(==40)]-20-[ns][am]|", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[am]|", views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("H:|[ns]|", views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithSimpleFormat("V:[ns(==40)]", views: viewsDict))
        
        
        self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight - uiHeight, width: self.screenWidth, height: uiHeight)
        self.view.addSubview(sosBtn)
        
        self.cashAmt.frame = CGRect(x: -self.screenWidth/2, y: self.screenHeight - uiHeight, width: self.screenWidth/2, height: uiHeight)
        self.view.addSubview(cashAmt)
        
    }
    
    func showAtmMap() {
        cashAmt.resignFirstResponder()
        if (currentStage != .cash) {
            cashBtn.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
            dashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
            sosBtn.setTitle("SOS", forState: .Normal)
            sosBtn.addTarget(self, action: #selector(CDHomeScreenController.showTextFieldForSos), forControlEvents: .TouchUpInside)
            
            UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
                self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight - self.uiHeight, width: self.screenWidth, height: self.uiHeight)
                
                }, completion: { [unowned self] (complete) in
                    
            })
            
            //Nessie API GET Request
			guard let location = CDLocManager.manager.location else {
				CDLog("No location was found")
				return
			}
			
            let lat = String(location.coordinate.latitude)
            let long = String(location.coordinate.longitude)
        
            let radius = "0.5"
            let urlString = "http://api.reimaginebanking.com/atms?key=" + NESSIE_API_KEY + "&lat=" + lat + "&lng=" + long + "&rad=" + radius
            
            let url = NSURL(string: urlString)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!){
                (data, response, error) in
                //Add markers for nearby ATM's
                let json = JSON(data: data!)
                print(json)
                var annotations = [MKAnnotation]()
                for (_, subJSON):(String, JSON) in json["data"] {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = subJSON["geocode"]["lat"].double!
                    annotation.coordinate.longitude = subJSON["geocode"]["lng"].double!
                    annotation.title = subJSON["name"].string!
                    annotations.append(annotation)
                }
                self.atmMap.addAnnotations(annotations)
            }
            task.resume()
            
            //Set up map
            let viewRegion = MKCoordinateRegionMakeWithDistance((CDLocManager.manager.location?.coordinate)!, 2000, 2000)
            let adjustedRegion = atmMap.regionThatFits(viewRegion)
            atmMap.setRegion(adjustedRegion, animated: true)
            atmMap.showsUserLocation = true
            
            currentStage = .cash
        }
    }
    
    func showSosMap() {
        cashAmt.resignFirstResponder()
        if (currentStage != .dash) {
            
            dashBtn.backgroundColor = UIColor(r: 51, g: 102, b: 0, a: 1)
            cashBtn.backgroundColor = UIColor(r: 76, g: 173, b: 0, a: 1)
            
            
            UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
                self.sosBtn.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight, width: self.screenWidth/2, height: self.uiHeight)
                self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth/2, height: self.uiHeight)
                
                
                
                }, completion: { [unowned self] (complete) in
                    self.sosBtn.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.uiHeight)
                    self.cashAmt.frame = CGRect(x: -self.screenWidth/2, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
                })
            
            let data = ["latitude":37.00, "longitude":80.00, "username":"JOE", "cash":5,"phone":1234567890]
            let json = JSON(data: data)
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = json["latitude"]
            annotation.coordinate.longitude = json["longitude"]
            annotation.title = json["username"]
            annotation.description = "Needs $" + json["cash"] + "\nPhone #: " + json["phone"]
            self.atmMap.addAnnotation(annotation)
            
            currentStage = .dash
        }
    }
    
    func handlePush(
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            self.acceptBtn.frame = CGRect(x: 0, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
            
            self.declineBtn.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
            
            }, completion: { [unowned self] (complete) in
                
            })
    }
    
    func acceptSosRequest() {
        
    }
    
    func declineSosRequest() {
        
    }
    
    func startSosRequest() {
        cashAmt.resignFirstResponder()
        
        

    }
    
    func showTextFieldForSos() {
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { [unowned self] in
            
            self.sosBtn.setTitle("Request SOS", forState: .Normal)
            self.sosBtn.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
            
            self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
            
        }, completion: { [unowned self] (complete) in
                
        })
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
        print("yes")
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        UIView.animateWithDuration(CDUIConstants.animationDuration, animations: { () -> Void in
            if (show) {
                var userInfo = notification.userInfo!
                let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
                let changeInHeight = (CGRectGetHeight(keyboardFrame) + self.uiHeight)
                self.sosBtn.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - changeInHeight, width: self.screenWidth/2, height: self.uiHeight)
                self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - changeInHeight, width: self.screenWidth/2, height: self.uiHeight)
            } else {
                self.sosBtn.frame = CGRect(x: self.screenWidth/2, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
                self.cashAmt.frame = CGRect(x: 0, y: self.screenHeight - self.uiHeight, width: self.screenWidth/2, height: self.uiHeight)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDHomeScreenController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDHomeScreenController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        atmMap.delegate = self
        
        showAtmMap()
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cashAmt.resignFirstResponder()
    }
}
