Pod::Spec.new do |spec|
  spec.name = "EasyRtcClient"
  spec.version = "2.9.0"
  spec.summary = "EasyRTC Swift SDK. Easily build live audio or video experiences into your mobile app"
  spec.homepage = "https://github.com/EasyDSS/client-swift"
  spec.license = {:type => "MIT", :file => "LICENSE"}
  spec.author = "EasyRTC"

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.15"

  spec.swift_versions = ["5.9"]
  spec.source = {:git => "https://github.com/EasyDSS/client-swift.git", :tag => spec.version.to_s}

  spec.source_files = "Sources/**/*"

  spec.dependency("LiveKitWebRTC", "= 137.7151.10")
  spec.dependency("SwiftProtobuf")
  spec.dependency("DequeModule", "= 1.1.4")
  spec.dependency("OrderedCollections", "= 1.1.4")
  spec.dependency("JWTKit", "= 4.13.5")

  spec.resource_bundles = {"Privacy" => ["Sources/EasyRTC/PrivacyInfo.xcprivacy"]}

  xcode_output = `xcodebuild -version`.strip
  major_version = xcode_output =~ /Xcode\s+(\d+)/ ? $1.to_i : 15

  spec.pod_target_xcconfig = {
    "OTHER_SWIFT_FLAGS" => major_version >=15  ?
      "-enable-experimental-feature AccessLevelOnImport" : ""
  }
end
