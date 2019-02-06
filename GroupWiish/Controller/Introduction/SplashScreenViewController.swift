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
    

    override func viewWillAppear(_ animated: Bool) {
       
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
    
    
    @objc func timercompleted() {
        DispatchQueue.main.async(execute: {
            
            if GBVersionTracking.isFirstLaunchEver() {
//                let TutorialViewController = self.storyboard.instantiateViewController(withIdentifier: "TutorialVC") as? TutorialViewController
//                self.view.window.rootViewController = TutorialViewController
//                self.view.window.makeKeyAndVisible()
            } else {
                
//                let LoginViewController = self.storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
//                self.view.window.rootViewController = LoginViewController
//                self.view.window.makeKeyAndVisible()
            }
            
            self.timer?.invalidate()
        })
    }

    
   

}


/*
 #import "SplashScreenViewController.h"
 
 @interface SplashScreenViewController ()
 {
 NSTimer * timer;
 }
 @end
 
 @implementation SplashScreenViewController
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 
 -(void)viewWillAppear:(BOOL)animated
 {
 self.gifImageView.image = [UIImage imageNamed:@"layout_login_bg.png"];
 
 [UIView animateWithDuration:0 animations:^{
 
 self.logo.transform = CGAffineTransformMakeScale(0.01, 0.01);
 
 }completion:^(BOOL finished){
 
 [UIView animateWithDuration:0.4 animations:^{
 
 self.logo.transform = CGAffineTransformIdentity;
 
 }completion:^(BOOL finished){
 
 }];
 }];
 
 timer = [NSTimer scheduledTimerWithTimeInterval:SPLASH_SCREEN_TIME target:self selector:@selector(timercompleted) userInfo:nil repeats:NO];
 }
 
 -(void)timercompleted
 {
 dispatch_async(dispatch_get_main_queue(), ^{
 
 if([GBVersionTracking isFirstLaunchEver])
 {
 TutorialViewController * TutorialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialVC"];
 self.view.window.rootViewController = TutorialViewController;
 [self.view.window makeKeyAndVisible];
 
 }else{
 
 LoginViewController * LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
 self.view.window.rootViewController = LoginViewController;
 [self.view.window makeKeyAndVisible];
 }
 
 [self->timer invalidate];
 });
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 }
 
 @end
 */
