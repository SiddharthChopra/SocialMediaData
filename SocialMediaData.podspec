#
# Be sure to run `pod lib lint SocialMediaData.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SocialMediaData'
  s.version          = '0.1.2'
s.summary          = 'SocialMediaData helps to retrieve twitter data from our server or twitter server'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SocialMediaData helps to retrieve twitter data from our server or twitter server with twitter info custom class object.
                       DESC

  s.homepage         = 'https://github.com/siddharthchopra/SocialMediaData'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'siddharthchopra' => 'siddharth5852@gmail.com' }
  s.source           = { :git => 'https://github.com/siddharthchopra/SocialMediaData.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SocialMediaData/Classes/**/*'
  
  # s.resource_bundles = {
    # 'SocialMediaData' => ['SocialMediaData/Classes/*.xcdatamodel']
   # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
