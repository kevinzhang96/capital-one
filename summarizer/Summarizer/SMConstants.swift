//
//  SMConstants.swift
//  Summarizer
//
//  Created by Kevin Zhang on 3/19/16.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit

struct SMConstants {
    static let bgColor = UIColor(r: 23, g: 10, b: 28, a: 1.0)
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Float) {
        self.init(colorLiteralRed: Float(r) / 255.0, green: Float(g) / 255.0, blue: Float(b) / 255.0, alpha: a)
    }
}