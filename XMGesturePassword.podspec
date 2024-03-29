#
# Be sure to run `pod lib lint XMGesturePassword.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMGesturePassword'
  s.version          = '1.0.0'
  s.summary          = '手势密码.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
   通过手势绘制密码进入app，多用于金融类项目。
                       DESC

  s.homepage         = 'https://github.com/lxumeng/XMGesturePassword'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lxumeng' => '15731206413@163.com' }
  s.source           = { :git => 'https://github.com/lxumeng/XMGesturePassword.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'XMGesturePassword/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XMGesturePassword' => ['XMGesturePassword/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
