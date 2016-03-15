//
//  MasterMindViewController.swift
//  Demo
//
//  Created by cisstudents on 11/18/14.
//  Copyright (c) 2014 cisstudents. All rights reserved.
//

import UIKit

class MasterMindViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {

    @IBOutlet var slots: [UIPickerView]!
    
    @IBOutlet var correctPositions: UILabel!
    @IBOutlet var correctDigits: UILabel!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var counter: UILabel!
    var guessedRight = false
    var timelimit = 300
    
    let pickerData:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var secretcode:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.restart()
    }
    
    func restart() {
        self.timelimit = 300
        self.counter.text = "\(self.timelimit)"
        self.label.text = ""
        self.label.hidden = true
        self.correctPositions.text = "0"
        self.correctDigits.text = "0"
        self.secretcode = []
        for (index, slot) in enumerate(self.slots) {
            slot.selectRow(8190, inComponent: 0, animated: false)
            self.secretcode?.append("\(arc4random_uniform(10))")
            self.label.text = self.label.text! + self.secretcode![index]
        }
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func update(sender: NSTimer) {
        self.counter.text = "\(--self.timelimit)"
        
        if self.guessedRight {
            sender.invalidate()
            
            self.guessedRight = false
            var alert = UIAlertController(title: "Congratulations", message: "You cracked the code!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                Void in
                self.restart()
                })
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) {
                Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                })
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if ( self.timelimit == 0 ) {
            sender.invalidate()
            
            var alert = UIAlertController(title: "Gameover", message: "Time has run out!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                Void in
                self.restart()
                })
            alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default) {
                Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                })
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16384
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerData[row%10]
    }

    @IBAction func match(sender: AnyObject) {
        var correct_positions = 0
        var correct_digits = 0
        var code_copy = self.secretcode!
        var guess:[String] = []
        var index = 0
        
        for slot in slots {
            var selected = self.pickerData[slot.selectedRowInComponent(0)%10]
            
            if selected == code_copy[index] {
                code_copy.removeAtIndex(index)
                correct_positions++
            }
            else {
                guess.append(selected)
                index++
            }
        }
        
        for digit in guess {
            for index=0; index<code_copy.count; index++ {
                if digit == code_copy[index] {
                    correct_digits++
                    code_copy.removeAtIndex(index)
                }
            }
        }
        
        self.correctPositions.text = String(correct_positions)
        self.correctDigits.text = String(correct_digits)
        
        if self.correctPositions.text == "\(self.slots.count)" {
            self.guessedRight = true
        }
    }
}
