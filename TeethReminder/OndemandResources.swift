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
    public static let notifications = NotificationCenter.default
    public static var videoDownloaded = false
    public static var errorCode = 0
    public static var errorDescription = ""
    
    public static func getResources(){
        
        OndemandResources.resourceRequest.conditionallyBeginAccessingResources {(resourcesAvailable: Bool) -> Void in
            
            OperationQueue.main.addOperation({
                if resourcesAvailable {
                    // Do something with the resources
                    self.videoDownloaded = true
                    OndemandResources.notifications.post(name: NSNotification.Name(rawValue: "videoDownloadFinished"), object: nil)
                    
                } else {
                    
                    self.videoDownloaded = false
                    OndemandResources.notifications.post(name: NSNotification.Name(rawValue: "videoDownloadStarted"), object: nil)
                    
                    
                    
                    OndemandResources.resourceRequest.beginAccessingResources {(err: Error?) -> Void in
                        
                        OperationQueue.main.addOperation({
                            // LOADING FINISH
                            if(err == nil){
                                self.videoDownloaded = true
                            }
                            else{
                                self.errorCode = (err as! NSError).code
                                self.errorDescription = (err as! NSError).description
                                self.videoDownloaded = false
                            }
                            OndemandResources.notifications.post(name: NSNotification.Name(rawValue: "videoDownloadFinished"), object: nil)
                            
                        })
                    }
                }
            })
        }
    }
    

}
