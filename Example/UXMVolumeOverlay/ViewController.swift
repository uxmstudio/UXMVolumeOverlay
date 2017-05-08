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
        
        /// This url is just for example purposes. Any audio will do
        let url = URL(string: "http://91.132.6.21:8001")!
        audioPlayer = AVPlayer(url: url)
        audioPlayer.play()
        
        UXMVolumeOverlay.shared.load()
    }
}

