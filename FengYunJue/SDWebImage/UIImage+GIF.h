//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)kf_animatedGIFNamed:(NSString *)name;

+ (UIImage *)kf_animatedGIFWithData:(NSData *)data;

- (UIImage *)kf_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
