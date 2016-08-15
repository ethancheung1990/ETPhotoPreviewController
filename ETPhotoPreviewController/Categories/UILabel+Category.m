//
//  UILabel+Category.m
//  MyProject
//
//  Created by Nemo on 14-4-4.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "UILabel+Category.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Category)

- (CGFloat)heightForLableAttributedStringConstrainedToSize:(CGSize )maxSize
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CGSize sz = CGSizeMake(0.f, 0.f);
    if (framesetter)
        {
        CFRange fitCFRange = CFRangeMake(0,0);
        sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
        sz = CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
        CFRelease(framesetter);
        }

    return  sz.height;
}

- (void)sizeToFitWithSize:(CGSize)size {
    if (self.attributedText) {
        self.size = size;
        [self sizeToFit];
        if (self.width > size.width) {
            self.width = size.width;
        }
        if (self.height > size.height) {
            self.height = size.height;
        }
    } else {
        CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
        self.size = newSize;
    }
    
}

@end
