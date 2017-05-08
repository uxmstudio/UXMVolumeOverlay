//
//  UXMVolumeProgressView.swift
//  Pods
//
//  Created by Chris Anderson on 7/3/16.
//
//

import Foundation

open class UXMVolumeProgressView: UIView {
    
    open var trackColor:UIColor = UIColor.black {
        didSet {
            self.volumeProgress.progressTintColor = trackColor
        }
    }
    
    lazy var volumeProgress:UIProgressView = {
        let screen = UIScreen.main.bounds
        var volumeProgress = UIProgressView(frame: CGRect(x: 10.0, y: 10.0, width: screen.width - 20.0, height: 20.0))
        volumeProgress.progress = 0.0
        volumeProgress.trackTintColor = UIColor.clear
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
    
    public func changed(progress: Float) {
        
        self.volumeProgress.progress = progress
    }
}
