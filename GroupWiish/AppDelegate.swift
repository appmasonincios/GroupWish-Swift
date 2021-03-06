//
//  AppDelegate.swift
//  GroupWiish
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import TwitterKit
import GoogleSignIn
import DYBadgeButton
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
   
    
  
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.init(red:60.0/255.0, green:16.0/255.0, blue:80.0/255.0, alpha:1.0)
        }
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(red:255.0/255.0, green:3.0/255.0, blue:92.0/255.0, alpha:1.0)], for: .selected)
        
         savesharedprefrence(key:Constants.toasttype, value:"start")
      
        GBVersionTracking.track()
    
        /* Facebook Login SDK */
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions:launchOptions)
         /* Twitter Login SDK */
    TWTRTwitter.sharedInstance().start(withConsumerKey:Constants.TWITTER_CONSUMER_KEY, consumerSecret:Constants.TWITTER_CONSUMER_SECRET)
      
       IQKeyboardManager.shared.enable = true
         UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        //For Push Notifications:-
        self.registerForPushNotifications(application: application)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        self.changeRootViewController(selectedIndexOfTabBar: 0)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
         var handled = true
  
        if url.scheme?.localizedCaseInsensitiveCompare(Constants.FACEBOOK_URL_SCHEME) == .orderedSame
        {
           
            handled = (FBSDKApplicationDelegate.sharedInstance()?.application(app, open:url, sourceApplication:[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation:[UIApplication.OpenURLOptionsKey.annotation]))!
        }
        else if url.scheme?.localizedCaseInsensitiveCompare(Constants.GOOGLE_URL_SCHEME) == .orderedSame
        {
            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
         else if url.scheme?.localizedCaseInsensitiveCompare(Constants.TWITTER_URL_SCHEME) == .orderedSame
        {
            
            handled = TWTRTwitter.sharedInstance().application(app, open:url, options:options)
        }
    
        return handled
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
   

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GroupWiish")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    //Ios 10 delegates for Push Notifications
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        
        if let pushDict = notification.request.content.userInfo["aps"] as? [String : AnyObject]
        {
            print(pushDict)
        }
        
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        
        if (response.notification.request.content.userInfo["aps"] as? [String : Any]) != nil
        {
         
            guard
                let aps = response.notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary
                else
               {
                    // handle any error here
                    return
                }
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserNotificationUpdate"), object: nil)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        completionHandler()
        
    }
    
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("APNs registration failed: \(error)")
        
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count
        {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        
        savesharedprefrence(key:"devicetoken", value:token)
    }
    
}
extension AppDelegate {
    
    func changeRootViewController(selectedIndexOfTabBar: Int = 0)
    {
        if getSharedPrefrance(key:"loginsession") == "true"
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            centerViewController.selectedIndex = selectedIndexOfTabBar
            self.window?.rootViewController = centerViewController
        }
        else
        {
           
            
            
            
            
        }
        
        
    }
    
}
