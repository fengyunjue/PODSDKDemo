//
//  UIViewController+MASAdditions.h
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "MASUtilities.h"
#import "MASConstraintMaker.h"
#import "MASViewAttribute.h"

#ifdef kf5_VIEW_CONTROLLER

@interface kf5_VIEW_CONTROLLER (MASAdditions)

/**
 *	following properties return a new MASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_topLayoutGuide;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_bottomLayoutGuide;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_topLayoutGuideTop;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) MASViewAttribute *kf5_bottomLayoutGuideBottom;


@end

#endif
