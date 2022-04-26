#
# Be sure to run `pod lib lint XMHandySwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMHandySwift'
  s.version          = '1.0.2'
  s.summary          = 'A handy collection of more than 500 native Swift extensions to boost your productivity.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  XMHandySwift is a collection of over 500 native Swift extensions, with handy methods, syntactic sugar, and performance improvements for wide range of primitive data types, UIKit and Cocoa classes –over 500 in 1– for iOS, macOS, tvOS and watchOS.
                       DESC

  s.homepage         = 'https://github.com/IceSilkworm/XMHandySwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'IceSilkworm' => 'renruyun@163.com' }
  s.source           = { :git => 'https://github.com/IceSilkworm/XMHandySwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios
  s.ios.deployment_target = '9.0'

  s.default_subspec = 'HandySwift'
  s.subspec 'HandySwift' do |h|
    h.source_files = 'XMHandySwift/Classes/**/*'
  end

  s.subspec 'Core' do |c|
    c.source_files = 'XMHandySwift/Classes/Core/*'
  end
  
  s.subspec 'Extensions' do |e|
    e.source_files = 'XMHandySwift/Classes/Extensions/*'
  end
  
  s.subspec 'Vendors' do |v|
    v.source_files = 'XMHandySwift/Classes/Vendors/**/*'
#      vendors.dependency 'HandySwift/Core'
  end
  
  # s.resource_bundles = {
  #   'XMHandySwift' => ['XMHandySwift/Assets/*.png']
  # }

  s.swift_version = '4.2'
  s.requires_arc = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'DeviceKit'


end
