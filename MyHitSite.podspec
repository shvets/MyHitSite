Pod::Spec.new do |s|
  s.name         = "MyHitSite"
  s.version      = "1.0.2"
  s.summary      = "MyHit Site"
  s.description  = "MyHit Site."

  s.homepage     = "https://github.com/shvets/MyHitSite"
  s.authors = { "Alexander Shvets" => "alexander.shvets@gmail.com" }
  s.license      = "MIT"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

  s.ios.deployment_target = "10.0"
  #s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "10.0"
  #s.watchos.deployment_target = "2.0"

  s.source = { :git => "https://github.com/shvets/MyHitSite.git", :tag => s.version }
  s.source_files = "Sources/**/*.swift"
  #s.resources = "Sources/Assets/**/*.xcassets"

  s.resource_bundles = {
    'com.rubikon.MyHitSite' => ['Sources/**/*.{storyboard,strings}']
  }

  s.dependency 'SwiftyJSON', '~> 4.1.0'
  s.dependency 'WebAPI', '~> 1.0.13'
  s.dependency 'Runglish', '~> 1.0.0'
  s.dependency 'AudioPlayer', '~> 1.0.7'
  s.dependency 'TVSetKit', '~> 1.0.19'
end
