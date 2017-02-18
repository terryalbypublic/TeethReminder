//
//  SetTimeViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 09/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit
import Firebase

open class SetTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet open weak var saveButton: UIButton!
    
    open var reminder : Reminder = Reminder()
    var pickerDataHours : Array<String> = []
    var pickerDataMinutes : Array<String> = []
    let calendar = Calendar.current
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // tracking
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemName: "openSetTimeView" as NSObject
            ])
    }
    
    open func refresh(){
        fillMinutesData()
        fillHoursData()
        restoreValuesFromEntity()
    }

    func restoreValuesFromEntity(){
        
        let date = reminder.datetime
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date as Date)
        
        let minutes = components.minute
        let hour = components.hour
        
        self.timePicker.selectRow(hour!, inComponent: 0, animated: false)
        self.timePicker.selectRow(minutes!, inComponent: 1, animated: false)
    }
    
    
    @IBAction func buttonOkTouchedDown(_ sender: OkButtonView) {
        sender.highlight = true
        sender.setNeedsDisplay()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        let minutes = self.timePicker.selectedRow(inComponent: 1)
        let hours = self.timePicker.selectedRow(inComponent: 0)
        
        var datecomponents = DateComponents()
        datecomponents.minute = minutes
        datecomponents.hour = hours
        
        reminder.datetime = calendar.date(from: datecomponents)!
        ReminderList.sharedInstance.serializeAndSave()
//        
//        let alert = UIAlertController(title: "Saved", message: "Successful saved!", preferredStyle: UIAlertControllerStyle.Alert)
//        self.presentViewController(alert, animated: true, completion: nil)
//        alert.dismissViewControllerAnimated(false, completion: nil)

        
    }

    override open func didReceiveMemoryWarning() {
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
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 1){
            return pickerDataMinutes.count;
        }
        return pickerDataHours.count;
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String? {
        if(component == 1){
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
