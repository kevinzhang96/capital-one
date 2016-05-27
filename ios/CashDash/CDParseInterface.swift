//
//  CDParseInterface.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse

class CDParseInterface: NSObject {
	// login
	static func login() {
		guard CDAuthenticationConstants.username != nil else {
			CDLog("Login failed, stored username is nil")
			return
		}
		guard CDAuthenticationConstants.password != nil else {
			CDLog("Login failed, stored password is nil")
			return
		}
		
		PFUser.logInWithUsernameInBackground(CDAuthenticationConstants.username!, password: CDAuthenticationConstants.password!) { (user, error) in
			guard error == nil else {
				CDLog("Login failed with error \"\(error!.localizedDescription)\"")
				return
			}
			
			print("Successfully logged in")
		}
	}
	
	// logout
	static func logout() {
		NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "username")
		NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "password")
		PFUser.logOut()
	}
	
	// registration
	static func register(username: String, pw: String, phone: Int, first: String, last: String, completion: (() -> ())? = nil) {
		let new_user = PFUser()
		new_user.username = username
		new_user.password = pw
		new_user["first_name"] = first
		new_user["last_name"] = last
		new_user["phone"] = phone
		
		new_user.signUpInBackgroundWithBlock { (success, error) in
			guard error == nil else {
				CDLog("Login in the background failed with error \(error!.localizedDescription)")
				return
			}
			
			NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
			NSUserDefaults.standardUserDefaults().setValue(pw, forKey: "password")
			
			CDLog("Sucessfully signed up with username \(username), current user is now \(PFUser.currentUser()!); requesting tracking now")
			self.login()
			
			CDLocationManager.sharedInstance.requestPermissions()
			
			completion?()
		}
	}
	
	// check if login information is available
	static func checkForLogin() -> Bool {
		var loggedIn = false
		
		// check for existing PFUser
		if !loggedIn {
			if let user = PFUser.currentUser() {
				CDAuthenticationConstants.user = user
				loggedIn = true
				
				CDLog("Found existing user \(user.username); logging in and going to home screen!")
			} else {
				CDLog("Unable to find existing user; searching in stored memory for login credentials")
			}
		}
		
		// check for stored credentials in NSUserDefaults
		if !loggedIn {
			// find username
			if let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
				// save username
				CDAuthenticationConstants.username = username
				
				CDLog("Username \(username) was found")
			} else {
				CDLog("No username was found")
			}
			
			// find password
			if let password = NSUserDefaults.standardUserDefaults().valueForKey("password") as? String {
				// save password
				CDAuthenticationConstants.password = password
				loggedIn = true
				
				CDLog("Password was found")
			} else {
				CDLog("No password was found")
			}
			
			CDLog("Attempting to login now")
			
			CDParseInterface.login()
		}
		
		return loggedIn
	}
}
