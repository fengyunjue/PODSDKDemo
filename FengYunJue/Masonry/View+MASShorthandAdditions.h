//
//  UIView+MASShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+MASAdditions.h"

#ifdef kf_SHORTHAND

/**
 *	Shorthand view additions without the 'kf_' prefixes,
 *  only enabled if kf_SHORTHAND is defined
 */
@interface kf_VIEW (MASShorthandAdditions)

@property (nonatomic, strong, readonly) MASViewAttribute *left;
@property (nonatomic, strong, readonly) MASViewAttribute *top;
@property (nonatomic, strong, readonly) MASViewAttribute *right;
@property (nonatomic, strong, readonly) MASViewAttribute *bottom;
@property (nonatomic, strong, readonly) MASViewAttribute *leading;
@property (nonatomic, strong, readonly) MASViewAttribute *trailing;
@property (nonatomic, strong, readonly) MASViewAttribute *width;
@property (nonatomic, strong, readonly) MASViewAttribute *height;
@property (nonatomic, strong, readonly) MASViewAttribute *centerX;
@property (nonatomic, strong, readonly) MASViewAttribute *centerY;
@property (nonatomic, strong, readonly) MASViewAttribute *baseline;
@property (nonatomic, strong, readonly) MASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) MASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) MASViewAttribute *centerYWithinMargins;

#endif

- (NSArray *)makeConstraints:(void(^)(MASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(MASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(MASConstraintMaker *make))block;

@end

#define kf_ATTR_FORWARD(attr)  \
- (MASViewAttribute *)attr {    \
    return [self kf_##attr];   \
}

@implementation kf_VIEW (MASShorthandAdditions)

kf_ATTR_FORWARD(top);
kf_ATTR_FORWARD(left);
kf_ATTR_FORWARD(bottom);
kf_ATTR_FORWARD(right);
kf_ATTR_FORWARD(leading);
kf_ATTR_FORWARD(trailing);
kf_ATTR_FORWARD(width);
kf_ATTR_FORWARD(height);
kf_ATTR_FORWARD(centerX);
kf_ATTR_FORWARD(centerY);
kf_ATTR_FORWARD(baseline);

#if TARGET_OS_IPHONE || TARGET_OS_TV

kf_ATTR_FORWARD(leftMargin);
kf_ATTR_FORWARD(rightMargin);
kf_ATTR_FORWARD(topMargin);
kf_ATTR_FORWARD(bottomMargin);
kf_ATTR_FORWARD(leadingMargin);
kf_ATTR_FORWARD(trailingMargin);
kf_ATTR_FORWARD(centerXWithinMargins);
kf_ATTR_FORWARD(centerYWithinMargins);

#endif

- (MASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self kf_attribute];
}

- (NSArray *)makeConstraints:(void(^)(MASConstraintMaker *))block {
    return [self kf_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(MASConstraintMaker *))block {
    return [self kf_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(MASConstraintMaker *))block {
    return [self kf_remakeConstraints:block];
}

@end

#endif
