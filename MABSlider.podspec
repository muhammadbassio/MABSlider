Pod::Spec.new do |s|
  s.name             = 'MABSlider'
  s.version          = '2.0'
  s.summary          = 'Custom Slider for OSX using swift'
 
  s.description      = <<-DESC
Custom Slider for OSX using swift.
                       DESC
 
  s.homepage         = 'https://github.com/muhammadbassio/MABSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhammad Bassio' => 'muhammadbassio@gmail.com' }
  s.source           = { :git => 'https://github.com/muhammadbassio/MABSlider.git', :tag => s.version.to_s }
 
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
  s.osx.deployment_target = '10.10'
  s.source_files = 'source/*.swift', 'source/assets/*.png'
 
end