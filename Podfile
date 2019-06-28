platform :ios, '11.0'

target 'MyLocations' do
  use_frameworks!

  # Pods for MyLocations
pod 'Alamofire', '5.0.0-beta.6'
pod 'SwiftyJSON', '~> 5.0'
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
pod 'ChameleonFramework'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
