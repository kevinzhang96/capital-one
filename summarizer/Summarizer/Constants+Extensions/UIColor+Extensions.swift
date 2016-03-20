//
//  UIColor+Extensions.swift
//  audojam
//
//  Created by Kevin Zhang on 1/14/16.
//  Copyright © 2016 AudoJam. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Float) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a))
    }
}