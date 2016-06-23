//
//  NSArray+MASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+MASAdditions.h"
#import "View+MASAdditions.h"

@implementation NSArray (MASAdditions)

- (NSArray *)kf5_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf5_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf5_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf5_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)kf5_updateConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf5_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf5_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf5_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)kf5_remakeConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf5_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf5_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf5_remakeConstraints:block]];
    }
    return constraints;
}

- (void)kf5_distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    kf5_VIEW *tempSuperView = [self kf5_commonSuperviewOfViews];
    if (axisType == MASAxisTypeHorizontal) {
        kf5_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf5_VIEW *v = self[i];
            [v kf5_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.kf5_right).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        kf5_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf5_VIEW *v = self[i];
            [v kf5_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.kf5_bottom).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)kf5_distributeViewsAlongAxis:(MASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    kf5_VIEW *tempSuperView = [self kf5_commonSuperviewOfViews];
    if (axisType == MASAxisTypeHorizontal) {
        kf5_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf5_VIEW *v = self[i];
            [v kf5_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.width.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                    make.width.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
    else {
        kf5_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf5_VIEW *v = self[i];
            [v kf5_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.height.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                    make.height.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
}

- (kf5_VIEW *)kf5_commonSuperviewOfViews
{
    kf5_VIEW *commonSuperview = nil;
    kf5_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[kf5_VIEW class]]) {
            kf5_VIEW *view = (kf5_VIEW *)object;
            if (previousView) {
                commonSuperview = [view kf5_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
