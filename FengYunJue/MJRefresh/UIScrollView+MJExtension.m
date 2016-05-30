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

- (void)setKf_insetT:(CGFloat)kf_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = kf_insetT;
    self.contentInset = inset;
}

- (CGFloat)kf_insetT
{
    return self.contentInset.top;
}

- (void)setKf_insetB:(CGFloat)kf_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = kf_insetB;
    self.contentInset = inset;
}

- (CGFloat)kf_insetB
{
    return self.contentInset.bottom;
}

- (void)setKf_insetL:(CGFloat)kf_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = kf_insetL;
    self.contentInset = inset;
}

- (CGFloat)kf_insetL
{
    return self.contentInset.left;
}

- (void)setKf_insetR:(CGFloat)kf_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = kf_insetR;
    self.contentInset = inset;
}

- (CGFloat)kf_insetR
{
    return self.contentInset.right;
}

- (void)setKf_offsetX:(CGFloat)kf_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = kf_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)kf_offsetX
{
    return self.contentOffset.x;
}

- (void)setKf_offsetY:(CGFloat)kf_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = kf_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)kf_offsetY
{
    return self.contentOffset.y;
}

- (void)setKf_contentW:(CGFloat)kf_contentW
{
    CGSize size = self.contentSize;
    size.width = kf_contentW;
    self.contentSize = size;
}

- (CGFloat)kf_contentW
{
    return self.contentSize.width;
}

- (void)setKf_contentH:(CGFloat)kf_contentH
{
    CGSize size = self.contentSize;
    size.height = kf_contentH;
    self.contentSize = size;
}

- (CGFloat)kf_contentH
{
    return self.contentSize.height;
}
@end
