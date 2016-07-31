#
# Be sure to run `pod lib lint SPBBikeProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SPBBikeProvider'
  s.version          = '1.0'
  s.summary          = 'Tiny Swift provider for fetching city bike share information based on the citybik.es API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SPBBikeProvider is a tiny, convenient framework for fetching city bike share information.
  It uses the citybik.es API and the users location to fetch the nearest available city and 
  bike station information. 

  The framework was built to accomodate Bikey, my bike share app available on the app store.
                       DESC

  s.homepage         = 'https://github.com/superpeteblaze/SPBBikeProvider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pete Smith' => 'peadar81@gmail.com' }
  s.source           = { :git => 'https://github.com/superpeteblaze/SPBBikeProvider.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/superpeteblaze'

  s.ios.deployment_target = '8.1'

  s.source_files = "SPBBikeProvider/**/*.{swift}"

  # s.frameworks = 'Foundation', 'MapKit', 'CoreLocation'
end
