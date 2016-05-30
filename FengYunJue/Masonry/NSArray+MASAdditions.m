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

- (NSArray *)kf_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)kf_updateConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)kf_remakeConstraints:(void(^)(MASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (kf_VIEW *view in self) {
        NSAssert([view isKindOfClass:[kf_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view kf_remakeConstraints:block]];
    }
    return constraints;
}

- (void)kf_distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    kf_VIEW *tempSuperView = [self kf_commonSuperviewOfViews];
    if (axisType == MASAxisTypeHorizontal) {
        kf_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf_VIEW *v = self[i];
            [v kf_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.kf_right).offset(fixedSpacing);
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
        kf_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf_VIEW *v = self[i];
            [v kf_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.kf_bottom).offset(fixedSpacing);
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

- (void)kf_distributeViewsAlongAxis:(MASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    kf_VIEW *tempSuperView = [self kf_commonSuperviewOfViews];
    if (axisType == MASAxisTypeHorizontal) {
        kf_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf_VIEW *v = self[i];
            [v kf_makeConstraints:^(MASConstraintMaker *make) {
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
        kf_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            kf_VIEW *v = self[i];
            [v kf_makeConstraints:^(MASConstraintMaker *make) {
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

- (kf_VIEW *)kf_commonSuperviewOfViews
{
    kf_VIEW *commonSuperview = nil;
    kf_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[kf_VIEW class]]) {
            kf_VIEW *view = (kf_VIEW *)object;
            if (previousView) {
                commonSuperview = [view kf_closestCommonSuperview:commonSuperview];
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
