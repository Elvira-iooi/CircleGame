//
//  CircleFactory.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit

class CircleFactory: NSObject{
    
    // MARK: Properties
    static let MaxCircleCount = 40
    static let sharedCircleFactory = CircleFactory()
    let RadiusGap:Float = 10
    
    var circles = [Circle]()
    
    fileprivate override init() {
        self.circles.removeAll()
    }
    
    func addCircle() {
        while true {
            let aCircle = Circle.randomCircle()
            if isCircleAvailable(aCircle) {
                self.circles.append(aCircle)
                break
            }
            continue
        }
    }
    
    func isCircleAvailable(_ aCircle: Circle) -> Bool {
        for circle in self.circles {
            let distance = hypotf(
                Float(aCircle.center.x - circle.center.x),
                Float(aCircle.center.y - circle.center.y))
            let radiusLength = Float(aCircle.radius + circle.radius)
            if distance <= radiusLength + RadiusGap {
                return false
            }
        }
        return true
    }
}
