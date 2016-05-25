//
//  SettingsViewController.swift
//  pushups
//
//  Created by Alexander, Jared on 12/23/15.
//  Copyright © 2015 tysonsapps. All rights reserved.
//

class SettingsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
	@IBOutlet weak var voicePicker: UIPickerView!
	
	//controller lifecycle function
	override func viewDidLoad() {
		super.viewDidLoad()
		
		voicePicker.dataSource = self
		voicePicker.delegate = self
		
		voicePicker.selectRow(Utilities.fetchVoiceSetting().rawValue, inComponent: 0, animated: false)
		
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return Voice.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
		return Voice(rawValue: row)?.description
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		Utilities.saveVoiceSetting(Voice(rawValue:row)!)
	}
	
}