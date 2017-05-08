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
    func changed(progress: Float)
}

open class UXMVolumeOverlay: NSObject {
    
    lazy var volumeView: MPVolumeView = {
        var volumeView = MPVolumeView(frame: CGRect(x: -2000.0, y: -2000.0, width: 0.0, height: 0.0))
        volumeView.alpha = 0.1
        volumeView.isUserInteractionEnabled = false
        return volumeView
    }()
    
    lazy var volumeWindow: UIWindow = {
        let screen = UIScreen.main.bounds
        var volumeWindow = UIWindow(frame: CGRect(x: 0.0, y: -20.0, width: screen.width, height: 20.0))
        volumeWindow.backgroundColor = self.backgroundColor
        volumeWindow.windowLevel = UIWindowLevelStatusBar + 1
        volumeWindow.rootViewController = UXMVolumeOverlayController()
        return volumeWindow
    }()
    
    /// Indicator object for displaying current volume to user
    open lazy var progressIndicator: UXMVolumeProgress = UXMVolumeProgressView()
    
    open var backgroundColor: UIColor = UIColor.white {
        didSet {
            self.volumeWindow.backgroundColor = backgroundColor
        }
    }
    
    /// Shared handler for the overlay
    open static var shared = UXMVolumeOverlay()
    
    var displayTimer: Timer?
    
    /// Keys
    let volumeNotificationKey = "AVSystemController_SystemVolumeDidChangeNotification"
    let volumeParameterKey = "AVSystemController_AudioVolumeNotificationParameter"
    
    override init() {
        
        let windows = UIApplication.shared.windows
        
        super.init()
        
        windows.first?.addSubview(self.volumeView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UXMVolumeOverlay.volumeChanged(_:)),
            name: NSNotification.Name(rawValue: volumeNotificationKey),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UXMVolumeOverlay.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func volumeChanged(_ notification: Notification) {
        if let volume = notification.userInfo?[volumeParameterKey] as? Float {
            self.set(volume: volume)
        }
    }
    
    /// Loads the volume indicator override onto the view controller
    ///
    /// - Parameter progressIndicator: An indicator that conforms to the UXMVolumeProgress
    ///     protocol
    open func load(progressIndicator: UXMVolumeProgress = UXMVolumeProgressView()) {
        self.progressIndicator.view.removeFromSuperview()
        self.progressIndicator = progressIndicator
        self.volumeWindow.addSubview(progressIndicator.view)
    }
    
    /// Show the volume indicator
    open func show() {
        self.restartTimer()
        
        let screen = UIScreen.main.bounds
        self.volumeWindow.isHidden = false
        self.volumeWindow.makeKeyAndVisible()
        self.volumeWindow.layer.removeAllAnimations()
        UIWindow.animate(withDuration: 0.25, animations: {
            
            self.volumeWindow.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: 20.0)
        })
    }
    
    /// Hide the volume indicator
    open func hide() {
        let screen = UIScreen.main.bounds
        self.volumeWindow.layer.removeAllAnimations()
        UIWindow.animate(withDuration: 0.25, animations: {
            
            self.volumeWindow.frame = CGRect(x: 0.0, y: -20.0, width: screen.width, height: 20.0)
        }, completion: { (completed) in
            self.volumeWindow.isHidden = true
        })
    }
    
    func set(volume: Float) {
        self.progressIndicator.changed(progress: volume)
        self.show()
    }
    
    func restartTimer() {
        if self.displayTimer != nil {
            self.displayTimer?.invalidate()
            self.displayTimer = nil
        }
        
        self.displayTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(UXMVolumeOverlay.hide),
            userInfo: nil,
            repeats: false
        )
    }
    
    func rotated() {
        let screen = UIScreen.main.bounds
        self.volumeWindow.frame = CGRect(x: 0.0, y: -20.0, width: screen.width, height: 20.0)
        self.progressIndicator.view.frame = CGRect(x: 10.0, y: 10.0, width: screen.width - 20.0, height: 20.0)
    }
}

class UXMVolumeOverlayController:UIViewController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
}
