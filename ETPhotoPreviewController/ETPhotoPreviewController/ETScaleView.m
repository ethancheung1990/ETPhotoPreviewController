//
//  ETScaleView.m
//  MyProject
//
//  Created by Ethan on 13-12-30.
//  Copyright (c) 2013年 ethan. All rights reserved.
//

#import "ETScaleView.h"

typedef NS_OPTIONS(NSUInteger, IMAGE_POSIT) {
    IMAGE_POSIT_XEDGE = 1 << 0,
    IMAGE_POSIT_XCENTER = 1 << 1,
    IMAGE_POSIT_YEDGE = 1 << 2,
    IMAGE_POSIT_YCENTER = 1<<3,
};

@interface ETScaleView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;


@end


@implementation ETScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = frame.size;
        
        self.scale = 1.0f;
        self.imageView = [[UIImageView alloc] init];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        pinch.delegate = self;
        [self.imageView addGestureRecognizer:pinch];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
        tap1.delegate = self;
        tap1.numberOfTouchesRequired = 1;
        tap1.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
        tap2.delegate = self;
        tap2.numberOfTouchesRequired = 1;
        tap2.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:tap2];
        
        [tap1 requireGestureRecognizerToFail:tap2];
        
        UILongPressGestureRecognizer *lo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        lo.delegate = self;
        [self addGestureRecognizer:lo];
        
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)setScaleImage:(UIImage*)image {
    if (image) {
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = image;
    } else {
        self.imageView.image = self.defaultImage;
        self.imageView.userInteractionEnabled = NO;
    }
    [self _setImageViewScale:-1 animated:NO];
    
}

- (void)removeScaleImage {
    self.imageView.image = nil;
    self.imageView.userInteractionEnabled = NO;
}

- (void)setImageViewCenterImageMode {
    
    if (self.imageView.image.size.height <= 0 || self.imageView.image.size.width <= 0) {
        return;
    }
    if (self.imageView.image.size.width/self.imageView.image.size.height > self.width/self.height) {
        self.scale = MAX(MIN(self.height/self.imageView.image.size.height*[UIScreen mainScreen].scale, 1.0f), CGFLOAT_MIN);
    } else {
        self.scale = MAX(MIN(self.width/self.imageView.image.size.width*[UIScreen mainScreen].scale, 1.0f), CGFLOAT_MIN);
    }
    self.minScale = self.scale/5.0;
    self.maxScale = MAX(self.scale*5, 1.0f);
    
    [self _refreshImageViewScale];
    
}

- (void)setImageViewFullScreenMode {
    
    if (self.imageView.image.size.height <= 0 || self.imageView.image.size.width <= 0) {
        return;
    }
    CGFloat maxScale;
    if (self.imageView.image.size.width/self.imageView.image.size.height > self.width/self.height) {
        self.scale = MAX(MIN(self.width/self.imageView.image.size.width*[UIScreen mainScreen].scale, 1.0f), CGFLOAT_MIN);
        maxScale = MAX(self.height/self.imageView.image.size.height*[UIScreen mainScreen].scale, CGFLOAT_MIN);
    } else {
        self.scale = MAX(MIN(self.height/self.imageView.image.size.height*[UIScreen mainScreen].scale, 1.0f), CGFLOAT_MIN);
        maxScale = MAX(self.width/self.imageView.image.size.width*[UIScreen mainScreen].scale, CGFLOAT_MIN);
    }
    self.minScale = self.scale/5.0f;
    self.maxScale = MAX(maxScale, MAX(self.scale*5, 1.0f));
    
    [self _refreshImageViewScale];
}

#pragma mark - gesture selector

- (void)pinch:(UIPinchGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self _exchangeContentAndImagePoint];
    }
    
    CGPoint p1 = [gesture locationOfTouch:0 inView:self.imageView];
    CGPoint p2;
    if (gesture.numberOfTouches < 2) {
        p2 = p1;
    } else {
        p2 = [gesture locationOfTouch:1 inView:self.imageView];
    }
    CGPoint center = CGPointMake(p1.x/2 + p2.x/2, p1.y/2 + p2.y/2);
    
    CGSize size = [self _scaleImageViewWithDeltaScale:gesture.scale centerPoint:center animated:NO canOver:YES];
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    gesture.scale = 1.0f;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self _finalStateWithWidth:width height:height];
    }
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    CGPoint point = [gesture translationInView:self.imageView];

    if (self.imageView.height > self.height) {
        self.imageView.top = MIN(MAX(self.imageView.top + point.y, self.height - self.imageView.height), 0);
    }
    if (self.imageView.width > self.width) {
        self.imageView.left = MIN(MAX(self.imageView.left + point.x, self.width - self.imageView.width), 0);
    }
    [gesture setTranslation:CGPointZero inView:self.imageView];
    
    CGFloat width = self.imageView.width;
    CGFloat height = self.imageView.height;

    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (width<self.width && height < self.height) {
            [self _setImageViewScale:self.scale animated:YES];
        } else {
            
            IMAGE_POSIT posit = 0;
            
            if (width >= self.width && (self.imageView.left > 0 || (self.width - self.imageView.left > self.imageView.width))) {
                posit |= IMAGE_POSIT_XEDGE;
            } else if (width < self.width) {
                posit |= IMAGE_POSIT_XCENTER;
            }
            
            if (height >= self.height && (self.imageView.top > 0 || (self.height - self.imageView.top > self.imageView.height))) {
                posit |= IMAGE_POSIT_YEDGE;
            } else if (height < self.height) {
                posit |= IMAGE_POSIT_YCENTER;
            }
            
            [self _setImageViewPosit:posit animated:YES];
        }
    }
}

- (void)tap1:(UITapGestureRecognizer*)gesture {
    if ([self.scaleViewDelegate respondsToSelector:@selector(scaleViewDidSingleOneTap:)]) {
        [self.scaleViewDelegate scaleViewDidSingleOneTap:self];
    }
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.scaleViewDelegate respondsToSelector:@selector(scaleViewDidLongPressed:)]) {
            [self.scaleViewDelegate scaleViewDidLongPressed:self];
        }
    }
}

- (void)tap2:(UITapGestureRecognizer*)gesture {
    
    if (self.imageView.top <= 0) {
        CGFloat top = self.imageView.top;
        self.imageView.top = -self.contentOffset.y;
        self.contentOffset = CGPointMake(self.contentOffset.x, -top);
    }
    if (self.imageView.left <= 0) {
        CGFloat left = self.imageView.left;
        self.imageView.left = - self.contentOffset.x;
        self.contentOffset = CGPointMake(-left, self.contentOffset.y);
    }
    
    if (self.scale == self.maxScale) {
        [self _setImageViewScale:-1 animated:YES];
    } else {
        [self _scaleImageViewWithDeltaScale:self.maxScale/self.scale centerPoint:[gesture locationInView:self.imageView] animated:YES canOver:NO];
    }
}

#pragma mark - private

- (void)_finalStateWithWidth:(CGFloat)width height:(CGFloat)height {
    BOOL needDo = YES;
    if (width<self.width && height < self.height) {
        if (self.scale < 1.0f) {
            [self _setImageViewScale:-1 animated:YES];
        } else {
            [self _setImageViewScale:self.scale animated:YES];
        }
        needDo = NO;
    } else {
        
        IMAGE_POSIT posit = 0;
        
        if (width >= self.width && (self.imageView.left > 0 || (self.width - self.imageView.left > self.imageView.width))) {
            posit |= IMAGE_POSIT_XEDGE;
            needDo = NO;
        } else if (width < self.width) {
            posit |= IMAGE_POSIT_XCENTER;
            needDo = NO;
        }
        
        if (height >= self.height && (self.imageView.top > 0 || (self.height - self.imageView.top > self.imageView.height))) {
            posit |= IMAGE_POSIT_YEDGE;
            needDo = NO;
        } else if (height < self.height) {
            posit |= IMAGE_POSIT_YCENTER;
            needDo = NO;
        }
        
        if (needDo) {
            [self _exchangeContentAndImagePoint];
        } else {
            [self _setImageViewPosit:posit animated:YES];
        }
    }
}


- (void)_setImageViewScale:(CGFloat)scale animated:(BOOL)animated {
    
    void (^animateBlock)(void) = ^ {
        if (scale == -1) {
            [self setImageViewFullScreenMode];
        } else {
            self.scale = scale;
            [self _refreshImageViewScale];
        }
    };
    
    void (^completeBlock)(BOOL) = ^(BOOL finish){
        [self _exchangeContentAndImagePoint];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f animations:animateBlock completion:completeBlock];
    } else {
        animateBlock();
        completeBlock(YES);
    }
}

- (void)_refreshImageViewScale {
    CGFloat width = self.imageView.image.size.width/[UIScreen mainScreen].scale*self.scale;
    CGFloat height = self.imageView.image.size.height/[UIScreen mainScreen].scale*self.scale;
    self.contentSize = CGSizeMake(width, height);
    self.imageView.frame = CGRectMake(self.width/2 - width/2, self.height/2 - height/2, width, height);
}

- (CGSize)_scaleImageViewWithDeltaScale:(CGFloat)scale centerPoint:(CGPoint)center animated:(BOOL)animated canOver:(BOOL)canOver {
    if (self.scale <= 0) {
        self.scale = 1;
    }
    CGFloat left = center.x;
    CGFloat top = center.y;
    CGFloat lastScale = self.scale;
    self.scale = MAX(MIN(self.scale*scale, self.maxScale), self.minScale);
    CGFloat width = self.imageView.image.size.width/[UIScreen mainScreen].scale*self.scale;
    CGFloat height = self.imageView.image.size.height/[UIScreen mainScreen].scale*self.scale;
    
    CGFloat widthAdd = left*(self.scale/lastScale) - left;
    CGFloat heightAdd = top*(self.scale/lastScale) - top;
    CGFloat x = self.imageView.left- widthAdd;
    CGFloat y = self.imageView.top - heightAdd;
    
    if (!canOver) {
        x = MAX(MIN(x, 0), self.imageView.superview.width - width);
        y = MAX(MIN(y, 0), self.imageView.superview.height - height);
        if (width < self.width) {
            x = self.width/2 - width/2;
        }
        if (height < self.height) {
            y = self.height/2 - height/2;
        }
    }
    void(^animateBlock)(void) = ^ {
        self.imageView.frame = CGRectMake(x, y, width, height);
        self.contentSize = self.imageView.size;
    };
    
    void (^completeBlock)(BOOL) = ^(BOOL finish){
        [self _exchangeContentAndImagePoint];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f animations:animateBlock completion:completeBlock];
    } else {
        animateBlock();
    }
    
    
    return CGSizeMake(width, height);
    
}


- (void)_setImageViewPosit:(IMAGE_POSIT)posit animated:(BOOL)animated {
    void (^animateBlock)(void) = ^{
        BOOL shouldChange = NO;
        int left = 0;
        int top = 0;
        if (posit & IMAGE_POSIT_XEDGE) {
            if (self.imageView.left >= 0) {
                left = 0;
            } else {
                left = self.width - self.imageView.width;
            }
            shouldChange = YES;
        } else if (posit & IMAGE_POSIT_XCENTER) {
            left = self.width/2 - self.imageView.width/2;
            shouldChange = YES;
        } else {
            left = self.imageView.left;
        }
        
        if (posit & IMAGE_POSIT_YEDGE) {
            if (self.imageView.top >= 0) {
                top = 0;
            } else {
                top = self.height - self.imageView.height;
            }
            shouldChange = YES;
        } else if (posit & IMAGE_POSIT_YCENTER) {
            top = self.height/2 - self.imageView.height/2;
            shouldChange = YES;
        } else {
            top = self.imageView.top;
        }
        
        if (shouldChange) {
            self.imageView.frame = CGRectMake(left, top, self.imageView.width, self.imageView.height);
        }
        
    };
    
    void (^completeBlock)(BOOL) = ^(BOOL finish){
        [self _exchangeContentAndImagePoint];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f animations:animateBlock completion:completeBlock];
    } else {
        animateBlock();
        completeBlock(YES);
    }
}

- (void)_exchangeContentAndImagePoint {
    if (self.imageView.top <= 0) {
        CGFloat top = self.imageView.top;
        self.imageView.top = -self.contentOffset.y;
        self.contentOffset = CGPointMake(self.contentOffset.x, -top);
    }
    if (self.imageView.left <= 0) {
        CGFloat left = self.imageView.left;
        self.imageView.left = - self.contentOffset.x;
        self.contentOffset = CGPointMake(-left, self.contentOffset.y);
    }
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
