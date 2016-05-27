//
//  CDBaseViewController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit

class CDBaseViewController: UIViewController {
	
	convenience init() {
		self.init(nibName: nil, bundle: nil)
		
		self.configureViews()
	}
	
	func configureViews() {}
	
}