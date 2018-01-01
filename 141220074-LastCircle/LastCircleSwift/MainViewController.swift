//
//  ViewController.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit
import QuartzCore

class MainViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var randomColorButton: UIButton!
    @IBOutlet weak var scaleView: UIView!
    
    var circleViews = [CircleView]()
    var isButtonAnimating = false
    var isBackgroundAnimating = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.stopAnimating(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.restartButtonAnimation(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.restartBackgroundCircleAnimation(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScoreManager.sharedManager.currentScore = 0
        
        switch GameUtils.sharedUtils.mode {
        case .blackWhite:
            self.view.backgroundColor = UIColor.black
        case .colorful:
            self.view.backgroundColor = UIColor.white
        }
        
        let color = ColorUtils.randomColor(1)
        self.randomColorButton.layer.cornerRadius = 75
        self.randomColorButton.backgroundColor = color
        self.scaleView.layer.cornerRadius = 75
        self.scaleView.backgroundColor = color
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startButtonAnimation()
        for _ in 0...7 {
            startBackgroundCircleAnimation()
        }
        
        isButtonAnimating = true
        isBackgroundAnimating = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRound" {
            if let roundViewController = segue.destination as? RoundViewController {
                roundViewController.modalTransitionStyle = UIModalTransitionStyle.partialCurl;
            }
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        ScoreManager.sharedManager.currentScore = 0
        self.randomColorButton .setTitle("", for: UIControlState())
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.randomColorButton.transform = self.randomColorButton.transform.scaledBy(x: 20, y: 20)
            }, completion: { (_) -> Void in
                
                CircleFactory.sharedCircleFactory.circles.removeAll()
                CircleFactory.sharedCircleFactory.addCircle()
                let rvc = RoundViewController()
                rvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                rvc.round = 1
                rvc.view.backgroundColor = self.randomColorButton.backgroundColor
                self.navigationController?.pushViewController(rvc, animated: false)
        }) 
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Mark - Notification
    @objc func stopAnimating(_ notification: Notification) {
        isButtonAnimating = false
        isBackgroundAnimating = false
        scaleView.layer.removeAllAnimations()
        scaleView.transform = CGAffineTransform.identity
        for cv in circleViews {
            cv.removeFromSuperview()
        }
    }
    
    @objc func restartButtonAnimation(_ notification: Notification) {
        if !isButtonAnimating {
            startButtonAnimation()
        }
    }
    
    @objc func restartBackgroundCircleAnimation(_ notification: Notification) {
        if !isBackgroundAnimating {
            for _ in 0...7 {
                startBackgroundCircleAnimation()
            }
        }
    }
    
    // Mark - Aniamtions
    fileprivate func startButtonAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse],
            animations: { () -> Void in
                self.scaleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion:nil)
    }
    
    fileprivate func startBackgroundCircleAnimation() {
        let circle = Circle.randomCircle()
        let color = ColorUtils.randomColor()
        circle.color = color
        let cv = CircleView(circle: circle)
        cv.isUserInteractionEnabled = false
        self.view.insertSubview(cv, belowSubview: self.scaleView)
        circleViews.append(cv)
        
        
        let delay = Double(arc4random()) / Double(UINT32_MAX) * 1
        let duration = Double(arc4random()) / Double(UINT32_MAX) * 4 + 0.5
        
        cv.alpha = 0
        cv.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        weak var weakSelf = self
        UIView.animate(withDuration: duration,
            delay: delay,
            options : [.curveLinear],
            animations: { () -> Void in
                cv.alpha = 0.4
                cv.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (finished) -> Void in
                if !finished {
                    return
                } else {
                    UIView.animate(withDuration: duration,
                        delay: 0,
                        options: [.curveLinear],
                        animations: { () -> Void in
                            cv.alpha = 0
                            cv.transform = CGAffineTransform(scaleX: 2, y: 2)
                        }, completion: { (finished) -> Void in
                            cv.removeFromSuperview()
                            if !finished {
                                return
                            } else {
                                weakSelf!.startBackgroundCircleAnimation()
                            }
                    })
                }
        }
    }
}

