//
//  Utils.swift
//  pushups
//
//  Created by Jared Alexander on 9/20/15.
//  Copyright © 2015 tysonsapps. All rights reserved.
//

import AVFoundation

class Utilities {
	
	//initialize speech synthesizer
	static let synthesizer = AVSpeechSynthesizer()
	
	static let voiceSettingKey = "voiceSetting"
	
	class func saveVoiceSetting(voice: Voice){
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(voice.rawValue, forKey: voiceSettingKey)
	}
	
	class func fetchVoiceSetting() -> Voice {
		let defaults = NSUserDefaults.standardUserDefaults()
		let voiceSettingInt: Int? = defaults.objectForKey(voiceSettingKey) as? Int
		if let voiceSettingInt = voiceSettingInt{
			let voice = Voice(rawValue: voiceSettingInt)
			if let voice = voice{
				return voice
			}
			else{
				return Voice.Male
			}
		}
		else{
			return Voice.Male
		}
	}
	
	class func speechForPushupsCompleted(pushupsCompleted: Int) -> String {
		switch(pushupsCompleted){
		case 0...1:
			return "I'm embarrassed for you."
		case 2...5:
			return "That's it?"
		case 6...15:
			return "I'm proud of you."
		case 16...25:
			return "Wow, I'm impressed!"
		default:
			return "You're a machine!"
		}
	}
	
	class func speakUtterance(utterance: String) {
		let utterance = AVSpeechUtterance(string: utterance)
		utterance.pitchMultiplier = fetchVoiceSetting().value
		utterance.rate = AVSpeechUtteranceDefaultSpeechRate
		synthesizer.speakUtterance(utterance)
	}
}