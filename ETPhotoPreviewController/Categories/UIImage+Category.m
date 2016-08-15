//
//  UIImage+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "UIImage+Category.h"
#import <AssetsLibrary/AssetsLibrary.h>

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

- (UIImage *)_orientationFixedImageUsingOrientation:(UIImageOrientation)orientation
{
    // No-op if the orientation is already correct
    if (orientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
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
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (orientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// borrowed from http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
- (UIImage *)orientationFixedImage
{
    return [self _orientationFixedImageUsingOrientation:self.imageOrientation];
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
        NSMutableArray *groups=[[NSMutableArray alloc]init];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group)
            {
                [groups addObject:group];
            }
            
            else
            {
                BOOL haveHDRGroup = NO;
                
                for (ALAssetsGroup *gp in groups)
                {
                    NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                    
                    if ([name isEqualToString:customAlbumName])
                    {
                        haveHDRGroup = YES;
                    }
                }
                
                if (!haveHDRGroup)
                {
                    [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName
                                                   resultBlock:^(ALAssetsGroup *group)
                     {
                         [groups addObjectIfNotNil:group];
                         
                     }
                                                  failureBlock:nil];
                    haveHDRGroup = YES;
                }
            }
            
        };
        //创建相簿
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
        
        [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(self) customAlbumName:customAlbumName completionBlock:completionBlock failureBlock:failureBlock];
    });
    
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock();
                        }
                    });
                }
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
    };
    __weak typeof(assetsLibrary) weakassetsLibrary = assetsLibrary;
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakassetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
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
                } else {
                    AddAsset(weakassetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakassetsLibrary, assetURL);
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock();
                }
            });
        }
    }];
}

@end
