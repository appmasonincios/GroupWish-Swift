//
//  SplashScreenViewController.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController
{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var gifImageView: UIImageView!
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewWillAppear(_ animated: Bool)
    {
      self.gifImageView.image = UIImage.init(named:"layout_login_bg.png")
        
        UIView.animate(withDuration: 0, animations: {
            
            self.logo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }) { finished in
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.logo.transform = CGAffineTransform.identity
                
            }) { finished in
                
            }
        }
    
        timer = Timer.scheduledTimer(timeInterval:0.3, target: self, selector: #selector(self.timercompleted), userInfo: nil, repeats: false)
    }
    
    
    @objc func timercompleted()
    {
        DispatchQueue.main.async(execute:
            {
            if GBVersionTracking.isFirstLaunchEver()
            {
                let TutorialViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingControllerN") as? OnboardingControllerN
                self.view.window?.rootViewController = TutorialViewController
                self.view.window?.makeKeyAndVisible()
            }
            else
            {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.view.window?.rootViewController = loginViewController
                self.view.window?.makeKeyAndVisible()
            }
            self.timer?.invalidate()
        })
    }

    
   

}

