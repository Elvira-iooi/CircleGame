//
//  ScoreManager.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import Foundation

class ScoreManager {
    
    static let sharedManager = ScoreManager()
    let kUserDefaultBestScoreKey = "Best score"
    
    var best: Int {
        get {
            return UserDefaults.standard.integer(forKey: kUserDefaultBestScoreKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kUserDefaultBestScoreKey)
        }
    }
    
    var currentScore = 0
    
}
