//
//  CalculationTools.swift
//  BubblePop
//
//  Created by Petra Čačkov on 03/01/2021.
//

import UIKit

class CalculationTools {

    
    static func distance(from point: CGPoint, to secondPoint: CGPoint) -> CGFloat {
        return hypot(point.x - secondPoint.x, point.y - secondPoint.y)
    }
    
    static func delta(lhs: CGPoint, rgh: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rgh.x, y: lhs.y - rgh.y)
    }
    
}
