//
//  String+Extensions.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/21/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    
    func getRegexCapture(p: String) -> String? {
        var regex: NSRegularExpression! = nil
        do {
            regex = try NSRegularExpression(pattern: p, options: [])
        } catch {
            print("Unable to create regex")
        }
        let nsString = self as NSString
        let result = regex.matchesInString(self, options: [], range: NSMakeRange(0, nsString.length))
        
        guard result.count != 0 else {
            print("Could not find a capture result for pattern \(p)")
            return nil
        }
        
        let ns_range = result[0].rangeAtIndex(1)
        let range = self.rangeFromNSRange(ns_range)
        if let r = range {
            return self.substringWithRange(r)
        } else {
            return nil
        }
    }
}