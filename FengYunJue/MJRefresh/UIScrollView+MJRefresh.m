//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+MJRefresh.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (MJRefresh)

#pragma mark - header
static const char MJRefreshHeaderKey = '\0';
- (void)setKf_header:(MJRefreshHeader *)kf_header
{
    if (kf_header != self.kf_header) {
        // 删除旧的，添加新的
        [self.kf_header removeFromSuperview];
        [self insertSubview:kf_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"kf_header"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshHeaderKey,
                                 kf_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"kf_header"]; // KVO
    }
}

- (MJRefreshHeader *)kf_header
{
    return objc_getAssociatedObject(self, &MJRefreshHeaderKey);
}

#pragma mark - footer
static const char MJRefreshFooterKey = '\0';
- (void)setKf_footer:(MJRefreshFooter *)kf_footer
{
    if (kf_footer != self.kf_footer) {
        // 删除旧的，添加新的
        [self.kf_footer removeFromSuperview];
        [self addSubview:kf_footer];
        
        // 存储新的
        [self willChangeValueForKey:@"kf_footer"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshFooterKey,
                                 kf_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"kf_footer"]; // KVO
    }
}

- (MJRefreshFooter *)kf_footer
{
    return objc_getAssociatedObject(self, &MJRefreshFooterKey);
}

#pragma mark - 过期
- (void)setFooter:(MJRefreshFooter *)footer
{
    self.kf_footer = footer;
}

- (MJRefreshFooter *)footer
{
    return self.kf_footer;
}

- (void)setHeader:(MJRefreshHeader *)header
{
    self.kf_header = header;
}

- (MJRefreshHeader *)header
{
    return self.kf_header;
}

#pragma mark - other
- (NSInteger)kf_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char MJRefreshReloadDataBlockKey = '\0';
- (void)setKf_reloadDataBlock:(void (^)(NSInteger))kf_reloadDataBlock
{
    [self willChangeValueForKey:@"kf_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &MJRefreshReloadDataBlockKey, kf_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"kf_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))kf_reloadDataBlock
{
    return objc_getAssociatedObject(self, &MJRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.kf_reloadDataBlock ? : self.kf_reloadDataBlock(self.kf_totalDataCount);
}
@end

@implementation UITableView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(kf_reloadData)];
}

- (void)kf_reloadData
{
    [self kf_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (MJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(kf_reloadData)];
}

- (void)kf_reloadData
{
    [self kf_reloadData];
    
    [self executeReloadDataBlock];
}
@end