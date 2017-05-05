Pod::Spec.new do |s|

  s.name         = "GLXSegmentedControl"
  s.version      = "2.2.2"
  s.summary      = "Custom segmented control for iOS 9 and above"

  s.description  = <<-DESC
                   Written in Swift.
                   Supports both images and text.
                   Supports vertically organised segments
                   More customisible than UISegmentedControl and easier to expand with new style.
                   DESC

  s.homepage     = "https://github.com/glenmax-ltd/GLXSegmentedControl"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.authors       = { "Glenmax" => "support@glenmax.com" }
  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"

  s.source       = {
                    :git => "https://github.com/glenmax-ltd/GLXSegmentedControl.git",
                    :branch => "master",
                    :tag => "v2.2.2"}


  s.source_files  = "GLXSegmentedControl/*.swift"
  s.requires_arc = true
  s.frameworks = 'UIKit'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
