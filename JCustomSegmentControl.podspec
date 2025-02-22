#
# Be sure to run `pod lib lint JCustomSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JCustomSegmentControl'
  s.version          = '1.0.0'
  s.summary          = 'A customizable segment control with scrolling support for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
JCustomSegmentControl is a highly customizable segment control with built-in scrolling functionality.
It allows you to create dynamic, interactive segment controls with smooth scrolling, making it ideal for apps with multiple tabs or categories.
DESC

  s.homepage         = 'https://github.com/JaiminiPatel14/JCustomSegmentControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JaiminiPatel14' => 'jaiminibhensdadiya1996@gmail.com' }
  s.source           = { :git => 'https://github.com/JaiminiPatel14/JCustomSegmentControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'JCustomSegmentControl/Classes/**/*.{swift}'
  s.swift_version    = '5.0'
  # s.resource_bundles = {
  #   'JCustomSegmentControl' => ['JCustomSegmentControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
