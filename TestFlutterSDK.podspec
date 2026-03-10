Pod::Spec.new do |s|
  s.name             = 'TestFlutterSDK'
  s.version          = '1.0.1'
  s.summary          = 'A simple Hello World Flutter SDK for iOS.'
  s.description      = <<-DESC
    TestSDK is a Flutter-based Hello World SDK.
    It provides a pre-built XCFramework that host iOS apps
    can integrate via CocoaPods without needing Flutter installed.
  DESC

  s.homepage         = 'https://github.com/gulsher73/test_sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gulsher' => 'gulsher@code-brew.com' }

  # ---------------------------------------------------------------------------
  # Source: a zip of the pre-built XCFrameworks + Swift wrapper hosted on
  # GitHub Releases. Update this URL after each release.
  # ---------------------------------------------------------------------------
  s.source = {
    :http   => 'https://github.com/gulsher73/test_sdk/releases/download/1.0.1/TestFlutterSDK-1.0.1.zip',
    :sha256 => 'd689ff9ce956ee291bbe9f349f7433fe05f9e74f239d68fa244d226a7ab7f809'
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
