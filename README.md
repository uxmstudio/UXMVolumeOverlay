# UXMVolumeOverlay

[![Version](https://img.shields.io/cocoapods/v/UXMVolumeOverlay.svg?style=flat)](http://cocoapods.org/pods/UXMVolumeOverlay)
[![License](https://img.shields.io/cocoapods/l/UXMVolumeOverlay.svg?style=flat)](http://cocoapods.org/pods/UXMVolumeOverlay)
[![Platform](https://img.shields.io/cocoapods/p/UXMVolumeOverlay.svg?style=flat)](http://cocoapods.org/pods/UXMVolumeOverlay)

A drop in replacement for the annoying iOS volume overlay; inspired by Instagram & Snapchat.

## Screenshots
![uxmvolumescreenshot](https://uxmstudio.com/public/images/github/volume_display.png)

## Requirements
- iOS 8 or above
- Xcode 7 or above
- Swift 3.0

## Installation

UXMVolumeOverlay is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UXMVolumeOverlay"
```

## Usage
Using the volume overlay is just drag and drop. Simply call:
```swift
UXMVolumeOverlay.sharedOverlay.load()
```

You can create your own custom indicator by extending the protocol UXMVolumeProgress. This allows you to have any view display the progress indicator. The standard indicator is a UIProgressView like Instagram uses, but anything is possible.

```swift
\\\ UXMVolumeProgress
var view: UIView { get }
func progressChanged(progress: Float)
```

Your custom UXMVolumeProgress object is then passed to the handler on load.
```swift
var indicator = CustomIndicator()
UXMVolumeOverlay.sharedOverlay.load(indicator)
```

### Interface
```swift
func show()
func hide()

var backgroundColor:UIColor
```

### Demo Project
To run the example project, clone the repo with `git clone https://github.com/uxmstudio/UXMVolumeOverlay.git`, and run `pod install` from the Example directory first.

### Note
This will not get rid of the ringer dialog, only the volume dialog.

## Author
Chris Anderson:
- chris@uxmstudio.com
- [Home Page](http://uxmstudio.com)


## License

UXMVolumeOverlay is available under the MIT license. See the LICENSE file for more info.
