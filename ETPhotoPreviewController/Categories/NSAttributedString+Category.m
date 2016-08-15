//
//  NSAttributedString+Category.m
//  MyProject
//
//  Created by Nemo on 14-4-4.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSAttributedString+Category.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Category)

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize
{
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CGSize sz = CGSizeMake(0.f, 0.f);
    if (framesetter)
        {
        CFRange fitCFRange = CFRangeMake(0,0);
        sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
        sz = CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
        CFRelease(framesetter);
        }
    return sz;
}

- (void)addLineSpacing:(CGFloat)lineSpacing withFont:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.minimumLineHeight = font.lineHeight;
    paragraphStyle.maximumLineHeight = font.lineHeight;
    paragraphStyle.lineHeightMultiple = 1;
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.headIndent = paragraphStyle.firstLineHeadIndent;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [(NSMutableAttributedString *)self addAttributes:@{(NSString *)kCTParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, self.string.length)];
}
@end
