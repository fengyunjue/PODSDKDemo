//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)kf5_animatedGIFNamed:(NSString *)name;

+ (UIImage *)kf5_animatedGIFWithData:(NSData *)data;

- (UIImage *)kf5_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
