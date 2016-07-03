//
//  UXMVolumeProgressView.swift
//  Pods
//
//  Created by Chris Anderson on 7/3/16.
//
//

import Foundation

public class UXMVolumeProgressView: UIView {
    
    public var trackColor:UIColor = UIColor.blackColor() {
        didSet {
            self.volumeProgress.progressTintColor = trackColor
        }
    }
    
    lazy var volumeProgress:UIProgressView = {
        let screen = UIScreen.mainScreen().bounds
        var volumeProgress = UIProgressView(frame: CGRectMake(10.0, 10.0, screen.width - 20.0, 20.0))
        volumeProgress.progress = 0.0
        volumeProgress.trackTintColor = UIColor.clearColor()
        volumeProgress.progressTintColor = self.trackColor
        return volumeProgress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        self.addSubview(volumeProgress)
    }
}

extension UXMVolumeProgressView: UXMVolumeProgress {
    
    public var view: UIView { return self }
    
    public func progressChanged(progress: Float) {
        
        self.volumeProgress.progress = progress
    }
}
