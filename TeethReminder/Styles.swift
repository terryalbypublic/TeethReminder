//
//  Styles.swift
//  TeethReminder
//
//  Created by Alberti Terence on 29/04/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public enum BackgroundColor {
    case Blue; case Grey; case White
}

public enum FontColor{
    case White; case Blue
}

public class Styles : NSObject {
    
    // UI configurations
    private static let tableViewBackgroundColorConfig = BackgroundColor.Blue
    private static let navigationTableViewBackgroundColorConfig = BackgroundColor.White
    
    
    
    // static methods
    public static func tableViewBackgroundColor() -> UIColor{
        if(tableViewBackgroundColorConfig == .Blue){
            return UIColor(red: 33/255, green: 134/255, blue: 239/255, alpha: 1)
        }
        return UIColor.blackColor()
    }
    
    public static func tableViewCellHeight() -> CGFloat{
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
    
    public static func navigationBackgroundColor() -> UIColor{
        if(navigationTableViewBackgroundColorConfig == .Grey){
            return UIColor(red: 218/255, green: 211/255, blue: 224/255, alpha: 1)
        }
        else if(navigationTableViewBackgroundColorConfig == .White){
            return UIColor.whiteColor()
        }
        return UIColor.blackColor()
    }
    
    public static func fontColor(fontColor:FontColor) -> UIColor{
        if(fontColor == .Blue){
            return UIColor(red:19/255, green:85/255, blue:181/255, alpha:1)
        }
        else if(fontColor == .White){
            return UIColor.whiteColor()
        }
        return UIColor.blackColor()
    }
    
    
    

}
