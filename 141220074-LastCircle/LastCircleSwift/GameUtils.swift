//
//  GameUtils.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import Foundation

class GameUtils {
    enum Mode {
        case blackWhite
        case colorful
    }
    
    static let sharedUtils = GameUtils()
    var mode: Mode {
        return .colorful
    }
}
