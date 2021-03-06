#
# Be sure to run `pod lib lint ALTutorialVC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALTutorialVC'
  s.version          = '0.0.1'
  s.summary          = 'ALTutorialVC is UI library used in English Ninjas application to show features of the application to users.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
        This is an UI library to help to users to understand how your application's layout can be used. You can build tutorials for your application's pages to direct users to use specific functionality of your application
                       DESC

  s.homepage         = 'https://github.com/englishninjas/ALTutorialVC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aligermiyanoglu' => 'enver@englishninjas.com' }
  s.source           = { :git => 'https://github.com/englishninjas/ALTutorialVC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  s.source_files = 'ALTutorialVC/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ALTutorialVC' => ['ALTutorialVC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
