#
# Be sure to run `pod lib lint MAPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = "FengYunJue"
    s.version           = "1.0.0"
    s.summary           = "修改一些第三方库的分类的前缀"

    s.homepage          = "https://github.com/fengyunjue/PODSDKDemo"
    s.license           = 'MIT'
    s.author            = { "ma772528138" => "ma772528138@qq.com" }
    s.source            = { :git => "https://github.com/fengyunjue/PODSDKDemo", :tag => s.version.to_s }
    s.resource          = 'FengYunJue/MJRefresh/MJRefresh.bundle'
    s.platform          = :ios, '7.0'
    s.requires_arc      = true

    s.source_files      = 'FengYunJue/**/*.{h,m}'
    s.public_header_files = 'FengYunJue/**/*.h'

    s.frameworks = 'UIKit', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate', 'MobileCoreServices','CoreGraphics','Security','SystemConfiguration','ImageIO'

end
