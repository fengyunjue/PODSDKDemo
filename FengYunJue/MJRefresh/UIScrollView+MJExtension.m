//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+MJExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (MJExtension)

- (void)setKf5_insetT:(CGFloat)kf5_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = kf5_insetT;
    self.contentInset = inset;
}

- (CGFloat)kf5_insetT
{
    return self.contentInset.top;
}

- (void)setKf5_insetB:(CGFloat)kf5_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = kf5_insetB;
    self.contentInset = inset;
}

- (CGFloat)kf5_insetB
{
    return self.contentInset.bottom;
}

- (void)setKf5_insetL:(CGFloat)kf5_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = kf5_insetL;
    self.contentInset = inset;
}

- (CGFloat)kf5_insetL
{
    return self.contentInset.left;
}

- (void)setKf5_insetR:(CGFloat)kf5_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = kf5_insetR;
    self.contentInset = inset;
}

- (CGFloat)kf5_insetR
{
    return self.contentInset.right;
}

- (void)setKf5_offsetX:(CGFloat)kf5_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = kf5_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)kf5_offsetX
{
    return self.contentOffset.x;
}

- (void)setKf5_offsetY:(CGFloat)kf5_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = kf5_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)kf5_offsetY
{
    return self.contentOffset.y;
}

- (void)setKf5_contentW:(CGFloat)kf5_contentW
{
    CGSize size = self.contentSize;
    size.width = kf5_contentW;
    self.contentSize = size;
}

- (CGFloat)kf5_contentW
{
    return self.contentSize.width;
}

- (void)setKf5_contentH:(CGFloat)kf5_contentH
{
    CGSize size = self.contentSize;
    size.height = kf5_contentH;
    self.contentSize = size;
}

- (CGFloat)kf5_contentH
{
    return self.contentSize.height;
}
@end
