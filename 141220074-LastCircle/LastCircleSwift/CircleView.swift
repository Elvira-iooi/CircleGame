//
//  CircleView.swift
//  FoodTracker
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.

//

import UIKit

class CircleView: UIView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(circle: Circle) {
        let frame = CGRect(x: 0, y: 0, width: CGFloat(circle.radius*2), height: CGFloat(circle.radius*2))
        super.init(frame: frame)
        self.backgroundColor = circle.color
        self.center = circle.center
        self.layer.cornerRadius = CGFloat(circle.radius)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blink(_ completion: @escaping ()-> Void) {
        let scaleUpAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleUpAnim.toValue = NSNumber(value: 1.5 as Float)
        scaleUpAnim.repeatCount = 3
        scaleUpAnim.duration = 0.2
        scaleUpAnim.autoreverses = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.layer.add(scaleUpAnim, forKey: nil);
        CATransaction.commit()
    }
}
