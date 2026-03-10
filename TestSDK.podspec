Pod::Spec.new do |s|
  s.name             = 'TestSDK'
  s.version          = '1.0.0'
  s.summary          = 'A simple Hello World Flutter SDK for iOS.'
  s.description      = <<-DESC
    TestSDK is a Flutter-based Hello World SDK.
    It provides a pre-built XCFramework that host iOS apps
    can integrate via CocoaPods without needing Flutter installed.
  DESC

  s.homepage         = 'https://github.com/YOURUSERNAME/test_sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AlfaPay' => 'dev@alfapay.com' }

  # ---------------------------------------------------------------------------
  # Source: a zip of the pre-built XCFrameworks + Swift wrapper hosted on
  # GitHub Releases. Update this URL after each release.
  # ---------------------------------------------------------------------------
  s.source = {
    :http => 'https://github.com/YOURUSERNAME/test_sdk/releases/download/1.0.0/TestSDK-1.0.0.zip'
  }

  s.ios.deployment_target = '12.0'
  s.swift_version         = '5.0'

  # Swift wrapper source (included inside the zip at ios/Classes/)
  s.source_files = 'ios/Classes/**/*.swift'

  # Pre-built Flutter XCFrameworks (included inside the zip at Frameworks/)
  s.vendored_frameworks = [
    'Frameworks/Flutter.xcframework',
    'Frameworks/App.xcframework'
  ]

  # Flutter requires these system frameworks
  s.frameworks = 'UIKit', 'Foundation'
end
