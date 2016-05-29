//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+MJExtension.h"

@implementation UIView (MJExtension)
- (void)setKf_x:(CGFloat)kf_x
{
    CGRect frame = self.frame;
    frame.origin.x = kf_x;
    self.frame = frame;
}

- (CGFloat)kf_x
{
    return self.frame.origin.x;
}

- (void)setKf_y:(CGFloat)kf_y
{
    CGRect frame = self.frame;
    frame.origin.y = kf_y;
    self.frame = frame;
}

- (CGFloat)kf_y
{
    return self.frame.origin.y;
}

- (void)setKf_w:(CGFloat)kf_w
{
    CGRect frame = self.frame;
    frame.size.width = kf_w;
    self.frame = frame;
}

- (CGFloat)kf_w
{
    return self.frame.size.width;
}

- (void)setKf_h:(CGFloat)kf_h
{
    CGRect frame = self.frame;
    frame.size.height = kf_h;
    self.frame = frame;
}

- (CGFloat)kf_h
{
    return self.frame.size.height;
}

- (void)setKf_size:(CGSize)kf_size
{
    CGRect frame = self.frame;
    frame.size = kf_size;
    self.frame = frame;
}

- (CGSize)kf_size
{
    return self.frame.size;
}

- (void)setKf_origin:(CGPoint)kf_origin
{
    CGRect frame = self.frame;
    frame.origin = kf_origin;
    self.frame = frame;
}

- (CGPoint)kf_origin
{
    return self.frame.origin;
}
@end
