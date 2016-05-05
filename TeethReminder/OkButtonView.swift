//
//  OkButtonView.swift
//  TeethReminder
//
//  Created by Alberti Terence on 06/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit


@IBDesignable public class OkButtonView: UIButton {

    
    public var highlight : Bool = false
    
    override public func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        var backgroundColor : UIColor = UIColor.redColor();
        
        if(highlight){
            backgroundColor = Styles.buttonBackgroundColor(.BlueHighlighted)
        }
        else{
            backgroundColor = Styles.buttonBackgroundColor(.Blue)
        }
        
        backgroundColor.setFill()
        
        path.fill()

        //create the path
        let checkPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        checkPath.lineWidth = 2.5
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        checkPath.moveToPoint(CGPoint(
            x:bounds.width/4 + 3,
            y:bounds.height/2 + 5))
        
        //add a point to the path at the end of the stroke
        checkPath.addLineToPoint(CGPoint(
            x:bounds.width/4 + 13,
            y:bounds.height/2 + 15))
        
        checkPath.addLineToPoint(CGPoint(
            x:bounds.width*0.75,
            y:bounds.height*0.3-5))
        
        //set the stroke color
        UIColor.whiteColor().setStroke()
        
        //draw the stroke
        checkPath.stroke()
    }
 
    

}
