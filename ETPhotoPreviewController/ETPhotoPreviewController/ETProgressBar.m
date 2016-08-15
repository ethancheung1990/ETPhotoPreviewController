//
//  ETProgressBar.m
//  MyProject
//
//  Created by Ethan on 13-12-24.
//  Copyright (c) 2013年 ethan. All rights reserved.
//

#import "ETProgressBar.h"

@interface ETProgressBar()

@property (nonatomic, strong) UIImageView *progressView;
@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation ETProgressBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.image = [[UIImage imageNamed:@"loading_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 2)];
        self.progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        self.progressView.image = [[UIImage imageNamed:@"loading"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 3, 2)];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    self.progressView.width = MAX(self.backgroundView.width*_progress, 0);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
