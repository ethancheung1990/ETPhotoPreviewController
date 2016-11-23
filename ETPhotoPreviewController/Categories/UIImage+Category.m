//
//  UIImage+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "UIImage+Category.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation UIImage (Category)

- (UIImage *)imageScaleMultipe:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

+ (UIImage *)imageNamedUncache:(NSString *)imageName
{
    NSString *resource = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:imageName];
    return [[UIImage alloc] initWithContentsOfFile:resource];
}

+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageMaskWithColor:(UIColor *)maskColor {
    if (!maskColor) {
        return nil;
    }
    
    UIImage *newImage = nil;
    
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, maskColor.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailForMaxWidth:(CGFloat)maxWith maxHeight:(CGFloat)maxHeight
{
    if (self.size.width == 0 || self.size.height == 0) return nil;
    
    CGSize targetSize = CGSizeMake(maxWith, maxHeight);
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0, scaledWidth = imageSize.width, scaledHeight = imageSize.height;
    
    if (imageSize.width > targetSize.width)
    {
        CGFloat widthFactor = targetSize.width / width;
        CGFloat heightFactor = targetSize.height / height;
        
        if (widthFactor < heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    
    if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationLeft) {
        CGFloat tempWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = tempWidth;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledWidth, scaledHeight), YES, 0.0); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointMake(0.0, 0.0);
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)rotateImageUsingOrientation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height*self.scale, self.size.width*self.scale);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height*self.scale, self.size.width*self.scale);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width*self.scale, self.size.height*self.scale);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width*self.scale, self.size.height*self.scale);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}

// borrowed from http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
- (UIImage *)orientationFixedImage
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width*self.scale, self.size.height*self.scale);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width*self.scale, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height*self.scale);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width*self.scale, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height*self.scale, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width*self.scale, self.size.height*self.scale,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height*self.scale, self.size.width*self.scale), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width*self.scale, self.size.height*self.scale), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)alblumPhotoImageWithComplete:(void(^)(UIImage* image))completeBlock {
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    // Group enumerator Block
    
    __block UIImage *image = nil;
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            if (completeBlock) {
                if (!image) {
                    image = [UIImage new];
                }
                completeBlock(image);
            }
            return;
        }
        
        // added fix for camera albums order
        NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
        
        if (nType == ALAssetsGroupSavedPhotos) {
            image = [UIImage imageWithCGImage:[group posterImage]];
            if (completeBlock) {
                if (!image) {
                    image = [UIImage new];
                }
                completeBlock(image);
            }
            return;
        }
        
    };
    
    // Group Enumerator Failure Block
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        NSLog(@"A problem occured %@", [error description]);
        if (completeBlock) {
            if (!image) {
                image = [UIImage new];
            }
            completeBlock(image);
        }
    };
    
    // Enumerate Albums
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:assetGroupEnumerator
                              failureBlock:assetGroupEnumberatorFailure];
    
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary writeImageDataToSavedPhotosAlbum:UIImagePNGRepresentation(self) metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failureBlock) {
                        failureBlock(error);
                    }
                });
            } else {
                if (customAlbumName) {
                    
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        [self.class _createAlbumIfNeedWithCustomAlbumName:customAlbumName ALAssetsLibrary:assetsLibrary completionBlock:^(ALAssetsGroup *group) {
                            [group addAsset:asset];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completionBlock) {
                                    completionBlock();
                                }
                            });
                        } failureBlock:^(NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (failureBlock) {
                                    failureBlock(error);
                                }
                            });
                        }];
                    } failureBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failureBlock) {
                                failureBlock(error);
                            }
                        });
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock();
                        }
                    });
                }
            }
        }];
        
    });
    
}

+ (void)_createAlbumIfNeedWithCustomAlbumName:(NSString *)customAlbumName
                              ALAssetsLibrary:(ALAssetsLibrary*)assetsLibrary
                              completionBlock:(void (^)(ALAssetsGroup *group))completionBlock
                                 failureBlock:(void (^)(NSError *error))failureBlock{
    if (!assetsLibrary) {
        assetsLibrary = [ALAssetsLibrary new];
    }
    
    __weak typeof(self) weakSelf = self;
    [self _groupWithAlbumName:customAlbumName ALAssetsLibrary:assetsLibrary completionBlock:^(ALAssetsGroup *group) {
        if (group) {
            if (completionBlock) {
                completionBlock(group);
            }
        } else {
            if (IS_IOS8) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:customAlbumName];
                } completionHandler:^(BOOL success, NSError *error) {
                    if (error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    } else {
                        [weakSelf _groupWithAlbumName:customAlbumName ALAssetsLibrary:assetsLibrary completionBlock:^(ALAssetsGroup *group) {
                            if (completionBlock) {
                                completionBlock(group);
                            }
                        } failureBlock:^(NSError *error) {
                            if (failureBlock) {
                                failureBlock(error);
                            }
                        }];
                    }
                }];
            } else {
                [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName
                                               resultBlock:^(ALAssetsGroup *group) {
                                                   if (completionBlock) {
                                                       completionBlock(group);
                                                   }
                                               } failureBlock:^(NSError *error) {
                                                   if (failureBlock) {
                                                       failureBlock(error);
                                                   }
                                               }];
            }
            
        }
    } failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)_groupWithAlbumName:(NSString*)customAlbumName ALAssetsLibrary:(ALAssetsLibrary*)assetsLibrary completionBlock:(void (^)(ALAssetsGroup *group))completionBlock failureBlock:(void (^)(NSError *error))failureBlock{
    
    __block BOOL hasSame = NO;
    ALAssetsLibraryGroupsEnumerationResultsBlock block = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:customAlbumName]) {
                if (completionBlock) {
                    completionBlock(group);
                }
                hasSame = YES;
                *stop = YES;
            }
        } else if (!hasSame) {
            if (completionBlock) {
                completionBlock(nil);
            }
        }
    };
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:block failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
