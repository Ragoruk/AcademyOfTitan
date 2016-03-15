//
//  MovieController.swift
//  Project
//
//  Created by Kent on 12/8/14.
//  Copyright (c) 2014 Earth. All rights reserved.
//

import UIKit
import MediaPlayer

class MovieController: UIViewController {

    var moviePlayer: MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playbackDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
        self.playVideo()
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() {
        let path = NSBundle.mainBundle().pathForResource("RenderMoviecomp", ofType: "mp4")
        let url = NSURL.fileURLWithPath(path!)
        self.moviePlayer = MPMoviePlayerController(contentURL: url)
        if let player = moviePlayer {
            player.view.frame = self.view.bounds
            player.prepareToPlay()
            player.scalingMode = MPMovieScalingMode.AspectFit
            self.view.addSubview(player.view)
        }
    }
    
    func playbackDidFinish(notification: NSNotification) {
        
        var info = notification.userInfo!
        var reason = info[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as NSNumber
        if reason == MPMovieFinishReason.PlaybackEnded.rawValue {
            self.moviePlayer?.view.hidden = true
        }
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
