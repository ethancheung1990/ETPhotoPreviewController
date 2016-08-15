//
//  NSAttributedString+Category.h
//  MyProject
//
//  Created by Nemo on 14-4-4.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Category)

/**
 *calcute size of self constranined to size
 */
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize;
- (void)addLineSpacing:(CGFloat)lineSpacing withFont:(UIFont *)font;
@end
