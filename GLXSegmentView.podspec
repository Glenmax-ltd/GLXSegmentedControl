Pod::Spec.new do |s|

  s.name         = "GLXSegmentView"
  s.version      = "0.0.2"
  s.summary      = "Custom segmented control for iOS 8 and above"

  s.description  = <<-DESC
                   Written in Swift.
                   Support both images and text.
                   Support vertically organise segments
                   More customisible than UISegmentedControl and easier to expand with new style.
                   DESC

  s.homepage     = "https://github.com/glenmax-ltd/GLXSegmentView"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.authors       = { "allenbryan11" => "", "Glenmax" => "support@glenmax.com" }
  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/glenmax-ltd/GLXSegmentView.git", :branch => "master" }


  s.source_files  = "GLXSegmentViewController/GLXSegmentView/*.swift"
  s.requires_arc = true
  s.frameworks = 'UIKit'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
