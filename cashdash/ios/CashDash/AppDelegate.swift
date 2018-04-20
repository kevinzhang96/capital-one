//
//  AppDelegate.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse
import SwiftyJSON
import Firebase

let NESSIE_API_KEY = "1b204cc46c793503e1e8c438ebd9c3ad"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// configure parse with server credentials
		let config = ParseClientConfiguration(block: {
			(ParseMutableClientConfiguration) -> Void in
			ParseMutableClientConfiguration.applicationId = "KeSeybm7QVaTSxFmYrQ2UEaCUJPSdyrWjeaZqHWq"
			ParseMutableClientConfiguration.clientKey = "2j5rMI29tTCLHb01lXxqUo64pWOeLeFT4l3b5BUI"
			ParseMutableClientConfiguration.server = "http://cap-cashdash.herokuapp.com/parse"
		})
		Parse.initializeWithConfiguration(config)
		
		FIRApp.configure()
		
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
		
		// register for notifications
		let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
		application.registerUserNotificationSettings(settings)
		application.registerForRemoteNotifications()
		
		// check for login and show correct controller
		let loggedIn = CDParseInterface.checkForLogin()
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = loggedIn ? CDHomeScreenController.sharedInstance : CDLoginViewController()
		window?.makeKeyAndVisible()
		
		return true
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		// register device as an installation
		let installation = PFInstallation.currentInstallation()
		installation.setDeviceTokenFromData(deviceToken)
		installation.channels = ["global"]
		installation.saveInBackground()
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		// process received data
		guard let username = userInfo["username"] as? String else {
			CDLog("No username was provided in the notification")
			return
		}
		guard let cash = userInfo["cash"] as? String else {
			CDLog("No cash was provided in the notification")
			return
		}
		guard let phone = userInfo["phone"] as? String else {
			CDLog("No phone was provided in the notification")
			return
		}
		guard let name = userInfo["name"] as? String else {
			CDLog("No name was provided in the notification")
			return
		}
		guard let lat = userInfo["latitude"] as? String else {
			CDLog("No latitude was provided in the notification")
			return
		}
		guard let long = userInfo["longitude"] as? String else {
			CDLog("No longitude was provided in the notification")
			return
		}
		guard let cashordash = userInfo["cashordash"] as? String else {
			CDLog("No cash or dash data was provided in the notification")
			return
		}
		
		let values = [
			"username": username,
			"cash": cash,
			"phone": phone,
			"name": name,
			"latitude": lat,
			"longitude": long,
			"cashordash": cashordash
		]
		
		CDLog(values)
        CDHomeScreenController.sharedInstance.handlePush(values)
	}
	
}