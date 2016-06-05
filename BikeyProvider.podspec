Pod::Spec.new do |s|
 
  # 1
  s.platform = :ios
  s.ios.deployment_target = '8.1'
  s.name = "BikeyProvider"
  s.summary = "Provider framework used by Bikey app"
  s.requires_arc = true
 
  # 2
  s.version = "0.1"
 
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  # 4 - Replace with your name and e-mail address
  s.author = { "Pete Smith" => "peadar81@gmail.com" }

 
  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/superpeteblaze/BikeyProvider"
 
  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/superpeteblaze/BikeyProvider.git", :commit => "0d0e8896824fe91c950d676ccb681baf6d7a36aa" }
 
  
  # 7
  s.source_files = "BikeyProvider/**/*.{swift}"

end
