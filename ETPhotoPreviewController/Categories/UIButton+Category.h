//
//  UIButton+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *highlightedTitle;
@property (nonatomic, copy) NSString *disabledTitle;
@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic, copy) NSAttributedString *normalAttributedTitle;

@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *highlightedTitleColor;
@property (nonatomic, strong) UIColor *disabledTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) UIColor *normalTitleShadowColor;
@property (nonatomic, strong) UIColor *highlightedTitleShadowColor;
@property (nonatomic, strong) UIColor *disabledTitleShadowColor;
@property (nonatomic, strong) UIColor *selectedTitleShadowColor;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *disabledImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;
@property (nonatomic, strong) UIImage *disabledBackgroundImage;
@property (nonatomic, strong) UIImage *selectedBackgroundImage;
@property (nonatomic, strong) UIImage *highSelectedBackgroundImage;


-(void)centerButtonAndImageWithSpacing:(CGFloat)spacing;
-(void)exchangeImageAndTitleWithSpacing:(CGFloat)spacing;
-(void)centerMyTitle:(CGFloat)spacing;
-(void)normalMyTitle;
//button根据image大小改变
- (void)setBackgroundImage:(UIImage*)image;
- (void)setBackgroundImageByName:(NSString*)imageName;

- (void)normalTitle:(NSString *)string;
- (void)normalImage:(UIImage *)image;
- (void)highlightTitle:(NSString *)string;
- (void)highlightImage:(UIImage *)image;
- (void)centerContent:(CGFloat)spacing;
- (void)exchangePositionForImageAndTitleWithSpacing:(CGFloat)spacing;

@end
