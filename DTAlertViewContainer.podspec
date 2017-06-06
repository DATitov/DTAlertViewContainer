Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "DTAlertViewContainer"
s.summary = "DTAlertViewContainer is an animated, flexible container to present any View as AlertView."
s.requires_arc = true

s.version = "0.1.2"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Dmitriy Titov" => "dmitriytitovwm@gmail.com" }
s.homepage = "https://github.com/Quott/DTAlertViewContainer"
s.source = { :git => "https://github.com/Quott/DTAlertViewContainer.git", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "DTAlertViewContainer/**/*.{h,m}"
#s.resources = "DTAlertViewContainer/**/*.{png,jpeg,jpg,storyboard,xib}"

`echo "2.3" > .swift-version`

end
