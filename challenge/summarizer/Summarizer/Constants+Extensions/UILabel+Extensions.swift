//
//  UILabel+Extensions.swift
//  audojam
//
//  Created by Kevin Zhang on 1/16/16.
//  Copyright © 2016 AudoJam. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(fontName: String, size: CGFloat, color: UIColor = UIColor.whiteColor()) {
        self.init()
        self.font = UIFont(name: fontName, size: size)
        self.textColor = color
    }
    
    convenience init(font: UIFont?, color: UIColor = UIColor.whiteColor()) {
        self.init()
        self.font = font
        self.textColor = color
    }
}