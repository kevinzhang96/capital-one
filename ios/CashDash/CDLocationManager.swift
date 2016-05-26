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
	// MARK: - Properties & Initializers
	static let sharedInstance = CDLocationManager()
	let manager = CLLocationManager()
	
	override init() {
		super.init()
		manager.delegate = self
	}
	
	// MARK: - Location methods
	func requestPermissions() {
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			manager.requestAlwaysAuthorization()
		} else {
			CDLog("Location permissions have already been requested; cannot request again")
		}
	}
	
	func beginTracking() {
		if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
			manager.startUpdatingLocation()
		} else {
			CDLog("Unable to begin tracking; authorization status is not AuthorizedAlways, but \(CLLocationManager.authorizationStatus())")
		}
	}
	
	// MARK: - Push notification methods
	func sendRequest(user: PFUser) {
		guard manager.location != nil else {
			CDLog("No known location; could not send request")
			return
		}
		
		// get location and create query
		let location = manager.location!
		let query = PFInstallation.query()
		guard query != nil else {
			CDLog("Unable to create PFInstallation query for surrounding devices")
			return
		}
		
		// create a query for installations (devices) nearby
		PFPush.sendPushMessageToQueryInBackground(query!, withMessage: "Hello world!", block: { (success, error) in
			guard error == nil else {
				CDLog("Unable to send push notification; error \"\(error!.localizedDescription)\"")
				return
			}
			
			CDLog("Successfully sent notification to surrounding installations")
		})
	}
	
	func receiveRequest(user: PFUser) {
		// TODO: handle received request from user in the area
	}
	
	// MARK: - CLLocationManagerDelegate methods
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		CDLog("Got location update: \(locations.first), current user: \(PFUser.currentUser())")
		guard PFUser.currentUser() != nil else {
			return
		}

		// get current user and update
		let curr_user = PFUser.currentUser()!
		curr_user["location"] = PFGeoPoint(location: locations.first)
		
		curr_user.saveEventually({ [unowned curr_user, locations] (success, error) in
			guard error == nil else {
				CDLog("Unable to save location \(locations.first!) with error: \(error!.localizedDescription)")
				return
			}
			
			CDLog("Successfully saved location \(locations.first!.coordinate) to user \(curr_user.username!)")
		})
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways {
			CDLog("Successfully got permissions to update location; beginning tracking")
			self.beginTracking()
		} else {
			CDLog("Unsuccessful in getting permissions: current status \(status)")
		}
	}
}
