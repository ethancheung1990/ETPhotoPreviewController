//
//  ETScaleView.h
//  MyProject
//
//  Created by Ethan on 13-12-30.
//  Copyright (c) 2013年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETScaleViewDelegate;

@interface ETScaleView : UIScrollView

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, weak) id<ETScaleViewDelegate> scaleViewDelegate;

@property (nonatomic, strong) UIImage *defaultImage;

- (void)setScaleImage:(UIImage*)image;
- (void)removeScaleImage;

- (void)setImageViewFullScreenMode;
- (void)setImageViewCenterImageMode;

@end

@protocol ETScaleViewDelegate <NSObject>

- (void)scaleViewDidSingleOneTap:(ETScaleView*)scaleView;
- (void)scaleViewDidLongPressed:(ETScaleView*)scaleView;

@end
