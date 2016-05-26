//
//  CDLocationManager.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import CoreLocation

class CDLocationManager: NSObject, CLLocationManagerDelegate {
	static let sharedInstance = CDLocationManager()
	
	let manager = CLLocationManager()
	
	init() {
		manager.delegate = self
	}
	
	func requestPermissions() {
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			manager.requestAlwaysAuthorization()
		} else {
			print("Unable to request permissions; current permissions are \(CLLocationManager.authorizationStatus())")
		}
	}
	
	func beginTracking() {
		if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
			manager.startUpdatingLocation()
		} else {
			print("Unable to begin tracking; authorization status is not AuthroizedAlways, but \(CLLocationManager.authorizationStatus())")
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// TODO: Upload location here to Parse
		PFUser.currentUser().set
	}
}
