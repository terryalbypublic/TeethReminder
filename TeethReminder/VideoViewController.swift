//
//  VideoViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 27/07/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController : UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    let indicator = UIActivityIndicatorView()
    let playerViewController = AVPlayerViewController()
    private var foregroundNotification: NSObjectProtocol!
    let resourceRequest = NSBundleResourceRequest(tags: NSSet(array: ["teethvideo"]) as! Set<String>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getResources()
        // Do any additional setup after loading the view.
        
        foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self] notification in
            
            self.continueVideo()
            // do whatever you want when the app is brought back to the foreground
        }
        
        
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NSNotificationCenter.defaultCenter().removeObserver(foregroundNotification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getResources(){
        
        self.resourceRequest.conditionallyBeginAccessingResourcesWithCompletionHandler {(resourcesAvailable: Bool) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if resourcesAvailable {
                    // Do something with the resources
                    
                    self.startVideo()
                    
                } else {
                    
                    // activity spinner
                    self.indicator.startAnimating()
                    
                    // progress observer
                    self.resourceRequest.progress.addObserver(self,
                        forKeyPath: "fractionCompleted",
                        options: [.New, .Initial],
                        context: nil)
                    
                    self.resourceRequest.beginAccessingResourcesWithCompletionHandler {(err: NSError?) -> Void in
                        
                        self.resourceRequest.progress.removeObserver(self, forKeyPath: "fractionCompleted")
                        
                        // main queue
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            // activity spinner
                            self.indicator.stopAnimating()
                            
                            if (err != nil) {
                                switch err!.code{
                                case NSBundleOnDemandResourceOutOfSpaceError:
                                    let message = "You don't have enough storage left to download this resource."
                                    let alert = UIAlertController(title: "Not Enough Space",
                                        message: message,
                                        preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "OK",
                                        style: .Cancel, handler: nil))
                                    self.presentViewController(alert, animated: true,
                                        completion: nil)
                                case NSBundleOnDemandResourceExceededMaximumSizeError:
                                    assert(false, "The bundle resource was too large.")
                                default:
                                    assert(false, err!.description)
                                }
                            } else {
                                // Do something with the resources
                                self.startVideo()
                            }
                        })
                    }
                }
            })
        }
    }
    
    private func setupUI(){
        self.videoView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width*0.75)
        indicator.activityIndicatorViewStyle = .Gray
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath! == "fractionCompleted"){
            NSLog(String(self.resourceRequest.progress.fractionCompleted))
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.loadingLabel.text = "Loading "+String(Int(self.resourceRequest.progress.fractionCompleted*100))+"%"
            })
        }
        else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func startVideo(){
        let filePath = NSBundle.mainBundle().pathForResource("teeth", ofType: "mp4")
        let asset = AVURLAsset.init(URL: NSURL(fileURLWithPath:filePath!), options: nil)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerViewController.showsPlaybackControls = false
        playerViewController.player = player
        playerViewController.view.backgroundColor = UIColor.whiteColor()
        playerViewController.view.frame.size.width = self.videoView.frame.size.width
        playerViewController.view.frame.size.height = self.videoView.frame.size.height
        self.videoView.addSubview(playerViewController.view)
        playerViewController.player!.play()
    }
    
    private func pauseVideo(){
        self.playerViewController.player?.pause()
    }
    
    private func continueVideo(){
        if(self.playerViewController.player != nil && self.playerViewController.player?.status == AVPlayerStatus.ReadyToPlay){
            self.playerViewController.player?.play()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
