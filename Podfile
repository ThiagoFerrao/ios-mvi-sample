source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.0'
inhibit_all_warnings!

target 'iOS MVI Sample' do
  use_frameworks!

  pod 'Alamofire'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'SwiftGen'

  target 'iOS MVI SampleTests' do
    inherit! :search_paths

    pod 'RxTest'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
