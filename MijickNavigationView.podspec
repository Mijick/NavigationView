Pod::Spec.new do |s|
  s.name                  = 'MijickNavigationView'
  s.summary               = 'Navigation made simple'
  s.description           = <<-DESC
  NavigationView is a free and open-source library dedicated for SwiftUI that makes navigation easier and much cleaner.
                               DESC
  
  s.version               = '1.1.0'
  s.ios.deployment_target = '15.0'
  s.swift_version         = '5.0'
  
  s.source_files          = 'Sources/**/*'
  s.frameworks            = 'SwiftUI', 'Foundation'
  
  s.homepage              = 'https://github.com/Mijick/NavigationView.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Tomasz Kurylik' => 'tomasz.kurylik@mijick.com' }
  s.source                = { :git => 'https://github.com/Mijick/NavigationView.git', :tag => s.version.to_s }
end
