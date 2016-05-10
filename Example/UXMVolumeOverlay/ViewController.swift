//
//  ViewController.swift
//  UXMVolumeOverlay
//
//  Created by Chris Anderson on 05/10/2016.
//  Copyright (c) 2016 Chris Anderson. All rights reserved.
//

import UIKit
import UXMVolumeOverlay
import MediaPlayer

class ViewController: UIViewController {

    var audioPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! AVAudioSession.sharedInstance().setActive(true)
        
        let url = NSURL(string: "http://91.132.6.21:8001")!
        audioPlayer = AVPlayer(URL: url)
        audioPlayer.play()
        
        UXMVolumeOverlay.sharedOverlay.load()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

