//
//  MJRefreshAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshAutoFooter.h"

@interface MJRefreshAutoFooter()
@end

@implementation MJRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.kf5_insetB += self.kf5_h;
        }
        
        // 设置位置
        self.kf5_y = _scrollView.kf5_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.kf5_insetB -= self.kf5_h;
        }
    }
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.kf5_y = self.scrollView.kf5_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.kf5_y == 0) return;
    
    if (_scrollView.kf5_insetT + _scrollView.kf5_contentH > _scrollView.kf5_h) { // 内容超过一个屏幕
        // 这里的_scrollView.kf5_contentH替换掉self.kf5_y更为合理
        if (_scrollView.kf5_offsetY >= _scrollView.kf5_contentH - _scrollView.kf5_h + self.kf5_h * self.triggerAutomaticallyRefreshPercent + _scrollView.kf5_insetB - self.kf5_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != MJRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.kf5_insetT + _scrollView.kf5_contentH <= _scrollView.kf5_h) {  // 不够一个屏幕
            if (_scrollView.kf5_offsetY >= - _scrollView.kf5_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.kf5_offsetY >= _scrollView.kf5_contentH + _scrollView.kf5_insetB - _scrollView.kf5_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        
        self.scrollView.kf5_insetB -= self.kf5_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.kf5_insetB += self.kf5_h;
        
        // 设置位置
        self.kf5_y = _scrollView.kf5_contentH;
    }
}
@end
