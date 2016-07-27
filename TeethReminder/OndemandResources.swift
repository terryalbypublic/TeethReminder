////
////  OndemandResources.swift
////  TeethReminder
////
////  Created by Alberti Terence on 27/07/16.
////  Copyright © 2016 TA. All rights reserved.
////
//
//import UIKit
//
//public class OndemandResources: NSObject {
//    
//    public static let resourceRequest = NSBundleResourceRequest(tags: NSSet(array: ["teethvideo"]) as! Set<String>)
//    
//    public static let loadingPercentage = 0
//    
//    public static func getResources(){
//        
//        OndemandResources.resourceRequest.conditionallyBeginAccessingResourcesWithCompletionHandler {(resourcesAvailable: Bool) -> Void in
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock({
//                if resourcesAvailable {
//                    // Do something with the resources
//                    
//                    self.startVideo()
//                    
//                } else {
//                    
//                    // activity spinner
//                    self.indicator.startAnimating()
//                    
//                    // progress observer
//                    self.resourceRequest.progress.addObserver(self,
//                        forKeyPath: "fractionCompleted",
//                        options: [.New, .Initial],
//                        context: nil)
//                    
//                    self.resourceRequest.beginAccessingResourcesWithCompletionHandler {(err: NSError?) -> Void in
//                        
//                        self.resourceRequest.progress.removeObserver(self, forKeyPath: "fractionCompleted")
//                        
//                        // main queue
//                        NSOperationQueue.mainQueue().addOperationWithBlock({
//                            
//                            // activity spinner
//                            self.indicator.stopAnimating()
//                            
//                            if (err != nil) {
//                                switch err!.code{
//                                case NSBundleOnDemandResourceOutOfSpaceError:
//                                    let message = "You don't have enough storage left to download this resource."
//                                    let alert = UIAlertController(title: "Not Enough Space",
//                                        message: message,
//                                        preferredStyle: .Alert)
//                                    alert.addAction(UIAlertAction(title: "OK",
//                                        style: .Cancel, handler: nil))
//                                    self.presentViewController(alert, animated: true,
//                                        completion: nil)
//                                case NSBundleOnDemandResourceExceededMaximumSizeError:
//                                    assert(false, "The bundle resource was too large.")
//                                default:
//                                    assert(false, err!.description)
//                                }
//                            } else {
//                                // Do something with the resources
//                                self.startVideo()
//                            }
//                        })
//                    }
//                }
//            })
//        }
//    }
//    
//
//}
