#
# Be sure to run `pod lib lint JCustomSegmentControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'JCustomSegmentControl'
    s.version          = '1.0.3'
    s.summary          = 'A customizable segment control with scrolling support for iOS.'
    s.homepage         = 'https://github.com/JaiminiPatel14/JCustomSegmentControl'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Jaimini Patel' => 'jaiminibhensdadiya1996@gmail.com' }
    s.source           = { :git => 'https://github.com/JaiminiPatel14/JCustomSegmentControl.git', :tag => s.version }
    s.source_files = 'JCustomSegmentControl/Classes/**/*.{swift}'
    s.resource_bundles = {
        'JCustomSegmentControl' => ['JCustomSegmentControl/Assets/*.gif']
    }
    s.ios.deployment_target = '15.0'
    s.swift_version    = '5.0'
    
    s.description      = <<-DESC
    JCustomSegmentControl is a highly customizable segment control with built-in scrolling functionality.
    It allows you to create dynamic, interactive segment controls with smooth scrolling, making it ideal for apps with multiple tabs or categories.
    DESC
end
