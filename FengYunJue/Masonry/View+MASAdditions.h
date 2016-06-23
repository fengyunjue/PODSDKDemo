//
//  UIView+MASAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASUtilities.h"
#import "MASConstraintMaker.h"
#import "MASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating MASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface kf5_VIEW (MASAdditions)

/**
 *	following properties return a new MASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_left;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_top;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_right;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_bottom;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_leading;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_trailing;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_width;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_height;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_centerX;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_centerY;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_baseline;
@property (nonatomic, strong, readonly) MASViewAttribute *(^kf5_attribute)(NSLayoutAttribute attr);

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) MASViewAttribute *kf5_leftMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_rightMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_topMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_bottomMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_leadingMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_trailingMargin;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_centerXWithinMargins;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id kf5_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)kf5_closestCommonSuperview:(kf5_VIEW *)view;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MASConstraints
 */
- (NSArray *)kf5_makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)kf5_updateConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 *  Creates a MASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASConstraints
 */
- (NSArray *)kf5_remakeConstraints:(void(^)(MASConstraintMaker *make))block;

@end
