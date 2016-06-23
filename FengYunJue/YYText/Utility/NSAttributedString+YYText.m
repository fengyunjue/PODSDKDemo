//
//  NSAttributedString+YYText.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 14/10/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSAttributedString+YYText.h"
#import "NSParagraphStyle+YYText.h"
#import "YYTextArchiver.h"
#import "YYTextRunDelegate.h"
#import "YYTextUtilities.h"
#import <CoreFoundation/CoreFoundation.h>


// Dummy class for category
@interface NSAttributedString_YYText : NSObject @end
@implementation NSAttributedString_YYText @end


static double _YYDeviceSystemVersion() {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

#ifndef kSystemVersion
#define kSystemVersion _YYDeviceSystemVersion()
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif



@implementation NSAttributedString (YYText)

- (NSData *)kf5_archiveToData {
    NSData *data = nil;
    @try {
        data = [YYTextArchiver archivedDataWithRootObject:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return data;
}

+ (instancetype)kf5_unarchiveFromData:(NSData *)data {
    NSAttributedString *one = nil;
    @try {
        one = [YYTextUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return one;
}

- (NSDictionary *)kf5_attributesAtIndex:(NSUInteger)index {
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)kf5_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSDictionary *)kf5_attributes {
    return [self kf5_attributesAtIndex:0];
}

- (UIFont *)kf5_font {
    return [self kf5_fontAtIndex:0];
}

- (UIFont *)kf5_fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self kf5_attribute:NSFontAttributeName atIndex:index];
    if (kSystemVersion <= 6) {
        if (font) {
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
                CTFontRef CTFont = (__bridge CTFontRef)(font);
                CFStringRef name = CTFontCopyPostScriptName(CTFont);
                CGFloat size = CTFontGetSize(CTFont);
                if (!name) {
                    font = nil;
                } else {
                    font = [UIFont fontWithName:(__bridge NSString *)(name) size:size];
                    CFRelease(name);
                }
            }
        }
    }
    return font;
}

- (NSNumber *)kf5_kern {
    return [self kf5_kernAtIndex:0];
}

- (NSNumber *)kf5_kernAtIndex:(NSUInteger)index {
    return [self kf5_attribute:NSKernAttributeName atIndex:index];
}

- (UIColor *)kf5_color {
    return [self kf5_colorAtIndex:0];
}

- (UIColor *)kf5_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self kf5_attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self kf5_attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)kf5_backgroundColor {
    return [self kf5_backgroundColorAtIndex:0];
}

- (UIColor *)kf5_backgroundColorAtIndex:(NSUInteger)index {
    return [self kf5_attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)kf5_strokeWidth {
    return [self kf5_strokeWidthAtIndex:0];
}

- (NSNumber *)kf5_strokeWidthAtIndex:(NSUInteger)index {
    return [self kf5_attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)kf5_strokeColor {
    return [self kf5_strokeColorAtIndex:0];
}

- (UIColor *)kf5_strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self kf5_attribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self kf5_attribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)kf5_shadow {
    return [self kf5_shadowAtIndex:0];
}

- (NSShadow *)kf5_shadowAtIndex:(NSUInteger)index {
    return [self kf5_attribute:NSShadowAttributeName atIndex:index];
}

- (NSUnderlineStyle)kf5_strikethroughStyle {
    return [self kf5_strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)kf5_strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self kf5_attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)kf5_strikethroughColor {
    return [self kf5_strikethroughColorAtIndex:0];
}

- (UIColor *)kf5_strikethroughColorAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:NSStrikethroughColorAttributeName atIndex:index];
    }
    return nil;
}

- (NSUnderlineStyle)kf5_underlineStyle {
    return [self kf5_underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)kf5_underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self kf5_attribute:NSUnderlineStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)kf5_underlineColor {
    return [self kf5_underlineColorAtIndex:0];
}

- (UIColor *)kf5_underlineColorAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    if (kSystemVersion >= 7) {
        color = [self kf5_attribute:NSUnderlineColorAttributeName atIndex:index];
    }
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self kf5_attribute:(NSString *)kCTUnderlineColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSNumber *)kf5_ligature {
    return [self kf5_ligatureAtIndex:0];
}

- (NSNumber *)kf5_ligatureAtIndex:(NSUInteger)index {
    return [self kf5_attribute:NSLigatureAttributeName atIndex:index];
}

- (NSString *)kf5_textEffect {
    return [self kf5_textEffectAtIndex:0];
}

- (NSString *)kf5_textEffectAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:NSTextEffectAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)kf5_obliqueness {
    return [self kf5_obliquenessAtIndex:0];
}

- (NSNumber *)kf5_obliquenessAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:NSObliquenessAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)kf5_expansion {
    return [self kf5_expansionAtIndex:0];
}

- (NSNumber *)kf5_expansionAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:NSExpansionAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)kf5_baselineOffset {
    return [self kf5_baselineOffsetAtIndex:0];
}

- (NSNumber *)kf5_baselineOffsetAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:NSBaselineOffsetAttributeName atIndex:index];
    }
    return nil;
}

- (BOOL)kf5_verticalGlyphForm {
    return [self kf5_verticalGlyphFormAtIndex:0];
}

- (BOOL)kf5_verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *num = [self kf5_attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return num.boolValue;
}

- (NSString *)kf5_language {
    return [self kf5_languageAtIndex:0];
}

- (NSString *)kf5_languageAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self kf5_attribute:(id)kCTLanguageAttributeName atIndex:index];
    }
    return nil;
}

- (NSArray *)kf5_writingDirection {
    return [self kf5_writingDirectionAtIndex:0];
}

- (NSArray *)kf5_writingDirectionAtIndex:(NSUInteger)index {
    return [self kf5_attribute:(id)kCTWritingDirectionAttributeName atIndex:index];
}

- (NSParagraphStyle *)kf5_paragraphStyle {
    return [self kf5_paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)kf5_paragraphStyleAtIndex:(NSUInteger)index {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    NSParagraphStyle *style = [self kf5_attribute:NSParagraphStyleAttributeName atIndex:index];
    if (style) {
        if (CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) { \
            style = [NSParagraphStyle kf5_styleWithCTStyle:(__bridge CTParagraphStyleRef)(style)];
        }
    }
    return style;
}

#define ParagraphAttribute(_attr_) \
NSParagraphStyle *style = self.kf5_paragraphStyle; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

#define ParagraphAttributeAtIndex(_attr_) \
NSParagraphStyle *style = [self kf5_paragraphStyleAtIndex:index]; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

- (NSTextAlignment)kf5_alignment {
    ParagraphAttribute(alignment);
}

- (NSLineBreakMode)kf5_lineBreakMode {
    ParagraphAttribute(lineBreakMode);
}

- (CGFloat)kf5_lineSpacing {
    ParagraphAttribute(lineSpacing);
}

- (CGFloat)kf5_paragraphSpacing {
    ParagraphAttribute(paragraphSpacing);
}

- (CGFloat)kf5_paragraphSpacingBefore {
    ParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)kf5_firstLineHeadIndent {
    ParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)kf5_headIndent {
    ParagraphAttribute(headIndent);
}

- (CGFloat)kf5_tailIndent {
    ParagraphAttribute(tailIndent);
}

- (CGFloat)kf5_minimumLineHeight {
    ParagraphAttribute(minimumLineHeight);
}

- (CGFloat)kf5_maximumLineHeight {
    ParagraphAttribute(maximumLineHeight);
}

- (CGFloat)kf5_lineHeightMultiple {
    ParagraphAttribute(lineHeightMultiple);
}

- (NSWritingDirection)kf5_baseWritingDirection {
    ParagraphAttribute(baseWritingDirection);
}

- (float)kf5_hyphenationFactor {
    ParagraphAttribute(hyphenationFactor);
}

- (CGFloat)kf5_defaultTabInterval {
    if (!kiOS7Later) return 0;
    ParagraphAttribute(defaultTabInterval);
}

- (NSArray *)kf5_tabStops {
    if (!kiOS7Later) return nil;
    ParagraphAttribute(tabStops);
}

- (NSTextAlignment)kf5_alignmentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(alignment);
}

- (NSLineBreakMode)kf5_lineBreakModeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineBreakMode);
}

- (CGFloat)kf5_lineSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)kf5_paragraphSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacing);
}

- (CGFloat)kf5_paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (CGFloat)kf5_firstLineHeadIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)kf5_headIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)kf5_tailIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)kf5_minimumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)kf5_maximumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(maximumLineHeight);
}

- (CGFloat)kf5_lineHeightMultipleAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineHeightMultiple);
}

- (NSWritingDirection)kf5_baseWritingDirectionAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(baseWritingDirection);
}

- (float)kf5_hyphenationFactorAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(hyphenationFactor);
}

- (CGFloat)kf5_defaultTabIntervalAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return 0;
    ParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSArray *)kf5_tabStopsAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return nil;
    ParagraphAttributeAtIndex(tabStops);
}

#undef ParagraphAttribute
#undef ParagraphAttributeAtIndex

- (YYTextShadow *)kf5_textShadow {
    return [self kf5_textShadowAtIndex:0];
}

- (YYTextShadow *)kf5_textShadowAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextShadowAttributeName atIndex:index];
}

- (YYTextShadow *)kf5_textInnerShadow {
    return [self kf5_textInnerShadowAtIndex:0];
}

- (YYTextShadow *)kf5_textInnerShadowAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextInnerShadowAttributeName atIndex:index];
}

- (YYTextDecoration *)kf5_textUnderline {
    return [self kf5_textUnderlineAtIndex:0];
}

- (YYTextDecoration *)kf5_textUnderlineAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextUnderlineAttributeName atIndex:index];
}

- (YYTextDecoration *)kf5_textStrikethrough {
    return [self kf5_textStrikethroughAtIndex:0];
}

- (YYTextDecoration *)kf5_textStrikethroughAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextStrikethroughAttributeName atIndex:index];
}

- (YYTextBorder *)kf5_textBorder {
    return [self kf5_textBorderAtIndex:0];
}

- (YYTextBorder *)kf5_textBorderAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextBorderAttributeName atIndex:index];
}

- (YYTextBorder *)kf5_textBackgroundBorder {
    return [self kf5_textBackgroundBorderAtIndex:0];
}

- (YYTextBorder *)kf5_textBackgroundBorderAtIndex:(NSUInteger)index {
    return [self kf5_attribute:YYTextBackedStringAttributeName atIndex:index];
}

- (CGAffineTransform)kf5_textGlyphTransform {
    return [self kf5_textGlyphTransformAtIndex:0];
}

- (CGAffineTransform)kf5_textGlyphTransformAtIndex:(NSUInteger)index {
    NSValue *value = [self kf5_attribute:YYTextGlyphTransformAttributeName atIndex:index];
    if (!value) return CGAffineTransformIdentity;
    return [value CGAffineTransformValue];
}

- (NSString *)kf5_plainTextForRange:(NSRange)range {
    if (range.location == NSNotFound ||range.length == NSNotFound) return nil;
    NSMutableString *result = [NSMutableString string];
    if (range.length == 0) return result;
    NSString *string = self.string;
    [self enumerateAttribute:YYTextBackedStringAttributeName inRange:range options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        YYTextBackedString *backed = value;
        if (backed && backed.string) {
            [result appendString:backed.string];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}

+ (NSMutableAttributedString *)kf5_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                                        width:(CGFloat)width
                                                       ascent:(CGFloat)ascent
                                                      descent:(CGFloat)descent {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr kf5_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = width;
    delegate.ascent = ascent;
    delegate.descent = descent;
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr kf5_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)kf5_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                               attachmentSize:(CGSize)attachmentSize
                                                  alignToFont:(UIFont *)font
                                                    alignment:(YYTextVerticalAlignment)alignment {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr kf5_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = attachmentSize.width;
    switch (alignment) {
        case YYTextVerticalAlignmentTop: {
            delegate.ascent = font.ascender;
            delegate.descent = attachmentSize.height - font.ascender;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentCenter: {
            CGFloat fontHeight = font.ascender - font.descender;
            CGFloat yOffset = font.ascender - fontHeight * 0.5;
            delegate.ascent = attachmentSize.height * 0.5 + yOffset;
            delegate.descent = attachmentSize.height - delegate.ascent;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentBottom: {
            delegate.ascent = attachmentSize.height + font.descender;
            delegate.descent = -font.descender;
            if (delegate.ascent < 0) {
                delegate.ascent = 0;
                delegate.descent = attachmentSize.height;
            }
        } break;
        default: {
            delegate.ascent = attachmentSize.height;
            delegate.descent = 0;
        } break;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr kf5_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)kf5_attachmentStringWithEmojiImage:(UIImage *)image
                                                        fontSize:(CGFloat)fontSize {
    if (!image || fontSize <= 0) return nil;
    
    BOOL hasAnim = NO;
    if (image.images.count > 1) {
        hasAnim = YES;
    } else if (NSProtocolFromString(@"YYAnimatedImage") &&
               [image conformsToProtocol:NSProtocolFromString(@"YYAnimatedImage")]) {
        NSNumber *frameCount = [image valueForKey:@"animatedImageFrameCount"];
        if (frameCount.intValue > 1) hasAnim = YES;
    }
    
    CGFloat ascent = YYTextEmojiGetAscentWithFontSize(fontSize);
    CGFloat descent = YYTextEmojiGetDescentWithFontSize(fontSize);
    CGRect bounding = YYTextEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width + 2 * bounding.origin.x;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), bounding.origin.x, descent + bounding.origin.y, bounding.origin.x);
    if (hasAnim) {
        Class imageClass = NSClassFromString(@"YYAnimatedImageView");
        if (!imageClass) imageClass = [UIImageView class];
        UIImageView *view = (id)[imageClass new];
        view.frame = bounding;
        view.image = image;
        view.contentMode = UIViewContentModeScaleAspectFit;
        attachment.content = view;
    } else {
        attachment.content = image;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr kf5_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr kf5_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSRange)kf5_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (BOOL)kf5_isSharedAttributesInAllRange {
    __block BOOL shared = YES;
    __block NSDictionary *firstAttrs = nil;
    [self enumerateAttributesInRange:self.kf5_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (range.location == 0) {
            firstAttrs = attrs;
        } else {
            if (firstAttrs.count != attrs.count) {
                shared = NO;
                *stop = YES;
            } else if (firstAttrs) {
                if (![firstAttrs isEqualToDictionary:attrs]) {
                    shared = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return shared;
}

- (BOOL)kf5_canDrawWithUIKit {
    static NSMutableSet *failSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        failSet = [NSMutableSet new];
        [failSet addObject:(id)kCTGlyphInfoAttributeName];
        [failSet addObject:(id)kCTCharacterShapeAttributeName];
        if (kiOS7Later) {
            [failSet addObject:(id)kCTLanguageAttributeName];
        }
        [failSet addObject:(id)kCTRunDelegateAttributeName];
        [failSet addObject:(id)kCTBaselineClassAttributeName];
        [failSet addObject:(id)kCTBaselineInfoAttributeName];
        [failSet addObject:(id)kCTBaselineReferenceInfoAttributeName];
        if (kiOS8Later) {
            [failSet addObject:(id)kCTRubyAnnotationAttributeName];
        }
        [failSet addObject:YYTextShadowAttributeName];
        [failSet addObject:YYTextInnerShadowAttributeName];
        [failSet addObject:YYTextUnderlineAttributeName];
        [failSet addObject:YYTextStrikethroughAttributeName];
        [failSet addObject:YYTextBorderAttributeName];
        [failSet addObject:YYTextBackgroundBorderAttributeName];
        [failSet addObject:YYTextBlockBorderAttributeName];
        [failSet addObject:YYTextAttachmentAttributeName];
        [failSet addObject:YYTextHighlightAttributeName];
        [failSet addObject:YYTextGlyphTransformAttributeName];
    });
    
#define Fail { result = NO; *stop = YES; return; }
    __block BOOL result = YES;
    [self enumerateAttributesInRange:self.kf5_rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count == 0) return;
        for (NSString *str in attrs.allKeys) {
            if ([failSet containsObject:str]) Fail;
        }
        if (!kiOS7Later) {
            UIFont *font = attrs[NSFontAttributeName];
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) Fail;
        }
        if (attrs[(id)kCTForegroundColorAttributeName] && !attrs[NSForegroundColorAttributeName]) Fail;
        if (attrs[(id)kCTStrokeColorAttributeName] && !attrs[NSStrokeColorAttributeName]) Fail;
        if (attrs[(id)kCTUnderlineColorAttributeName]) {
            if (!kiOS7Later) Fail;
            if (!attrs[NSUnderlineColorAttributeName]) Fail;
        }
        NSParagraphStyle *style = attrs[NSParagraphStyleAttributeName];
        if (style && CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) Fail;
    }];
    return result;
#undef Fail
}

@end

@implementation NSMutableAttributedString (YYText)

- (void)kf5_setAttributes:(NSDictionary *)attributes {
    [self setKf5_attributes:attributes];
}

- (void)setKf5_attributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self kf5_setAttribute:key value:obj];
    }];
}

- (void)kf5_setAttribute:(NSString *)name value:(id)value {
    [self kf5_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)kf5_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)kf5_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

#pragma mark - Property Setter

- (void)setKf5_font:(UIFont *)font {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self kf5_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setKf5_kern:(NSNumber *)kern {
    [self kf5_setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)setKf5_color:(UIColor *)color {
    [self kf5_setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setKf5_backgroundColor:(UIColor *)backgroundColor {
    [self kf5_setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)setKf5_strokeWidth:(NSNumber *)strokeWidth {
    [self kf5_setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)setKf5_strokeColor:(UIColor *)strokeColor {
    [self kf5_setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)setKf5_shadow:(NSShadow *)shadow {
    [self kf5_setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)setKf5_strikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self kf5_setStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)setKf5_strikethroughColor:(UIColor *)strikethroughColor {
    [self kf5_setStrokeColor:strikethroughColor range:NSMakeRange(0, self.length)];
}

- (void)setKf5_underlineStyle:(NSUnderlineStyle)underlineStyle {
    [self kf5_setUnderlineStyle:underlineStyle range:NSMakeRange(0, self.length)];
}

- (void)setKf5_underlineColor:(UIColor *)underlineColor {
    [self kf5_setUnderlineColor:underlineColor range:NSMakeRange(0, self.length)];
}

- (void)setKf5_ligature:(NSNumber *)ligature {
    [self kf5_setLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textEffect:(NSString *)textEffect {
    [self kf5_setTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)setKf5_obliqueness:(NSNumber *)obliqueness {
    [self kf5_setObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)setKf5_expansion:(NSNumber *)expansion {
    [self kf5_setExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)setKf5_baselineOffset:(NSNumber *)baselineOffset {
    [self kf5_setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setKf5_verticalGlyphForm:(BOOL)verticalGlyphForm {
    [self kf5_setVerticalGlyphForm:verticalGlyphForm range:NSMakeRange(0, self.length)];
}

- (void)setKf5_language:(NSString *)language {
    [self kf5_setLanguage:language range:NSMakeRange(0, self.length)];
}

- (void)setKf5_writingDirection:(NSArray *)writingDirection {
    [self kf5_setWritingDirection:writingDirection range:NSMakeRange(0, self.length)];
}

- (void)setKf5_paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self kf5_setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)setKf5_alignment:(NSTextAlignment)alignment {
    [self kf5_setAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)setKf5_baseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self kf5_setBaseWritingDirection:baseWritingDirection range:NSMakeRange(0, self.length)];
}

- (void)setKf5_lineSpacing:(CGFloat)lineSpacing {
    [self kf5_setLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)setKf5_paragraphSpacing:(CGFloat)paragraphSpacing {
    [self kf5_setParagraphSpacing:paragraphSpacing range:NSMakeRange(0, self.length)];
}

- (void)setKf5_paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self kf5_setParagraphSpacing:paragraphSpacingBefore range:NSMakeRange(0, self.length)];
}

- (void)setKf5_firstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self kf5_setFirstLineHeadIndent:firstLineHeadIndent range:NSMakeRange(0, self.length)];
}

- (void)setKf5_headIndent:(CGFloat)headIndent {
    [self kf5_setHeadIndent:headIndent range:NSMakeRange(0, self.length)];
}

- (void)setKf5_tailIndent:(CGFloat)tailIndent {
    [self kf5_setTailIndent:tailIndent range:NSMakeRange(0, self.length)];
}

- (void)setKf5_lineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self kf5_setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setKf5_minimumLineHeight:(CGFloat)minimumLineHeight {
    [self kf5_setMinimumLineHeight:minimumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setKf5_maximumLineHeight:(CGFloat)maximumLineHeight {
    [self kf5_setMaximumLineHeight:maximumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setKf5_lineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self kf5_setLineHeightMultiple:lineHeightMultiple range:NSMakeRange(0, self.length)];
}

- (void)setKf5_hyphenationFactor:(float)hyphenationFactor {
    [self kf5_setHyphenationFactor:hyphenationFactor range:NSMakeRange(0, self.length)];
}

- (void)setKf5_defaultTabInterval:(CGFloat)defaultTabInterval {
    [self kf5_setDefaultTabInterval:defaultTabInterval range:NSMakeRange(0, self.length)];
}

- (void)setKf5_tabStops:(NSArray *)tabStops {
    [self kf5_setTabStops:tabStops range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textShadow:(YYTextShadow *)textShadow {
    [self kf5_setTextShadow:textShadow range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textInnerShadow:(YYTextShadow *)textInnerShadow {
    [self kf5_setTextInnerShadow:textInnerShadow range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textUnderline:(YYTextDecoration *)textUnderline {
    [self kf5_setTextUnderline:textUnderline range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textStrikethrough:(YYTextDecoration *)textStrikethrough {
    [self kf5_setTextStrikethrough:textStrikethrough range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textBorder:(YYTextBorder *)textBorder {
    [self kf5_setTextBorder:textBorder range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textBackgroundBorder:(YYTextBorder *)textBackgroundBorder {
    [self kf5_setTextBackgroundBorder:textBackgroundBorder range:NSMakeRange(0, self.length)];
}

- (void)setKf5_textGlyphTransform:(CGAffineTransform)textGlyphTransform {
    [self kf5_setTextGlyphTransform:textGlyphTransform range:NSMakeRange(0, self.length)];
}

#pragma mark - Range Setter

- (void)kf5_setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self kf5_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)kf5_setKern:(NSNumber *)kern range:(NSRange)range {
    [self kf5_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)kf5_setColor:(UIColor *)color range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self kf5_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)kf5_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self kf5_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)kf5_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self kf5_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)kf5_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self kf5_setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)kf5_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self kf5_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)kf5_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self kf5_setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
}

- (void)kf5_setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
}

- (void)kf5_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self kf5_setAttribute:NSUnderlineStyleAttributeName value:style range:range];
}

- (void)kf5_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }
}

- (void)kf5_setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self kf5_setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)kf5_setTextEffect:(NSString *)textEffect range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSTextEffectAttributeName value:textEffect range:range];
    }
}

- (void)kf5_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
    }
}

- (void)kf5_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSExpansionAttributeName value:expansion range:range];
    }
}

- (void)kf5_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
    }
}

- (void)kf5_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *v = verticalGlyphForm ? @(YES) : nil;
    [self kf5_setAttribute:NSVerticalGlyphFormAttributeName value:v range:range];
}

- (void)kf5_setLanguage:(NSString *)language range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:(id)kCTLanguageAttributeName value:language range:range];
    }
}

- (void)kf5_setWritingDirection:(NSArray *)writingDirection range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)kf5_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self kf5_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

#define ParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
                 inRange:range \
                 options:kNilOptions \
              usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
                  NSMutableParagraphStyle *style = nil; \
                  if (value) { \
                      if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
                          value = [NSParagraphStyle kf5_styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
                      } \
                      if (value. _attr_ == _attr_) return; \
                      if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
                          style = (id)value; \
                      } else { \
                          style = value.mutableCopy; \
                      } \
                  } else { \
                      if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
                      style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
                  } \
                  style. _attr_ = _attr_; \
                  [self kf5_setParagraphStyle:style range:subRange]; \
              }];

- (void)kf5_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    ParagraphStyleSet(alignment);
}

- (void)kf5_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    ParagraphStyleSet(baseWritingDirection);
}

- (void)kf5_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    ParagraphStyleSet(lineSpacing);
}

- (void)kf5_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacing);
}

- (void)kf5_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacingBefore);
}

- (void)kf5_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    ParagraphStyleSet(firstLineHeadIndent);
}

- (void)kf5_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    ParagraphStyleSet(headIndent);
}

- (void)kf5_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    ParagraphStyleSet(tailIndent);
}

- (void)kf5_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    ParagraphStyleSet(lineBreakMode);
}

- (void)kf5_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    ParagraphStyleSet(minimumLineHeight);
}

- (void)kf5_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    ParagraphStyleSet(maximumLineHeight);
}

- (void)kf5_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    ParagraphStyleSet(lineHeightMultiple);
}

- (void)kf5_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    ParagraphStyleSet(hyphenationFactor);
}

- (void)kf5_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(defaultTabInterval);
}

- (void)kf5_setTabStops:(NSArray *)tabStops range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(tabStops);
}

#undef ParagraphStyleSet

- (void)kf5_setSuperscript:(NSNumber *)superscript range:(NSRange)range {
    if ([superscript isEqualToNumber:@(0)]) {
        superscript = nil;
    }
    [self kf5_setAttribute:(id)kCTSuperscriptAttributeName value:superscript range:range];
}

- (void)kf5_setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTGlyphInfoAttributeName value:(__bridge id)glyphInfo range:range];
}

- (void)kf5_setCharacterShape:(NSNumber *)characterShape range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTCharacterShapeAttributeName value:characterShape range:range];
}

- (void)kf5_setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)kf5_setBaselineClass:(CFStringRef)baselineClass range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTBaselineClassAttributeName value:(__bridge id)baselineClass range:range];
}

- (void)kf5_setBaselineInfo:(CFDictionaryRef)baselineInfo range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTBaselineInfoAttributeName value:(__bridge id)baselineInfo range:range];
}

- (void)kf5_setBaselineReferenceInfo:(CFDictionaryRef)referenceInfo range:(NSRange)range {
    [self kf5_setAttribute:(id)kCTBaselineReferenceInfoAttributeName value:(__bridge id)referenceInfo range:range];
}

- (void)kf5_setRubyAnnotation:(CTRubyAnnotationRef)ruby range:(NSRange)range {
    if (kSystemVersion >= 8) {
        [self kf5_setAttribute:(id)kCTRubyAnnotationAttributeName value:(__bridge id)ruby range:range];
    }
}

- (void)kf5_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSAttachmentAttributeName value:attachment range:range];
    }
}

- (void)kf5_setLink:(id)link range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self kf5_setAttribute:NSLinkAttributeName value:link range:range];
    }
}

- (void)kf5_setTextBackedString:(YYTextBackedString *)textBackedString range:(NSRange)range {
    [self kf5_setAttribute:YYTextBackedStringAttributeName value:textBackedString range:range];
}

- (void)kf5_setTextBinding:(YYTextBinding *)textBinding range:(NSRange)range {
    [self kf5_setAttribute:YYTextBindingAttributeName value:textBinding range:range];
}

- (void)kf5_setTextShadow:(YYTextShadow *)textShadow range:(NSRange)range {
    [self kf5_setAttribute:YYTextShadowAttributeName value:textShadow range:range];
}

- (void)kf5_setTextInnerShadow:(YYTextShadow *)textInnerShadow range:(NSRange)range {
    [self kf5_setAttribute:YYTextInnerShadowAttributeName value:textInnerShadow range:range];
}

- (void)kf5_setTextUnderline:(YYTextDecoration *)textUnderline range:(NSRange)range {
    [self kf5_setAttribute:YYTextUnderlineAttributeName value:textUnderline range:range];
}

- (void)kf5_setTextStrikethrough:(YYTextDecoration *)textStrikethrough range:(NSRange)range {
    [self kf5_setAttribute:YYTextStrikethroughAttributeName value:textStrikethrough range:range];
}

- (void)kf5_setTextBorder:(YYTextBorder *)textBorder range:(NSRange)range {
    [self kf5_setAttribute:YYTextBorderAttributeName value:textBorder range:range];
}

- (void)kf5_setTextBackgroundBorder:(YYTextBorder *)textBackgroundBorder range:(NSRange)range {
    [self kf5_setAttribute:YYTextBackgroundBorderAttributeName value:textBackgroundBorder range:range];
}

- (void)kf5_setTextAttachment:(YYTextAttachment *)textAttachment range:(NSRange)range {
    [self kf5_setAttribute:YYTextAttachmentAttributeName value:textAttachment range:range];
}

- (void)kf5_setTextHighlight:(YYTextHighlight *)textHighlight range:(NSRange)range {
    [self kf5_setAttribute:YYTextHighlightAttributeName value:textHighlight range:range];
}

- (void)kf5_setTextBlockBorder:(YYTextBorder *)textBlockBorder range:(NSRange)range {
    [self kf5_setAttribute:YYTextBlockBorderAttributeName value:textBlockBorder range:range];
}

- (void)kf5_setTextRubyAnnotation:(YYTextRubyAnnotation *)ruby range:(NSRange)range {
    if (kiOS8Later) {
        CTRubyAnnotationRef rubyRef = [ruby CTRubyAnnotation];
        [self kf5_setRubyAnnotation:rubyRef range:range];
        if (rubyRef) CFRelease(rubyRef);
    }
}

- (void)kf5_setTextGlyphTransform:(CGAffineTransform)textGlyphTransform range:(NSRange)range {
    NSValue *value = CGAffineTransformIsIdentity(textGlyphTransform) ? nil : [NSValue valueWithCGAffineTransform:textGlyphTransform];
    [self kf5_setAttribute:YYTextGlyphTransformAttributeName value:value range:range];
}

- (void)kf5_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo
                       tapAction:(YYTextAction)tapAction
                 longPressAction:(YYTextAction)longPressAction {
    YYTextHighlight *highlight = [YYTextHighlight highlightWithBackgroundColor:backgroundColor];
    highlight.userInfo = userInfo;
    highlight.tapAction = tapAction;
    highlight.longPressAction = longPressAction;
    if (color) [self kf5_setColor:color range:range];
    [self kf5_setTextHighlight:highlight range:range];
}

- (void)kf5_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(YYTextAction)tapAction {
    [self kf5_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:nil
                     tapAction:tapAction
               longPressAction:nil];
}

- (void)kf5_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo {
    [self kf5_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:userInfo
                     tapAction:nil
               longPressAction:nil];
}

- (void)kf5_insertString:(NSString *)string atIndex:(NSUInteger)location {
    [self replaceCharactersInRange:NSMakeRange(location, 0) withString:string];
    [self kf5_removeDiscontinuousAttributesInRange:NSMakeRange(location, string.length)];
}

- (void)kf5_appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self kf5_removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)kf5_setClearColorToJoinedEmoji {
    NSString *str = self.string;
    if (str.length < 8) return;
    
    // Most string do not contains the joined-emoji, test the joiner first.
    BOOL containsJoiner = NO;
    {
        CFStringRef cfStr = (__bridge CFStringRef)str;
        BOOL needFree = NO;
        UniChar *chars = NULL;
        chars = (void *)CFStringGetCharactersPtr(cfStr);
        if (!chars) {
            chars = malloc(str.length * sizeof(UniChar));
            if (chars) {
                needFree = YES;
                CFStringGetCharacters(cfStr, CFRangeMake(0, str.length), chars);
            }
        }
        if (!chars) { // fail to get unichar..
            containsJoiner = YES;
        } else {
            for (int i = 0, max = (int)str.length; i < max; i++) {
                if (chars[i] == 0x200D) { // 'ZERO WIDTH JOINER' (U+200D)
                    containsJoiner = YES;
                    break;
                }
            }
            if (needFree) free(chars);
        }
    }
    if (!containsJoiner) return;
    
    // NSRegularExpression is designed to be immutable and thread safe.
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((👨‍👩‍👧‍👦|👨‍👩‍👦‍👦|👨‍👩‍👧‍👧|👩‍👩‍👧‍👦|👩‍👩‍👦‍👦|👩‍👩‍👧‍👧|👨‍👨‍👧‍👦|👨‍👨‍👦‍👦|👨‍👨‍👧‍👧)+|(👨‍👩‍👧|👩‍👩‍👦|👩‍👩‍👧|👨‍👨‍👦|👨‍👨‍👧))" options:kNilOptions error:nil];
    });
    
    UIColor *clear = [UIColor clearColor];
    [regex enumerateMatchesInString:str options:kNilOptions range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self kf5_setColor:clear range:result.range];
    }];
}

- (void)kf5_removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString kf5_allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray *)kf5_allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName,
                 YYTextBackedStringAttributeName,
                 YYTextBindingAttributeName,
                 YYTextAttachmentAttributeName].mutableCopy;
        if (kiOS8Later) {
            [keys addObject:(id)kCTRubyAnnotationAttributeName];
        }
        if (kiOS7Later) {
            [keys addObject:NSAttachmentAttributeName];
        }
    });
    return keys;
}

@end
