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

class VideoViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    let resourceRequest = NSBundleResourceRequest(tags: NSSet(array: ["teethvideo"]) as! Set<String>)
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getResources()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupUI(){
        self.view.backgroundColor = Styles.tableViewBackgroundColor()
        self.videoView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width*0.75)
        indicator.activityIndicatorViewStyle = .Gray
        indicator.center = view.center
        view.addSubview(indicator)
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
                                print("Error: \(err)")
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath! == "fractionCompleted"){
            NSLog(String(self.resourceRequest.progress.fractionCompleted))
        }
        else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    private func startVideo(){
        let filePath = NSBundle.mainBundle().pathForResource("teeth", ofType: "mp4")
        let asset = AVURLAsset.init(URL: NSURL(fileURLWithPath:filePath!), options: nil)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = false
        playerViewController.player = player
        self.videoView.addSubview(playerViewController.view)
        playerViewController.player!.play()
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
