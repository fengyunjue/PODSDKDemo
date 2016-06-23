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
- (void)setKf5_x:(CGFloat)kf5_x
{
    CGRect frame = self.frame;
    frame.origin.x = kf5_x;
    self.frame = frame;
}

- (CGFloat)kf5_x
{
    return self.frame.origin.x;
}

- (void)setKf5_y:(CGFloat)kf5_y
{
    CGRect frame = self.frame;
    frame.origin.y = kf5_y;
    self.frame = frame;
}

- (CGFloat)kf5_y
{
    return self.frame.origin.y;
}

- (void)setKf5_w:(CGFloat)kf5_w
{
    CGRect frame = self.frame;
    frame.size.width = kf5_w;
    self.frame = frame;
}

- (CGFloat)kf5_w
{
    return self.frame.size.width;
}

- (void)setKf5_h:(CGFloat)kf5_h
{
    CGRect frame = self.frame;
    frame.size.height = kf5_h;
    self.frame = frame;
}

- (CGFloat)kf5_h
{
    return self.frame.size.height;
}

- (void)setKf5_size:(CGSize)kf5_size
{
    CGRect frame = self.frame;
    frame.size = kf5_size;
    self.frame = frame;
}

- (CGSize)kf5_size
{
    return self.frame.size;
}

- (void)setKf5_origin:(CGPoint)kf5_origin
{
    CGRect frame = self.frame;
    frame.origin = kf5_origin;
    self.frame = frame;
}

- (CGPoint)kf5_origin
{
    return self.frame.origin;
}
@end
