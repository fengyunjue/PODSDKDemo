/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HighlightedWebCache.h"
#import "UIView+WebCacheOperation.h"

#define UIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (HighlightedWebCache)

- (void)kf_setHighlightedImageWithURL:(NSURL *)url {
    [self kf_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)kf_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options {
    [self kf_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)kf_setHighlightedImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)kf_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)kf_setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                                         {
                                             completedBlock(image, error, cacheType, url);
                                             return;
                                         }
                                         else if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self kf_setImageLoadOperation:operation forKey:UIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)kf_cancelCurrentHighlightedImageLoad {
    [self kf_cancelImageLoadOperationWithKey:UIImageViewHighlightedWebCacheOperationKey];
}

@end
