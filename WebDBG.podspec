#
# Be sure to run `pod lib lint DebugManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WebDBG'
  s.version          = '0.0.3'
  s.summary          = 'Web server logger for ios devices'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kirill-kovalev/web-dbg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kirill-kovalev' => 'kirilkovalev@ya.ru' }
  s.source           = { :git => 'https://github.com/kirill-kovalev/web-dbg.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5'

  s.dependency 'GCDWebServer', '~> 3.0'

  s.source_files = 'WebDBG/**/*.{h,m,swift}'
  s.resources = 'WebDBG/**/*.{html,xib,storyboard}'

  # s.frameworks = 'UIKit', 'SafariServices', 'MessageUI', 'WebKit'

end
