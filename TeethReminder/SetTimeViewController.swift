//
//  SetTimeViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 09/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class SetTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    @IBOutlet public weak var saveButton: UIButton!
    public var reminder : Reminder = Reminder()
    var pickerDataHours : Array<String> = []
    var pickerDataMinutes : Array<String> = []
    let calendar = NSCalendar.currentCalendar()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.minutesPicker.delegate = self
        self.hoursPicker.delegate = self
        self.minutesPicker.dataSource = self
        self.hoursPicker.dataSource = self
        
        fillMinutesData()
        fillHoursData()
        fillTextLabel()
        restoreValuesFromEntity()
        
        // Do any additional setup after loading the view.
    }
    

    func restoreValuesFromEntity(){
        
        let date = reminder.datetime
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        
        let minutes = components.minute
        let hour = components.hour
        
        self.hoursPicker.selectRow(hour, inComponent: 0, animated: false)
        self.minutesPicker.selectRow(minutes, inComponent: 0, animated: false)
        
        
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let minutes = self.minutesPicker.selectedRowInComponent(0)
        let hours = self.hoursPicker.selectedRowInComponent(0)
        
        let datecomponents = NSDateComponents()
        datecomponents.minute = minutes
        datecomponents.hour = hours
        
        reminder.datetime = calendar.dateFromComponents(datecomponents)!
        ReminderList.sharedInstance.serializeAndSave()
//        
//        let alert = UIAlertController(title: "Saved", message: "Successful saved!", preferredStyle: UIAlertControllerStyle.Alert)
//        self.presentViewController(alert, animated: true, completion: nil)
//        alert.dismissViewControllerAnimated(false, completion: nil)

        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTextLabel(){
        self.textLabel.text = reminder.name
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
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.minutesPicker){
            return pickerDataMinutes.count;
        }
        
        return pickerDataHours.count;
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String! {
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
