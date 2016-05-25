//
//  WorkoutSession.swift
//  pushups
//
//  Created by Jared Alexander on 9/20/15.
//  Copyright © 2015 tysonsapps. All rights reserved.
//

class Workout{
	var name: String
	var startDate: NSDate
	var endDate: NSDate
	var pushupsCompleted: Int
	
	init (name: String, startDate: NSDate, endDate: NSDate, pushupsCompleted: Int) {
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.pushupsCompleted = pushupsCompleted
	}
	
	func elapsedTime() -> (minutes: Int,seconds: Int) {
		let seconds =  NSCalendar.currentCalendar().components(.Second, fromDate: startDate, toDate: endDate, options: []).second
		if(seconds < 60){
			return(0,seconds)
		}
		else{
			let numWholeMinutes:Int = seconds / 60
			let remainingSeconds = Int(Double(seconds) - Double(numWholeMinutes) * 60.0)
			
			return (numWholeMinutes,remainingSeconds)
		}
	}
	
	func generateSpokenElapsedTime() -> String{
		let elapsedTimeTuple = elapsedTime()
		if(elapsedTimeTuple.minutes == 0){
			return "\(elapsedTimeTuple.seconds) seconds"
		}
		else{
			return "\(elapsedTimeTuple.minutes) minutes and \(elapsedTimeTuple.seconds) seconds"
		}
	}
}