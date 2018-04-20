//
//  AppDelegate.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/18/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = SMArticleListController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
}