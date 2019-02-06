//
//  SideMenuViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    var menuarrayone = [String]()
    var menuarraytwo = [String]()
    var menuarrayoneimg = [String]()
    var menuarraytwoimg = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuarrayone = ["Profile","Search a Contacts","My Contacts","Wishes Sent","Received TY Cards","Premimum App","Rate App","About Us","Freeback"]
        menuarraytwo = ["Sign out"]
        
        menuarrayoneimg = ["userprofile","leftsearch","mycontacts","wishessent","receivedtycards","premimumapp","ratting","aboutus","feedback"]
        
        menuarraytwoimg = ["signout"]
        // Do any additional setup after loading the view.
    }
    
    
    

   

}


extension SideMenuViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier:"SideMenuTableViewCell", for:indexPath) as! SideMenuTableViewCell
        
        if indexPath.section == 0
        {
            cell.menulabel.text = menuarrayone[indexPath.row]
            cell.menuimage.image = UIImage.init(named:menuarrayoneimg[indexPath.row])
        }
        else
        {
            cell.menulabel.text = menuarraytwo[indexPath.row]
            cell.menuimage.image = UIImage.init(named:menuarraytwoimg[indexPath.row])
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
             return menuarrayone.count
        }
        else
        {
            return menuarraytwo.count
        }
    
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let headerView = UIView()
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell") as! MenuHeaderTableViewCell
            
            
            headerView.addSubview(headerCell)
            return headerView
            
        }
        else
        {
            
            return nil
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0
        {
            
             return 150
        }
        else
        {
            return 0
        }
        
        
      
    }
    
    
    
}
