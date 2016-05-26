import Foundation

public func AJLog<T>(object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line, error: Bool = false) {
	let fileString = file as NSString
	let fileLastPathComponent = fileString.lastPathComponent as NSString
	let filename = fileLastPathComponent.stringByDeletingPathExtension
	var str = "\(filename).\(function)[\(line)] "
	let len = 120 - str.characters.count
	str += String(count: len, repeatedValue: Character("=")) + "\n"
	if error {
		print("\u{001b}[fg255,0,0;" + str + "\u{001b}[;")
	} else {
		print("\u{001b}[fg0,255,0;" + str + "\u{001b}[;")
	}
	print("\(object)\n\n", terminator: "")
}