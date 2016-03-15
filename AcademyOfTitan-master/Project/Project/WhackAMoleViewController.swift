//
//  ViewController.swift
//  Demo
//
//  Created by cisstudents on 11/11/14.
//  Copyright (c) 2014 cisstudents. All rights reserved.
//

import UIKit

class WhackAMoleViewController: UIViewController {
    
    @IBOutlet var holes: [UIImageView]!
    @IBOutlet var time: UILabel!
    
    var timelimit = 60
    var lives = 5
    var moles_spawn = 1
    var active_moles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.time.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        var alert = UIAlertController(title: "Whack-A-Mole", message: "The moles are attacking!\n[story]\nDouble tap on the mounds to deter any moles from surfacing. Do not let 5 or more moles reach the surface.\nAre you ready?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Start", style: UIAlertActionStyle.Default) {
            Void in self.restart()
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(sender: NSTimer) {
        self.time.text = "\(--self.timelimit)"
        
        if ( self.lives <= 0 ) {
            sender.invalidate()
            return
        }
        
        if ( self.timelimit == 0 ) {
            sender.invalidate()
            
            var alert = UIAlertController(title: "Congratulations", message: "You defeated the moles!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                Void in self.restart()
                })
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) {
                Void in self.dismissViewControllerAnimated(true, completion: nil)
                })
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if ( 30 < self.timelimit && self.timelimit <= 45) {
            self.moles_spawn = 2
        }
        else if ( 15 < self.timelimit && self.timelimit <= 30) {
            self.moles_spawn = 3
        }
        else if ( 0 < self.timelimit && self.timelimit <= 15) {
            self.moles_spawn = 4
        }
        
        if ( self.timelimit % 5 == 0 ) {
            var random = Int(arc4random_uniform(9))
            
            for _ in (1...self.moles_spawn) {
 //               while ( self.active_moles < 9 && self.holes[random].backgroundColor != UIColor.greenColor() ) {
                while ( self.active_moles < 9 && self.holes[random].image != nil ) {
                    random = Int(arc4random_uniform(9))
                }
                
                if ( self.active_moles == 9 ) {
                    break
                }
                
//                self.holes[random].backgroundColor = UIColor.yellowColor()
                self.holes[random].image = UIImage(named: "5.png")
                self.active_moles++
                NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: Selector("moleattack:"), userInfo: random, repeats: true)
            }
        }
    }
    
    func moleattack(sender: NSTimer) {
        var index = sender.userInfo as Int
        
        if ( self.holes[index].image == UIImage(named: "5.png") ) {
            self.holes[index].image = UIImage(named: "4.png")
        }
        
//        if ( self.holes[index].backgroundColor == UIColor.yellowColor() ) {
//            self.holes[index].backgroundColor = UIColor.redColor()
        else if ( self.holes[index].image == UIImage(named: "4.png") ) {
            sender.invalidate()
            self.holes[index].image = UIImage(named: "MoleRat.png")

            if ( --self.lives == 0 ) {
                var alert = UIAlertController(title: "Gameover", message: "Out of lives!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                    Void in self.restart()
                    })
                alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default) {
                    Void in self.dismissViewControllerAnimated(true, completion: nil)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func restart() {
        for hole in self.holes {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: "tapHole:")
            tapGesture.numberOfTapsRequired = 2
            
            hole.addGestureRecognizer(tapGesture)
            hole.userInteractionEnabled = true
  //          hole.backgroundColor = UIColor.greenColor()
            hole.image = nil
        }
        
        self.timelimit = 60
        self.lives = 5
        self.moles_spawn = 1
        self.active_moles = 0
        self.time.text = "\(self.timelimit)"
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    func tapHole(sender: UITapGestureRecognizer) {
        let hole = sender.view? as UIImageView
        
 //       if ( hole?.backgroundColor == UIColor.yellowColor() ) {
 //           hole?.backgroundColor = UIColor.greenColor()
        if ( hole.image == UIImage(named: "5.png") || hole.image == UIImage(named: "4.png")  ) {
            hole.image = nil
            self.active_moles--
        }
    }
}

