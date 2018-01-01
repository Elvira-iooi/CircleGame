//
//  Circle.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit

class Circle {

    // MARK: Properties
    static var minRadius: Int {
        switch ScreenUtils.screenWidthModel() {
        case .width320, .width375, .width414, .other:
            return 20
        case .width768:
            return 40
        case .width1024:
            return 60
        }
    }
    static var maxRadius: Int {
        switch ScreenUtils.screenWidthModel() {
        case .width320, .width375, .width414, .other:
            return 50
        case .width768:
            return 100
        case .width1024:
            return 150
        }
    }
    var color: UIColor
    let radius: Int
    let center: CGPoint
    
    init(color:UIColor, radius:Int, center:CGPoint){
        self.color = color
        self.radius = radius
        self.center = center
    }
    
    class func randomCircle() -> Circle {
        let screenRect = UIScreen.main.bounds
        let screenWidth:CGFloat = screenRect.width
        let screenHeight:CGFloat = screenRect.height
        let randomRadius = minRadius + Int(arc4random_uniform(UInt32(maxRadius - minRadius + 1)))
        
        let areaWidth = Int(screenWidth) - (randomRadius << 1);
        let areaHeight = Int(screenHeight) - (randomRadius << 1) - 20;
        
        let x = randomRadius + Int(arc4random_uniform(100000)) % areaWidth
        let y = 20 + randomRadius + Int(arc4random_uniform(100000)) % areaHeight // below the status bar
        let randomPoint = CGPoint(x: x, y: y)
        
        let randomColor = ColorUtils.randomColor()
        let circle = Circle(color: randomColor, radius: randomRadius, center: randomPoint)
        return circle
    }
    
}
