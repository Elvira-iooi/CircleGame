//
//  RoundViewController.swift
//  LastCircleSwift
//
//  Created by luping on 2017/12/10.
//  Copyright © 2017年 luping. All rights reserved.
//

import UIKit

class RoundViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundTitleLabel: UILabel!
    var round: Int!
    let cvc = CircleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set colors
        switch GameUtils.sharedUtils.mode {
        case .blackWhite:
            self.roundLabel.textColor = UIColor.black
            self.roundTitleLabel.textColor = UIColor.black
            cvc.view.backgroundColor = UIColor.black
        case .colorful:
            self.roundLabel.textColor = UIColor.white
            self.roundTitleLabel.textColor = UIColor.white
            cvc.view.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        }
        
        switch ScreenUtils.screenWidthModel() {
        case .width320, .width375, .width414, .other:
            roundLabel.font = UIFont(name: "Futura", size: 50)
            roundTitleLabel.font = UIFont(name: "Futura", size: 50)
        case .width768:
            roundLabel.font = UIFont(name: "Futura", size: 80)
            roundTitleLabel.font = UIFont(name: "Futura", size: 80)
        case .width1024:
            roundLabel.font = UIFont(name: "Futura", size: 120)
            roundTitleLabel.font = UIFont(name: "Futura", size: 120)
        }
        
        self.roundLabel.text = "\(self.round)"
        self.roundLabel.alpha = 0
        self.roundTitleLabel.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.goToCircleViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.roundLabel.alpha = 1
            self.roundTitleLabel.alpha = 1
        }) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    func goToCircleViewController() {
        navigationController?.pushViewController(cvc, animated: false)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
