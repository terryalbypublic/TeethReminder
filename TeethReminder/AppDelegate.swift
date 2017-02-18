//
//  AppDelegate.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//



import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // init firebase
        FIRApp.configure()
        
        // Override point for customization after application launch.
        ReminderList.sharedInstance.setInitialValues()
        
        let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)

        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // open the second tab bar menu if the user opened from the notification
        let tabBar = window?.rootViewController as! UITabBarController
        if (launchOptions != nil && launchOptions?[UIApplicationLaunchOptionsKey.localNotification] != nil) {
            tabBar.selectedIndex=Constants.tabTimer
        }
        
        
        // start fetching of video
        OndemandResources.getResources()
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){
       NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.userNotificationKey), object: self)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // open the second tab bar menu if the user opened from the notification
        let tabBar = window?.rootViewController as! UITabBarController
        tabBar.selectedIndex=Constants.tabTimer
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

