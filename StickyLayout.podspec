Pod::Spec.new do |s|
  s.name             = 'StickyLayout'
  s.version          = '0.0.1'
  s.summary          = 'Stick it.'

  s.description      = <<-DESC
    StickyLayout is a collection view layout that makes top/bottom rows and left/right columns fixed while the rest of the cells are scrollable.
                       DESC

  s.homepage         = 'https://github.com/jeffreysfllo24/StickyLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeffrey Zhang' => 'jeffreysfllo24@gmail.com' }
  s.source           = { :git => 'https://github.com/jeffreysfllo24/StickyLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = "8.0"
  s.source_files     = 'StickyLayout/StickyLayout/*.{h,m,swift}'

  s.swift_version    = "5.0"
end
