//
//  ETPhotoPreviewView.m
//  MyProject
//
//  Created by Ethan on 16/8/5.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "ETPhotoPreviewView.h"
#import "ETProgressBar.h"
#import <AFURLSessionManager.h>
#import <SDImageCache.h>
#import <SDWebImageManager.h>

@interface ETPhotoPreviewView()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, assign) BOOL downloadFailed;
@property (nonatomic, strong) ETProgressBar *progressBar;

@end

@implementation ETPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.progressBar];
    }
    return self;
}

- (void)showImageOrDownload {
    if (![self showImageIfIsFileURL]) {
        [self downloadIfIsOnlineURL];
    }
}

- (BOOL)showImageIfIsFileURL {
    NSURL *fileURL;
    if (self.sourceURL.isFileURL) {
        fileURL = self.sourceURL;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:self.destationURL.path]) {
        self.sourceURL = self.destationURL;
        fileURL = self.sourceURL;
    }
    if (fileURL) {
        self.progressBar.hidden = YES;
        [self setScaleImage:[UIImage imageWithContentsOfFile:fileURL.path]];
        return YES;
    }

    return NO;
}

- (BOOL)downloadIfIsOnlineURL {
    if (self.sourceURL.isFileURL) {
        return NO;
    }
    if (!_task || _task.state != NSURLSessionTaskStateRunning) {
        _task = nil;
        [self removeScaleImage];
        self.progressBar.progress = 0;
        self.progressBar.hidden = NO;
        [self.task resume];
        return YES;
    }
    return NO;
}

- (ETProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[ETProgressBar alloc] initWithFrame:CGRectMake(30, self.height/2-7/2.0, self.width - 30*2, 7)];
        _progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _progressBar;
}

- (NSURLSessionDownloadTask *)task {
    if (!_task) {
        __weak typeof(self) weakSelf = self;
        _task = [self.sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:self.sourceURL] progress:^(NSProgress * _Nonnull downloadProgress) {
            typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.progressBar.progress = downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount;
            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            typeof(weakSelf) strongSelf = weakSelf;
            return strongSelf.destationURL;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.downloadFailed = error != nil;
            strongSelf.progressBar.hidden = YES;
            [strongSelf setScaleImage:[UIImage imageWithContentsOfFile:filePath.path]];
            if (!error) {
                strongSelf.sourceURL = filePath;
            }
        }];
    }
    return _task;
}

- (NSURL *)destationURL {
    NSURL *URL;
    if (!_destationURL) {
        URL = [NSURL fileURLWithPath:[[SDImageCache sharedImageCache] defaultCachePathForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:self.sourceURL]]];
    } else {
        URL = _destationURL;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:URL.path.stringByDeletingLastPathComponent]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:URL.path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
        }
    }
    return URL;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
