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
import Firebase

class VideoViewController : UIViewController {

    @IBOutlet weak var loadingView: UIProgressView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    var errorView : UIView!
    let indicator = UIActivityIndicatorView()
    let playerViewController = AVPlayerViewController()
    fileprivate var foregroundNotification: NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupObservers()
        self.setupUI()
        
        if(OndemandResources.videoDownloaded){
            self.startVideo()
        }
        
        setErrorOnUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // tracking
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemName: "openVideoView" as NSObject
            ])
    }
    
    fileprivate func setupObservers(){
        OndemandResources.notifications.addObserver(self, selector: #selector(videoDownloadFinished), name: NSNotification.Name(rawValue: Constants.videoDownloadFinished), object: nil)
        OndemandResources.notifications.addObserver(self, selector: #selector(videoDownloadStarted), name: NSNotification.Name(rawValue: Constants.videoDownloadStarted), object: nil)
        OndemandResources.resourceRequest.progress.addObserver(self, forKeyPath: "fractionCompleted", options: [.new, .initial], context: nil)
        
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [unowned self] notification in
            
            self.continueVideo()
            // do whatever you want when the app is brought back to the foreground
        }
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NotificationCenter.default.removeObserver(foregroundNotification)
        NotificationCenter.default.removeObserver(self)
        
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
            setErrorOnUI()
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    fileprivate func setupUI(){
        self.videoView.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.width*0.75)
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        view.addSubview(indicator)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "warningViewController")
        self.errorView = vc.view
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath! == "fractionCompleted"){
            NSLog(String(OndemandResources.resourceRequest.progress.fractionCompleted))
            
            OperationQueue.main.addOperation({
                self.loadingLabel.text = "Loading "+String(Int(OndemandResources.resourceRequest.progress.fractionCompleted*100))+"%"
                self.loadingView.setProgress(Float(OndemandResources.resourceRequest.progress.fractionCompleted), animated: true)
            })
        }
        else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func startVideo(){
        OndemandResources.notifications.removeObserver(self)
        let filePath = Bundle.main.path(forResource: "teeth", ofType: "mp4")
        let asset = AVURLAsset.init(url: URL(fileURLWithPath:filePath!), options: nil)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        playerViewController.showsPlaybackControls = true
        playerViewController.player = player
        playerViewController.view.backgroundColor = UIColor.white
        playerViewController.view.frame.size.width = self.videoView.frame.size.width
        playerViewController.view.frame.size.height = self.videoView.frame.size.height
        playerViewController.view.frame.origin.y += 1.5
        self.videoView.addSubview(playerViewController.view)
        
        // Invoke after player is created and AVPlayerItem is specified
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(playerItemDidReachEnd),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: player.currentItem)
        
        playerViewController.player!.play()
    }
    
    fileprivate func pauseVideo(){
        self.playerViewController.player?.pause()
    }
    
    fileprivate func continueVideo(){
        if(self.playerViewController.player != nil && self.playerViewController.player?.status == AVPlayerStatus.readyToPlay){
            self.playerViewController.player?.play()
        }
    }
    
    func playerItemDidReachEnd(_ notification: Notification) {
        self.playerViewController.player!.seek(to: kCMTimeZero)
        self.playerViewController.player!.play()
    }
    
    func setErrorOnUI(){
        if(OndemandResources.errorCode > 0){
            switch OndemandResources.errorCode{
            case NSBundleOnDemandResourceOutOfSpaceError:
                self.view.addSubview(errorView)
            default:
                assert(false, OndemandResources.errorCode.description)  // todo
            }
        }
    }
    

}
