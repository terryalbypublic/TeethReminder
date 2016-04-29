//
//  Styles.swift
//  TeethReminder
//
//  Created by Alberti Terence on 29/04/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

public enum BackgroundColor {
    case Blue
}

public class Styles : NSObject {
    
    // UI configurations
    private static let tableViewBackgroundColorConfig = BackgroundColor.Blue
    
    
    // static methods
    public static func tableViewBackgroundColor() -> UIColor{
        if(tableViewBackgroundColorConfig == .Blue){
            return UIColor(red: 33/255, green: 134/255, blue: 239/255, alpha: 1)
        }
        return UIColor.blackColor()
    }
    
    public static func tableViewCellHeight() -> CGFloat{
        if(UIDevice.currentDevice().modelName == "iPhone4s"){
            return 100
        }
        else if(UIDevice.currentDevice().modelName == "iPhone 5"){
            return 100
        }
            
        else if(UIDevice.currentDevice().modelName  == "iPhone 5s"){
            return 140
        }
        else{
            return 140
        }

    }
    

}
