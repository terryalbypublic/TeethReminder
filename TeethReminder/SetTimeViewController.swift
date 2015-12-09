//
//  SetTimeViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 09/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

class SetTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var hoursPicker: UIPickerView!
    
    var pickerDataHours : Array<String> = []
    var pickerDataMinutes : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minutesPicker.delegate = self
        self.hoursPicker.delegate = self
        
        self.minutesPicker.dataSource = self
        self.hoursPicker.dataSource = self
        
        fillMinutesData()
        fillHoursData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillMinutesData(){
        
        pickerDataMinutes = Array<String>()
        
        for i in 0...59{
            pickerDataMinutes.append(String(i)+" min")
        }
    }
    
    func fillHoursData(){
        
        pickerDataHours = Array<String>()
        
        for i in 0...23{
            pickerDataHours.append(String(i)+" h")
        }
    }
    
    
    // MARK: - Picker Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.minutesPicker){
            return pickerDataMinutes.count;
        }
        
        return pickerDataHours.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView == self.minutesPicker){
            return pickerDataMinutes[row]
        }
        
        return pickerDataHours[row]
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
