Pod::Spec.new do |s|
s.name             = 'BRDropDownView'
s.version          = '0.1.1'
s.summary          = 'BRDropDownView is DropDown && Up animated UIView Component supporting various style of subview type.'

s.description      = "description : BRDropDownView is DropDown && Up animated UIView Component supporting various style of subview type."

s.homepage         = 'https://github.com/boraseoksoon/BRDropDownView'

s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'boraseoksoon@gmail.com' => 'boraseoksoon@gmail.com' }
s.source           = { :git => 'https://github.com/boraseoksoon/BRDropDownView.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'BRDropDownView/Classes/**/*'

s.resources = "BRDropDownView/Assets/*"

s.frameworks = 'UIKit'

s.dependency 'BRCountDownView', '~> 0.2.1'

end

