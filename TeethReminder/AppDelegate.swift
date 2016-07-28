//
//  AppDelegate.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//



import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        ReminderList.sharedInstance.setInitialValues()
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)

        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // open the second tab bar menu if the user opened from the notification
        if (launchOptions != nil) {
            let tabBar = window?.rootViewController as! UITabBarController
            tabBar.selectedIndex=1
        }
        
        // start fetching of video
        OndemandResources.getResources()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
       NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.userNotificationKey, object: self)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // open the second tab bar menu if the user opened from the notification
        let tabBar = window?.rootViewController as! UITabBarController
        tabBar.selectedIndex=1
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

