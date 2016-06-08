//
//  UXMVolumeOverlay.swift
//  Pods
//
//  Created by Chris Anderson on 5/10/16.
//
//

import UIKit
import MediaPlayer

public class UXMVolumeOverlay: NSObject {

    lazy var volumeView:MPVolumeView = {
        var volumeView = MPVolumeView(frame: CGRectMake(-2000.0, -2000.0, 0.0, 0.0))
        volumeView.alpha = 0.1
        volumeView.userInteractionEnabled = false
        return volumeView
    }()
    
    lazy var volumeWindow:UIWindow = {
        let screen = UIScreen.mainScreen().bounds
        var volumeWindow = UIWindow(frame: CGRectMake(0.0, -20.0, screen.width, 20.0))
        volumeWindow.backgroundColor = self.backgroundColor
        volumeWindow.windowLevel = UIWindowLevelStatusBar + 1
        volumeWindow.rootViewController = UXMVolumeOverlayController()
        return volumeWindow
    }()
    
    lazy var volumeProgress:UIProgressView = {
        let screen = UIScreen.mainScreen().bounds
        var volumeProgress = UIProgressView(frame: CGRectMake(10.0, 10.0, screen.width - 20.0, 20.0))
        volumeProgress.progress = 0.0
        volumeProgress.trackTintColor = UIColor.clearColor()
        volumeProgress.progressTintColor = self.trackColor
        return volumeProgress
    }()
    
    public var backgroundColor:UIColor = UIColor.whiteColor() {
        didSet {
            self.volumeWindow.backgroundColor = backgroundColor
        }
    }
    
    public var trackColor:UIColor = UIColor.blackColor() {
        didSet {
            self.volumeProgress.progressTintColor = UIColor.blackColor()
        }
    }
    
    public static var sharedOverlay = UXMVolumeOverlay()
    
    var displayTimer:NSTimer?
    
    override init() {
        
        let windows = UIApplication.sharedApplication().windows
        
        super.init()
        
        windows.first?.addSubview(volumeView)
        volumeWindow.addSubview(volumeProgress)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UXMVolumeOverlay.volumeChanged(_:)), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UXMVolumeOverlay.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func volumeChanged(notification: NSNotification) {
        if let volume = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
            self.setVolume(volume)
        }
    }
    
    public func load() { }
    
    public func show() {
        self.restartTimer()
        
        let screen = UIScreen.mainScreen().bounds
        self.volumeWindow.hidden = false
        self.volumeWindow.makeKeyAndVisible()
        self.volumeWindow.layer.removeAllAnimations()
        UIWindow.animateWithDuration(0.25, animations: {
            
            self.volumeWindow.frame = CGRectMake(0.0, 0.0, screen.width, 20.0)
        })
    }
    
    public func hide() {
        let screen = UIScreen.mainScreen().bounds
        self.volumeWindow.layer.removeAllAnimations()
        UIWindow.animateWithDuration(0.25, animations: {
            
            self.volumeWindow.frame = CGRectMake(0.0, -20.0, screen.width, 20.0)
        }) { (completed) in
            self.volumeWindow.hidden = true
        }
    }
    
    func setVolume(volume: Float) {
        volumeProgress.progress = volume
        show()
    }
    
    func restartTimer() {
        if self.displayTimer != nil {
            self.displayTimer?.invalidate()
            self.displayTimer = nil
        }
        
        self.displayTimer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                                   target: self,
                                                                   selector: #selector(UXMVolumeOverlay.hide),
                                                                   userInfo: nil,
                                                                   repeats: false)
    }
    
    func rotated() {
        let screen = UIScreen.mainScreen().bounds
        self.volumeWindow.frame = CGRectMake(0.0, -20.0, screen.width, 20.0)
        self.volumeProgress.frame = CGRectMake(10.0, 10.0, screen.width - 20.0, 20.0)
    }
}

class UXMVolumeOverlayController:UIViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
}
