//
//  OndemandResources.swift
//  TeethReminder
//
//  Created by Alberti Terence on 27/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public class OndemandResources: NSObject {
    
    public static let resourceRequest = NSBundleResourceRequest(tags: NSSet(array: ["teethvideo"]) as! Set<String>)
    public static let notifications = NSNotificationCenter.defaultCenter()
    public static var videoDownloaded = false
    public static var errorCode = 0
    public static var errorDescription = ""
    
    public static func getResources(){
        
        OndemandResources.resourceRequest.conditionallyBeginAccessingResourcesWithCompletionHandler {(resourcesAvailable: Bool) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if resourcesAvailable {
                    // Do something with the resources
                    self.videoDownloaded = true
                    OndemandResources.notifications.postNotificationName("videoDownloadFinished", object: nil)
                    
                } else {
                    
                    self.videoDownloaded = false
                    OndemandResources.notifications.postNotificationName("videoDownloadStarted", object: nil)
                    
                    OndemandResources.resourceRequest.beginAccessingResourcesWithCompletionHandler {(err: NSError?) -> Void in
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            // LOADING FINISH
                            if(err == nil){
                                self.videoDownloaded = true
                            }
                            else{
                                self.errorCode = (err?.code)!
                                self.errorDescription = (err?.description)!
                                self.videoDownloaded = false
                            }
                            OndemandResources.notifications.postNotificationName("videoDownloadFinished", object: nil)
                            
                        })
                    }
                }
            })
        }
    }
    

}
