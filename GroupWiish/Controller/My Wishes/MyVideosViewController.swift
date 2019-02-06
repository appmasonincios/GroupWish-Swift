//
//  MyVideosViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
class MyVideosViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     settingsui()
    }
    
    func settingsui()
    {
        
        gradientView.colors = [
            UIColor(red: 91.0/255.0, green: 37.0/255.0, blue: 91.0/255.0, alpha: 1),
            UIColor(red: 111.0/255.0, green: 63.0/255.0, blue: 111.0/255.0, alpha: 1)
        ]
        setupSideMenu()
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = CGFloat(0)
        
    }
    
}

