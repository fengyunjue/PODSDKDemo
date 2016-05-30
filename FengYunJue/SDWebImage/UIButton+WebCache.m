/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLStorageKey;

@implementation UIButton (WebCache)

- (NSURL *)kf_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)kf_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self kf_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self kf_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self kf_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)kf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self kf_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak __typeof(self)wself = self;
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
            {
                completedBlock(image, error, cacheType, url);
                return;
            }
            else if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self kf_setImageLoadOperation:operation forState:state];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self kf_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self kf_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self kf_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)kf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self kf_cancelBackgroundImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self kf_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)kf_setImageLoadOperation:(id<SDWebImageOperation>)operation forState:(UIControlState)state {
    [self kf_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)kf_cancelImageLoadForState:(UIControlState)state {
    [self kf_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)kf_setBackgroundImageLoadOperation:(id<SDWebImageOperation>)operation forState:(UIControlState)state {
    [self kf_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)kf_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self kf_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end
