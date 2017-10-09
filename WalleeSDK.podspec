# https://guides.cocoapods.org/syntax/podspec.html#source
Pod::Spec.new do |s|
  s.name             = 'WalleeSDK'
  s.version          = '1.0.2'
  s.summary          = 'WalleeSDK for iOS Apps implementing payment via Wallee payment service'
  s.homepage         = 'https://wallee.com'
  s.license          = { :type => 'Apache 2', :file => 'LICENSE' }
  s.authors          = { 'CustomWeb' => 'info@customweb.com'}
  
  s.source           = { :git => 'https://github.com/wallee-payment/wallee-ios-sdk.git', :tag => "v"+s.version.to_s}

  s.requires_arc                   = true
  s.platform                       = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = 'WalleeSDK/WalleeSDK/**/*.{h,m}'
  s.ios.resource_bundle = { 'WalleeSDK' => 'WalleeSDK/WalleeSDK/Resources/**/*' }
  s.private_header_files = 'WalleeSDK/WalleeSDK/Private/*.h'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
