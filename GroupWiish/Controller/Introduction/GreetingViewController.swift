//
//  DemoViewController.swift
//  EMPageViewController
//
//  Created by Erik Malyak on 3/17/15.
//  Copyright (c) 2015 Erik Malyak. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var greeting:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = UIImage.init(named:greeting)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // print("viewWillAppear: \(self.greeting) animated: \(animated)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //print("viewDidAppear: \(self.greeting) animated: \(animated)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       // print("viewWillDisappear: \(self.greeting) animated: \(animated)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
       // print("viewDidDisappear: \(self.greeting) animated: \(animated)")
    }
    
    deinit {
      //  print("deinit: \(self.greeting)")
    }

}
