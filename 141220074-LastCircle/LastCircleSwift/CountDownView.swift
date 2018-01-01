//
//  CountDownView.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit

class CountDownView: UIView {

    var progressView: UIView = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: frame.size.height)
        self.progressView.backgroundColor = UIColor.green
        self.addSubview(self.progressView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(_ time:CGFloat, total:CGFloat) {
        let progressViewWidth = frame.size.width * time / total
        progressView.frame = CGRect(x: 0, y: 0, width: progressViewWidth, height: frame.size.height)

        let r,g,b :CGFloat
        let a: CGFloat = 1.0
        if time < total/2 {
            r = time/total*2
            g = 1
        } else {
            r = 1
            g = 2 - time/total*2
        }
        b = 0
        let currentColor = UIColor(red: r, green: g, blue: b, alpha: a)
        progressView.backgroundColor = currentColor
    }

}
