//
//  UIView+Extensions.swift
//  audojam
//
//  Created by Kevin Zhang on 1/19/16.
//  Copyright © 2016 AudoJam. All rights reserved.
//

import UIKit

extension UIView {
    func prepareViewsForAutoLayout(viewsDict: [String: UIView]) {
        let _ = Array(viewsDict.values).map({$0.translatesAutoresizingMaskIntoConstraints = false; self.addSubview($0)})
    }
    
    func addDashedBorder() {
        let color = UIColor.blackColor().CGColor
        
        let shapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).CGPath
        
        self.layer.addSublayer(shapeLayer)
    }
}