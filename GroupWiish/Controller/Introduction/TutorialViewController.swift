//
//  ViewController.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import EMPageViewController
class TutorialViewController: UIViewController, EMPageViewControllerDataSource, EMPageViewControllerDelegate
{
    var greeting:String!
    
    var color:UIColor!
    var images:[String] = ["splash1","splash2","splash3","introduction-screen-4 (1).jpg"]
    @IBOutlet weak var splashimage: UIImageView!
    @IBOutlet weak var reverseButton: UIButton!
  
    @IBOutlet weak var forwardButton: UIButton!
    var pageViewController: EMPageViewController?
    
    

    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
    
        let pageViewController = EMPageViewController()
        
        // Or, for a vertical orientation
        // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        let currentViewController = self.viewController(at: 0)!
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0) // Insert the page controller view below the navigation buttons
        pageViewController.didMove(toParent: self)
        self.pageViewController = pageViewController
    }

    @IBAction func forward(_ sender: AnyObject) {
        self.pageViewController!.scrollForward(animated: true, completion: nil)
    }
    
    @IBAction func reverse(_ sender: AnyObject) {
        self.pageViewController!.scrollReverse(animated: true, completion: nil)
    }
    
    // MARK: - EMPageViewController Data Source
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! TutorialViewController) {
            let beforeViewController = self.viewController(at: viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! TutorialViewController) {
            let afterViewController = self.viewController(at: viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewController(at index: Int) -> TutorialViewController?
    {
        if (self.images.count == 0) || (index < 0) || (index >= self.images.count) {
            return nil
        }
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        viewController.greeting = self.images[index]

        return viewController
    }
    
    func index(of viewController: TutorialViewController) -> Int? {
        if let greeting: String = viewController.greeting
        {
            return self.images.index(of: greeting)
        }
        else
        {
            return nil
        }
    }
    
    
    // MARK: - EMPageViewController Delegate
    
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
        
       // let startTutorialViewController = startViewController as! TutorialViewController
       // let destinationTutorialViewController = destinationViewController as! TutorialViewController
        
     //   print("Will start scrolling from \(startTutorialViewController.greeting) to \(destinationTutorialViewController.greeting).")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
      //  let startTutorialViewController = startViewController as! TutorialViewController
      //  let destinationTutorialViewController = destinationViewController as! TutorialViewController
        
        // Ease the labels' alphas in and out
       // let absoluteProgress = fabs(progress)
       // startTutorialViewController.label.alpha = pow(1 - absoluteProgress, 2)
       // destinationTutorialViewController.label.alpha = pow(absoluteProgress, 2)
        
      //  print("Is scrolling from \(startTutorialViewController.greeting) to \(destinationTutorialViewController.greeting) with progress '\(progress)'.")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let startViewController = startViewController as! TutorialViewController?
        let destinationViewController = destinationViewController as! TutorialViewController
        
        // If the transition is successful, the new selected view controller is the destination view controller.
        // If it wasn't successful, the selected view controller is the start view controller
        if transitionSuccessful {
            
            if (self.index(of: destinationViewController) == 0) {
                self.reverseButton.isEnabled = false
            } else {
                self.reverseButton.isEnabled = true
            }
            
            if (self.index(of: destinationViewController) == self.images.count - 1) {
                self.forwardButton.isEnabled = false
            } else {
                self.forwardButton.isEnabled = true
            }
        }
        
     //   print("Finished scrolling from \(startViewController?.greeting) to \(destinationViewController.greeting). Transition successful? \(transitionSuccessful)")
    }
    

}

