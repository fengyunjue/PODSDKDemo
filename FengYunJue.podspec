#
# Be sure to run `pod lib lint MAPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = "FengYunJue"
    s.version           = "0.0.5"
    s.summary           = "修改一些第三方库的分类的前缀"

    s.homepage          = "https://github.com/fengyunjue/PODSDKDemo"
    s.license           = 'MIT'
    s.author            = { "ma772528138" => "ma772528138@qq.com" }
    s.source            = { :git => "https://github.com/fengyunjue/PODSDKDemo.git", :tag => s.version.to_s }
    s.platform          = :ios, '7.0'
    s.requires_arc      = true

    s.subspec 'AFNetworking' do |ss|
#ss.version = "3.1.0"
        ss.source_files = 'FengYunJue/AFNetworking/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/AFNetworking/**/*.h'
        ss.frameworks = 'MobileCoreServices', 'CoreGraphics','Security','SystemConfiguration'
    end

    s.subspec 'Masonry' do |ss|
#ss.version = "1.0.1"
        ss.source_files = 'FengYunJue/Masonry/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/Masonry/**/*.h'
        ss.frameworks = 'Foundation', 'UIKit'
    end

    s.subspec 'MJRefresh' do |ss|
#ss.version = "3.1.0"
        ss.source_files = 'FengYunJue/MJRefresh/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/MJRefresh/**/*.h'
        ss.resource = 'FengYunJue/MJRefresh/KF5SDK.bundle'
    end

    s.subspec 'SDWebImage' do |ss|
#ss.version = "3.7.6"
        ss.source_files = 'FengYunJue/SDWebImage/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/SDWebImage/**/*.h'
    end

    s.subspec 'UITableView+FDTemplateLayoutCell' do |ss|
#ss.version = "1.4"
        ss.source_files = 'FengYunJue/UITableView+FDTemplateLayoutCell/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/UITableView+FDTemplateLayoutCell/**/*.h'
    end

    s.subspec 'YYText' do |ss|
#ss.version = "1.0.5"
        ss.source_files = 'FengYunJue/YYText/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/YYText/**/*.h'
        ss.frameworks = 'Accelerate', 'CoreFoundation','CoreText','MobileCoreServices','QuartzCore','UIKit'
    end

end
