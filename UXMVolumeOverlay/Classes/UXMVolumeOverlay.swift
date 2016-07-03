//
//  UXMVolumeOverlay.swift
//  Pods
//
//  Created by Chris Anderson on 5/10/16.
//
//

import UIKit
import MediaPlayer

public protocol UXMVolumeProgress: class {
    var view: UIView { get }
    func progressChanged(progress: Float)
}

public class UXMVolumeOverlay:NSObject {

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
    
    /// Indicator object for displaying current volume to user
    public lazy var progressIndicator:UXMVolumeProgress = UXMVolumeProgressView()
    
    public var backgroundColor:UIColor = UIColor.whiteColor() {
        didSet {
            self.volumeWindow.backgroundColor = backgroundColor
        }
    }
    
    /// Shared handler for the overlay
    public static var sharedOverlay = UXMVolumeOverlay()
    
    var displayTimer:NSTimer?
    
    override init() {
        
        let windows = UIApplication.sharedApplication().windows
        
        super.init()
        
        windows.first?.addSubview(self.volumeView)

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
    
    /// Loads the volume indicator override onto the view controller
    ///
    /// - Parameter progressIndicator: An indicator that conforms to the UXMVolumeProgress 
    ///     protocol
    public func load(progressIndicator: UXMVolumeProgress = UXMVolumeProgressView()) {
        self.progressIndicator.view.removeFromSuperview()
        self.progressIndicator = progressIndicator
        self.volumeWindow.addSubview(progressIndicator.view)
    }
    
    /// Show the volume indicator
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
    
    /// Hide the volume indicator
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
        self.progressIndicator.progressChanged(volume)
        self.show()
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
        self.progressIndicator.view.frame = CGRectMake(10.0, 10.0, screen.width - 20.0, 20.0)
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
