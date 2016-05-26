//
//  CDLocationManager.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class CDLocationManager: NSObject, CLLocationManagerDelegate {
	static let sharedInstance = CDLocationManager()
	
	let manager = CLLocationManager()
	
	override init() {
		super.init()
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
			print("Unable to begin tracking; authorization status is not AuthorizedAlways, but \(CLLocationManager.authorizationStatus())")
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// TODO: Upload location here to Parse
		if let curr_user = PFUser.currentUser() {
			curr_user["location"] = PFGeoPoint(location: locations.first)
			curr_user.saveEventually({ [unowned curr_user, locations] (success, error) in
				guard error == nil else {
					print("Unable to save location \(locations.first) with error: \(error!.localizedDescription)")
					return
				}
				
				print("Successfully saved location \(locations.first) to user \(curr_user.username)")
			})
		}
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways {
			print("Successfully got permissions to update location; beginning tracking")
			self.beginTracking()
		} else {
			print("Unsuccessful in getting permissions: current status \(status)")
		}
	}
	
	func sendRequest(user: PFUser) {
		if let location = manager.location {
			// TODO: send request from current location
			print(location)
		} else {
			print("No known location; could not send request")
		}
	}
	
	func receiveRequest(user: PFUser) {
		// TODO: handle received request from user in the area
	}
}
