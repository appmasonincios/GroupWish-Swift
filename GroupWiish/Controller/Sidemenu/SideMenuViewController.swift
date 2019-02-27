//
//  SideMenuViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import PopItUp
import Messages
import MessageUI
class SideMenuViewController: UIViewController,MFMailComposeViewControllerDelegate {

    var menuarrayone = [String]()
    var menuarraytwo = [String]()
    var menuarrayoneimg = [String]()
    var menuarraytwoimg = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuarrayone = ["Profile","Search a Contacts","My Contacts","Wishes Sent","Received TY Cards","Premimum App","Rate App","About Us","Feedback"]
        menuarraytwo = ["Sign out"]
        
        menuarrayoneimg = ["userprofile","leftsearch","mycontacts","wishessent","receivedtycards","premimumapp","ratting","aboutus","feedback"]
        
        menuarraytwoimg = ["signout"]
        // Do any additional setup after loading the view.
    }
}


extension SideMenuViewController:UITableViewDataSource,UITableViewDelegate
{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 0
        {
            return 44.0
        }
        else
        {
            return 80.0
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
             let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier:"SideMenuTableViewCell", for:indexPath) as! SideMenuTableViewCell
            cell.menulabel.text = menuarrayone[indexPath.row]
            cell.menuimage.image = UIImage.init(named:menuarrayoneimg[indexPath.row])
              return cell
        }
        else
        {
            let cell:SideMenuLogoutTableViewCell = tableView.dequeueReusableCell(withIdentifier:"SideMenuLogoutTableViewCell", for:indexPath) as! SideMenuLogoutTableViewCell
            cell.menulabel.text = menuarraytwo[indexPath.row]
            cell.menuimage.image = UIImage.init(named:menuarraytwoimg[indexPath.row])
           return cell
            
        }
    }
    
  
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            let headerView = UIView()
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell") as! MenuHeaderTableViewCell
            
            
             headerCell.placelabel.text = getSharedPrefrance(key:Constants.LOCATION)
             headerCell.namelabel.text = getSharedPrefrance(key:Constants.USERNAME)
        
           
            let sociallogin = getSharedPrefrance(key:Constants.social_login)
            
            if sociallogin == "1"
            {
                let imageURL = URL(string:getSharedPrefrance(key:Constants.PROFILE_PIC))!
                headerCell.userprofileimage.kf.indicatorType = .activity
                headerCell.userprofileimage.kf.setImage(with: imageURL)
            }
            else
            { let imageURL = URL(string:Constants.WS_ImageUrl + "/" + getSharedPrefrance(key:Constants.PROFILE_PIC))!
                headerCell.userprofileimage.kf.indicatorType = .activity
                headerCell.userprofileimage.kf.setImage(with: imageURL)
            }
            
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
            
             return 200
        }
        else
        {
            return 0
        }
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                
                //profile
              //ProfileViewController
                let vc:ProfileViewController = storyboard?.instantiateViewController(withIdentifier:"ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(vc, animated:false)
                
            }
            else if indexPath.row == 1
            {
                let vc:AddContactsViewControllern = storyboard?.instantiateViewController(withIdentifier:"AddContactsViewControllern") as! AddContactsViewControllern
                self.navigationController?.pushViewController(vc, animated:false)
               //search a Contects
            }
            else if indexPath.row == 2
            {
               
                let vc:MyContactsViewController = storyboard?.instantiateViewController(withIdentifier:"MyContactsViewController") as! MyContactsViewController
                self.navigationController?.pushViewController(vc, animated:false)
                
            }
            else if indexPath.row == 3
            {
                let vc:WishesSentViewController = storyboard?.instantiateViewController(withIdentifier:"WishesSentViewController") as! WishesSentViewController
                self.navigationController?.pushViewController(vc, animated:false)
                //Wishes Sent
                
            }
            else if indexPath.row == 4
            {
                let vc:ReceivedTYCardsVC = storyboard?.instantiateViewController(withIdentifier:"ReceivedTYCardsVC") as! ReceivedTYCardsVC
                self.navigationController?.pushViewController(vc, animated:false)
                //Received TY Cards
                
            }
            else if indexPath.row == 5
            {
                
                
                presentPopup(PremiumAppVC(),
                             animated: true,
                             backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
                    constraints: [.leading(16), .trailing(16),.height(250)], // fix leading edge and the width
                    transitioning: .slide(.left), // the popup come and goes from the left side of the screen
                    autoDismiss: false, // when touching outside the popup bound it is not dismissed
                    completion: nil)

                
            }
            else if indexPath.row == 6
            {
                let iTunesLink = "https://itunes.apple.com/SG/app/id1211730146?mt=8"
                if let url = URL(string: iTunesLink) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
            else if indexPath.row == 7
            {
                let vc:AboutUsViewController = storyboard?.instantiateViewController(withIdentifier:"AboutUsViewController") as! AboutUsViewController
                self.navigationController?.pushViewController(vc, animated:false)
                //About us
                
            }
            else
            {
                let mc = MFMailComposeViewController()
                
                if MFMailComposeViewController.canSendMail() {
                    let toRecipents = ["groupwish@appmasoninc.com"]
                    
                    mc.mailComposeDelegate = self
                    
                    mc.setSubject("Feedback for GroupWish")
                    mc.setToRecipients(toRecipents)
                    
                    present(mc, animated: true)
                }
                
            }
         
        }
        else
        {
            
            
            let typeoftab = getSharedPrefrance(key:Constants.TABTYPE)
            
            if typeoftab == "1"
            {
               
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("ULO1"), object: nil)
            }
            else if typeoftab == "2"
            {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("ULO2"), object: nil)
            }
            else if typeoftab == "3"
            {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("ULO3"), object: nil)
            }
            else if typeoftab == "4"
            {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("ULO4"), object: nil)
            }
            else
            {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("ULO5"), object: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "")")
        default:
            break
        }
        dismiss(animated: true)
    }

    
}
