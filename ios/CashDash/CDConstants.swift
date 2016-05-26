import UIKit
import Parse

struct CDUIConstants {
	static let viewFactor           = UIScreen.mainScreen().bounds.size.width / 375
	static let animationDuration    = 0.5
	
	struct colors {
		// example colors
		
		/// 195, 255, 0, 1.0
		static let highlight        = UIColor(r: 195, g: 255, b: 0, a: 1.0)
	}
	
	struct fonts {
		
	}
}

struct CDParseConstants {
	static let retrieveLimit = 25
	static let PARSE_APP_ID = "TODO"
	static let PARSE_CLIENT_KEY = "TODO"
}

struct CDAuthenticationConstants {
	static var username = ""
	static var password = ""
	static var user: PFUser? = nil
}