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

#ifdef kf_VIEW_CONTROLLER

@interface kf_VIEW_CONTROLLER (MASAdditions)

/**
 *	following properties return a new MASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MASViewAttribute *kf_topLayoutGuide;
@property (nonatomic, strong, readonly) MASViewAttribute *kf_bottomLayoutGuide;
@property (nonatomic, strong, readonly) MASViewAttribute *kf_topLayoutGuideTop;
@property (nonatomic, strong, readonly) MASViewAttribute *kf_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) MASViewAttribute *kf_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) MASViewAttribute *kf_bottomLayoutGuideBottom;


@end

#endif
