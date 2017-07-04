Pod::Spec.new do |s|

  s.name         = "HMScrollNavigationBar"
  s.version      = "1.3.5"
  s.summary      = "Adds hide/show feature for your bar while scrolling."
  s.homepage     = "https://github.com/HandcraftedMobile/HMScrollNavigationBar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "piotr.sekara" => "piotr.sekara@gmail.com" }
  
  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/HandcraftedMobile/HMScrollNavigationBar.git", :tag => "1.3.5" }

  s.source_files  = "HMScrollNavigationBar"
  s.requires_arc = true

end
