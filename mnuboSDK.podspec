Pod::Spec.new do |s|
  s.name             = 'mnuboSDK'
  s.version          = '2.0.1'
  s.summary          = 'iOS SDK to communicate with the mnubo cloud platform'
  s.homepage         = 'https://github.com/mnubo/mnubo-ios-sdk'
  s.license          = 'MIT'
  s.author           = { 'mnubo, Inc' => 'info@mnubo.com' }
  s.source           = { :git => 'https://github.com/mnubo/mnubo-ios-sdk.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = 'mnuboSDK/**/*.{h,m}'
end
