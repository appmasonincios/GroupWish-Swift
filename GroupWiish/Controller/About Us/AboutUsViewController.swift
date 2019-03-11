//
//  AboutUsViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import SideMenu
class AboutUsViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        savesharedprefrence(key:Constants.menunumber, value:"7")
        gradientView.colors = topbarcolor()
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
