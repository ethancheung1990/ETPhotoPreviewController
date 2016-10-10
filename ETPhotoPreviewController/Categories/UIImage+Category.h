//
//  UIImage+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
//图片等比缩放
- (UIImage *)imageScaleMultipe:(float)scaleSize;

+ (UIImage *)imageNamedUncache:(NSString *)imageName;

//截图
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r;

+ (UIImage *)imageFromColor:(UIColor *)color;

- (UIImage *)imageMaskWithColor:(UIColor *)maskColor;

- (UIImage *)thumbnailForMaxWidth:(CGFloat)maxWith maxHeight:(CGFloat)maxHeight;

- (UIImage *)rotateImageUsingOrientation:(UIImageOrientation)orientation;

- (UIImage *)orientationFixedImage;

+ (void)alblumPhotoImageWithComplete:(void(^)(UIImage* image))completeBlock;

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;

@end
