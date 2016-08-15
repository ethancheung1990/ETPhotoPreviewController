//
//  ETPhotoPreviewView.h
//  MyProject
//
//  Created by Ethan on 16/8/5.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "ETScaleView.h"

@class ETProgressBar;
@class AFURLSessionManager;

@interface ETPhotoPreviewView : ETScaleView

@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *task;
@property (nonatomic, strong, readonly) ETProgressBar *progressBar;
@property (nonatomic, strong) NSURL *sourceURL; // the URL online or local
@property (nonatomic, strong) NSURL *destationURL;// download destation URL
@property (nonatomic, weak) AFURLSessionManager *sessionManager;

- (void)showImageOrDownload;

- (BOOL)showImageIfIsFileURL;

- (BOOL)downloadIfIsOnlineURL;

@end
