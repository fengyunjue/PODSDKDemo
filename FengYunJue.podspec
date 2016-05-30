#
# Be sure to run `pod lib lint MAPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = "FengYunJue"
    s.version           = "1.0.1"
    s.summary           = "修改一些第三方库的分类的前缀"

    s.homepage          = "https://github.com/fengyunjue/FengYunJue"
    s.license           = 'MIT'
    s.author            = { "ma772528138" => "ma772528138@qq.com" }
    s.source            = { :git => "https://github.com/fengyunjue/PODSDKDemo.git", :tag => s.version.to_s }
    s.platform          = :ios, '7.0'
    s.requires_arc      = true

    #   AFNetworking(3.1.0)
    s.subspec 'AFNetworking' do |ss|
        ss.source_files = 'FengYunJue/AFNetworking/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/AFNetworking/**/*.h'
        ss.frameworks = 'MobileCoreServices', 'CoreGraphics','Security','SystemConfiguration'
    end

    #   Masonry(1.0.1)
    s.subspec 'Masonry' do |ss|
        ss.source_files = 'FengYunJue/Masonry/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/Masonry/**/*.h'
        ss.frameworks = 'Foundation', 'UIKit'
    end

    #   MJRefresh(3.1.0)
    s.subspec 'MJRefresh' do |ss|
        ss.source_files = 'FengYunJue/MJRefresh/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/MJRefresh/**/*.h'
        ss.resource = 'FengYunJue/MJRefresh/MJRefresh.bundle'
    end

    #   SDWebImage(3.7.6)
    s.subspec 'SDWebImage' do |ss|
        ss.source_files = 'FengYunJue/SDWebImage/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/SDWebImage/**/*.h'
    end

    #   UITableView+FDTemplateLayoutCell(1.4)
    s.subspec 'UITableView+FDTemplateLayoutCell' do |ss|
        ss.source_files = 'FengYunJue/UITableView+FDTemplateLayoutCell/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/UITableView+FDTemplateLayoutCell/**/*.h'
    end

    #   YYText(1.0.5)
    s.subspec 'YYText' do |ss|
        ss.source_files = 'FengYunJue/YYText/**/*.{h,m}'
        ss.public_header_files = 'FengYunJue/YYText/**/*.h'
        ss.frameworks = 'Accelerate', 'CoreFoundation','CoreText','MobileCoreServices','QuartzCore','UIKit'
    end

end
