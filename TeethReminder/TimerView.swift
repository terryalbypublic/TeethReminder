//
//  CounterView.swift
//  Animation
//
//  Created by Alberti Terence on 05/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

let LoadMaxPortions = 1000
let InitialMilliseconds = 150000
let π:CGFloat = CGFloat(M_PI)


@IBDesignable open class TimerView : UIView {
    
    var timerSeconds: Int {
        get {
            return InitialMilliseconds/1000 - ellapsedTime/1000
        }
    }
    
    open var isLoaded = false
    open var isRunning = false
    open var isFinished = false
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    var loadTimerPortions = 0
    var ellapsedTime = 0
    var timer : Timer = Timer()
    var displayLinkTimer : CADisplayLink = CADisplayLink()
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    
    
    override open func draw(_ rect: CGRect) {
        
        
        self.timerLabel.text = timeFormatted(self.timerSeconds)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let arcWidth: CGFloat = 35
        
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        let arcLengthPerGlass = angleDifference / CGFloat(LoadMaxPortions)
        
        var finalEndAngle = arcLengthPerGlass * CGFloat(loadTimerPortions) + startAngle
        
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: finalEndAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        let arcLengthWithTime = angleDifference / CGFloat(InitialMilliseconds)
        finalEndAngle = arcLengthWithTime * CGFloat(ellapsedTime) + startAngle
        
        let path2 = UIBezierPath(arcCenter: center,
                                 radius: radius/2 - arcWidth/2,
                                 startAngle: startAngle,
                                 endAngle: finalEndAngle,
                                 clockwise: true)
        
        path2.lineWidth = arcWidth
        outlineColor.setStroke()
        path2.stroke()
        
    }
    
    // public methods
    open func stopTimer(){
        if(self.isLoaded && self.isRunning){
            self.startLabel.text = "Continue"
            self.isRunning = false
            self.timer.invalidate()
            self.displayLinkTimer.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    
    // start the animation loading
    open func startLoadAnimation(){
        self.displayLinkTimer = CADisplayLink(target: self, selector: #selector(updateLoading))
        displayLinkTimer.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    // animation when the timer is started
    open func startTimerAnimation(){
        if(self.isLoaded && !self.isRunning && !isFinished){
            self.startLabel.text = "Stop"
            self.isRunning = true
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            self.displayLinkTimer = CADisplayLink(target: self, selector: #selector(updateTimer))
            displayLinkTimer.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        }
        else if(isFinished){
            resetTimer()
        }
    }
    
    // set timer to the initial time
    open func resetTimer(){
        if(isLoaded){
            isRunning = false
            isFinished = false
            self.startLabel.text = "Start"
            self.ellapsedTime = 0
            self.timer.invalidate()
            if(isRunning){
                self.displayLinkTimer.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            }
            self.setNeedsDisplay()
        }
    }
    
    
    // private methods
    func updateTime(){
        self.ellapsedTime += 50;
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // UI callbacks updater
    func updateTimer(){
        if(ellapsedTime == InitialMilliseconds){
            self.displayLinkTimer.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            self.isLoaded = true
            self.isRunning = false
            self.isFinished = true
            self.startLabel.text = "Finished!"
        }
        self.setNeedsDisplay()
    }
    
    func updateLoading(){
        if(loadTimerPortions == LoadMaxPortions){
            self.displayLinkTimer.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            self.isLoaded = true
            
        }
        else{
            loadTimerPortions += 20
            self.setNeedsDisplay()
        }
    }
}
