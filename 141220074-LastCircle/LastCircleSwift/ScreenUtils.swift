//
//  ScreenUtils.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.

//

import UIKit

class ScreenUtils: NSObject {
    
    enum Model: CGFloat {
        case width320 = 320
        case width375 = 375
        case width414 = 414
        case width768 = 768
        case width1024 = 1024
        case other
    }
    
    class func screenWidthModel() -> Model {
        let width =  UIScreen.main.bounds.width
        switch width {
        case 320:return .width320
        case 375:return .width375
        case 414:return .width414
        case 768:return .width768
        case 1024:return .width1024
        default:return .other
        }
    }
    
    
    class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func screenShotImage() -> UIImage {
        let window = UIApplication.shared.keyWindow
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, false, 0.0)
        window?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return screenShotImage!
    }

}
