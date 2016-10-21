//
//  Styles.swift
//  TeethReminder
//
//  Created by Alberti Terence on 29/04/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public enum BackgroundColor {
    case blue; case grey; case white
}

public enum ButtonBackgroundColor {
    case blue; case blueHighlighted; case white
}


public enum FontColor{
    case white; case blue
}

open class Styles : NSObject {
    
    // UI configurations
    fileprivate static let tableViewBackgroundColorConfig = BackgroundColor.blue
    fileprivate static let navigationTableViewBackgroundColorConfig = BackgroundColor.white
    
    
    
    // static methods
    open static func tableViewBackgroundColor() -> UIColor{
        if(tableViewBackgroundColorConfig == .blue){
            return blueColor()
        }
        return UIColor.black
    }
    
    open static func tableViewCellHeight() -> CGFloat{
        if(CurrentDevice.device.modelName == "iPhone 4s"){
            return 100
        }
        else if(CurrentDevice.device.modelName == "iPhone 5"){
            return 100
        }
            
        else if(CurrentDevice.device.modelName  == "iPhone 5s"){
            return 140
        }
        else{
            return 140
        }
    }
    
    open static func navigationBackgroundColor() -> UIColor{
        if(navigationTableViewBackgroundColorConfig == .grey){
            return greyColor()
        }
        else if(navigationTableViewBackgroundColorConfig == .white){
            return UIColor.white
        }
        return UIColor.black
    }
    
    open static func fontColor(_ fontColor:FontColor) -> UIColor{
        if(fontColor == .blue){
            return blueColor()
        }
        else if(fontColor == .white){
            return UIColor.white
        }
        return UIColor.black
    }
    
    
    open static func buttonBackgroundColor(_ color:ButtonBackgroundColor) -> UIColor{
        if(color == .blue){
            return blueColor()
        }
            
        else if(color == .blueHighlighted){
            return blueHighlightedColor()
        }
            
            
        else if(color == .white){
            return UIColor.white
        }
        return UIColor.black
    }
    
    fileprivate static func blueColor()->UIColor{
        return UIColor(red:19/255, green:85/255, blue:181/255, alpha:1)
    }
    
    fileprivate static func greyColor()->UIColor{
        return UIColor(red: 218/255, green: 211/255, blue: 224/255, alpha: 1)
    }
    
    fileprivate static func blueHighlightedColor()->UIColor{
        return UIColor(red:19/255, green:100/255, blue:181/255, alpha:1)
    }
    
    

}
