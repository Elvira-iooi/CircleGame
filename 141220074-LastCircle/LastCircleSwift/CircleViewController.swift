//
//  CircleViewController.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    var lastCircleView:CircleView!
    var touched = true
    var isTestMode = false
    var timer: Timer?
    var updateProgressTimer: Timer?
    var startTime: Date?
    let updateOperation = BlockOperation()
    let queue = OperationQueue()
    let screenWidth = UIScreen.main.bounds.width
    let minTime: CGFloat = 1
    let bonusTime: CGFloat = 0.5
    let tolerance: CGFloat = 10
    var totalTime: CGFloat = 0
    var countDownView: CountDownView = CountDownView(frame: CGRect.zero)
    var circleViews = [CircleView]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalTime = minTime + bonusTime * CGFloat(CircleFactory.sharedCircleFactory.circles.count)
        
        for circle in CircleFactory.sharedCircleFactory.circles {
            let color = ColorUtils.randomColor()
            circle.color = color
            let cv = CircleView(circle: circle)
            if circle === CircleFactory.sharedCircleFactory.circles.last! {
                self.lastCircleView = cv
            }
            if GameUtils.sharedUtils.mode == .blackWhite {
                cv.alpha = 1
            } else {
                cv.alpha = 0
            }
            self.view.addSubview(cv)
            circleViews.append(cv)
            
            // set count down progress bar height
            switch ScreenUtils.screenWidthModel() {
            case .width320, .width375, .width414, .other:
                countDownView = CountDownView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 5))
            case .width768:
                countDownView = CountDownView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
            case .width1024:
                countDownView = CountDownView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 15))
            }
            self.view.addSubview(countDownView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // animations
        
        if GameUtils.sharedUtils.mode == .colorful {
            for cv in circleViews {
                let delay = Double(arc4random()) / Double(UINT32_MAX) * 0.3
                cv.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.5,
                    delay: delay,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 6.0,
                    options: UIViewAnimationOptions.allowUserInteraction,
                    animations: {
                        cv.alpha = 1
                        cv.transform = CGAffineTransform.identity
                    }, completion: nil)
            }
        }
        
        if !isTestMode {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CircleViewController.goToGameOver), userInfo: nil, repeats: false)
        }
        
        // update progress delay 0.8 second
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            
            self.startTime = Date()
            weak var weakOperaion = self.updateOperation
            self.updateOperation.addExecutionBlock { () -> Void in
                while weakOperaion?.isCancelled == false {
                    Thread.sleep(forTimeInterval: 1/60)
                    let interval = Date().timeIntervalSince(self.startTime!)
                    OperationQueue.main.addOperation({ () -> Void in
                        self.countDownView.updateProgress(CGFloat(interval), total: self.totalTime)
                    })
                }
            }
            self.queue.addOperation(self.updateOperation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let elapsedTimeInterval: TimeInterval
        if let startTime = self.startTime {
            elapsedTimeInterval = Date().timeIntervalSince(startTime)
        } else {
            elapsedTimeInterval = 0
        }
        
        if isTestMode {
            goToNextRound()
        } else {
            timer!.invalidate()
            updateOperation.cancel()
            queue.cancelAllOperations()
            self.countDownView.removeFromSuperview()
            if touched {
                let touch = touches.first!
                let point = touch.location(in: self.view)
                let sizeSide = CGFloat(CircleFactory.sharedCircleFactory.circles.last!.radius) + tolerance
                var roundedRect = lastCircleView.frame
                roundedRect.origin.x -= tolerance
                roundedRect.origin.y -= tolerance
                roundedRect.size.width += 2*tolerance
                roundedRect.size.height += 2*tolerance
                
                let maskPath = UIBezierPath(roundedRect: roundedRect,
                    byRoundingCorners: UIRectCorner.allCorners,
                    cornerRadii: CGSize(width: sizeSide, height: sizeSide))
                if maskPath.contains(point) {
                    let score = Int((self.totalTime - CGFloat(elapsedTimeInterval))*10)
                    ScoreManager.sharedManager.currentScore += score
                    goToNextRound()
                } else {
                    lastCircleView.blink(goToGameOver);
                }
                touched = false
            }
        }
    }
    
    // MARK: Private methods
    
    func goToGameOver() {
        updateOperation.cancel()
        queue.cancelAllOperations()
        
        let screentShotImage = ScreenUtils.screenShotImage()
        let gameOverVC = GameOverViewController()
        gameOverVC.screenShotImage = screentShotImage
        self.navigationController?.pushViewController(gameOverVC, animated: true)
    }
    
    func goToNextRound() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.lastCircleView.transform = self.view.transform.scaledBy(x: 30, y: 30)
            }, completion: { (_) -> Void in
                CircleFactory.sharedCircleFactory.addCircle()
                let rvc = RoundViewController()
                rvc.round = CircleFactory.sharedCircleFactory.circles.count
                rvc.view.backgroundColor = self.lastCircleView.backgroundColor
                self.navigationController?.pushViewController(rvc, animated: false)
        }) 
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    fileprivate func changeBackgroundColor(_ color: UIColor!) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.backgroundColor = color
            }, completion: { (_) -> Void in
                self.goToNextRound()
        }) 
        
    }
}
