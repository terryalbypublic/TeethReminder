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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupObservers()
        self.setupUI()
        
        if(OndemandResources.videoDownloaded){
            self.startVideo()
        }
    }
    
    private func setupObservers(){
        OndemandResources.notifications.addObserver(self, selector: #selector(videoDownloadFinished), name: "videoDownloadFinished", object: nil)
        OndemandResources.notifications.addObserver(self, selector: #selector(videoDownloadStarted), name: "videoDownloadStarted", object: nil)
        OndemandResources.resourceRequest.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.New, .Initial], context: nil)
        
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
    
    
    func videoDownloadStarted(){
        self.indicator.startAnimating()
        self.startVideo()
    }
    
    func videoDownloadFinished(){
        self.indicator.stopAnimating()
        if(OndemandResources.videoDownloaded){
            self.startVideo()
        }
        else if(OndemandResources.errorCode > 0){
            switch OndemandResources.errorCode{
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
                assert(false, OndemandResources.errorCode.description)
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    private func setupUI(){
        self.videoView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width*0.75)
        indicator.activityIndicatorViewStyle = .Gray
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath! == "fractionCompleted"){
            NSLog(String(OndemandResources.resourceRequest.progress.fractionCompleted))
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.loadingLabel.text = "Loading "+String(Int(OndemandResources.resourceRequest.progress.fractionCompleted*100))+"%"
            })
        }
        else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func startVideo(){
        OndemandResources.notifications.removeObserver(self)
        let filePath = NSBundle.mainBundle().pathForResource("teeth", ofType: "mp4")
        let asset = AVURLAsset.init(URL: NSURL(fileURLWithPath:filePath!), options: nil)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerViewController.showsPlaybackControls = false
        playerViewController.player = player
        playerViewController.view.backgroundColor = UIColor.whiteColor()
        playerViewController.view.frame.size.width = self.videoView.frame.size.width
        playerViewController.view.frame.size.height = self.videoView.frame.size.height
        playerViewController.view.frame.origin.y += 1.5
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
    

}
