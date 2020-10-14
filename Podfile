# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

target 'Me-iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Me-iOS
pod 'ISHPullUp'
pod 'SkyFloatingLabelTextField'
pod 'BWWalkthrough'
pod 'Fabric'
pod 'Crashlytics'
pod 'IQKeyboardManagerSwift'
pod 'R.swift'

  target 'Me-iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Me-iOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
