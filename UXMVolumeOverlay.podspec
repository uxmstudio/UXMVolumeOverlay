#
# Be sure to run `pod lib lint UXMVolumeOverlay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "UXMVolumeOverlay"
s.version          = "0.2.0"
s.summary          = "A drop in replacement for the iOS volume overlay."
s.description      = "A drop in replacement for the annoying volume overlay; inspired by Instagram & Snapchat."

s.homepage         = "https://github.com/uxmstudio/UXMVolumeOverlay"
s.license          = 'MIT'
s.author           = { "Chris Anderson" => "chris@uxmstudio.com" }
s.source           = { :git => "https://github.com/uxmstudio/UXMVolumeOverlay.git", :tag => s.version.to_s }
s.platform     = :ios, '8.0'
s.requires_arc = true

s.ios.source_files = 'Pod/Classes/**/*'
end
