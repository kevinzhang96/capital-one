//
//  CDHomeScreenController.swift
//  CashDash
//
//  Created by Kevin Zhang on 5/26/16.
//  Copyright © 2016 theanimasian. All rights reserved.
//

import UIKit
import Parse

class CDHomeScreenController: CDBaseViewController {
	
	override func configureViews() {
		CDParseInterface.logout()
	}
	
}
