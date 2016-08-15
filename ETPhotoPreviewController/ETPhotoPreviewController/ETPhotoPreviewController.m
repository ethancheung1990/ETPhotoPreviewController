//
//  ETPhotoPreviewController.m
//  MyProject
//
//  Created by Ethan on 14-10-9.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "ETPhotoPreviewController.h"
#import "ETPhotoPreviewView.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, PreviewType) {
    PreviewTypeShow,
    PreviewTypePresent,
};

@interface ETPhotoPreviewController()<UIScrollViewDelegate, ETScaleViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) NSArray<NSURL*> *sourceURLs;
@property (nonatomic, copy) NSArray<NSURL*> *destationURLs;
@property (nonatomic, strong) NSMutableArray *imageRects;
@property (nonatomic, strong) NSMutableArray<ETPhotoPreviewView*> *previews;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIPageControl *pager;

@property (nonatomic, assign) NSUInteger lastIndex;
@property (nonatomic, assign) NSUInteger initIndex;

@property (nonatomic, strong) AFURLSessionManager *downloadManager;

@property (nonatomic, assign) UIModalPresentationStyle rootControlerModalPresentationStyle;

@property (nonatomic, assign) PreviewType previewType;
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@end

@implementation ETPhotoPreviewController

+ (CGRect)convertImageRect:(CGRect)rect imageSuperView:(UIView *)superView {
    CGRect frame = [[UIApplication sharedApplication].delegate.window convertRect:rect fromView:superView];
    return frame;
}

- (void)dealloc {
    for (NSURLSessionDownloadTask *task in self.downloadManager.downloadTasks) {
        [task cancel];
    }
}

- (instancetype)initWithSourceUrls:(nonnull NSArray<NSURL*> *)sourceURLs destationURLs:(nullable NSArray<NSURL*> *)destationURLs fromViews:(nullable NSArray<UIView*> *)views initIndex:(NSUInteger)index {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSAssert(sourceURLs.count == destationURLs.count || destationURLs.count == 0, @"sourceURLs and destationURLs should have the same count");
        NSAssert(sourceURLs.count == views.count || views.count == 0, @"sourceURLs and views should have the same count");
        
        if (IS_IOS8) {
            self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        } else {
            self.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        self.modalPresentationCapturesStatusBarAppearance = YES;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        NSMutableArray *imageRects = [NSMutableArray new];
        [views enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = [self.class convertImageRect:obj.frame imageSuperView:obj.superview];
            [imageRects addObject:[NSValue valueWithCGRect:rect]];
        }];
        NSInteger deltaCount = sourceURLs.count - imageRects.count;
        for (int i = 0; i < deltaCount; ++i) {
            [imageRects addObject:[NSValue valueWithCGRect:CGRectZero]];
        }
        self.imageRects = imageRects;
        
        self.initIndex = MIN(MAX(0, index), sourceURLs.count);
        self.sourceURLs = sourceURLs;
        self.destationURLs = destationURLs;
        
        self.previews = [NSMutableArray array];
        self.lastIndex = self.initIndex;
        
        self.downloadManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
    }
    return self;
}

- (instancetype)initWithSourceUrls:(nonnull NSArray<NSURL*> *)sourceURLs fromViews:(nullable NSArray<UIView*> *)views initIndex:(NSUInteger)index {
    return [self initWithSourceUrls:sourceURLs destationURLs:nil fromViews:views initIndex:index];
}

- (BOOL)prefersStatusBarHidden {
    return self.isFullScreen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _layout];
    [self _refreshTitle];
}

- (void)show {
    
    self.previewType = PreviewTypeShow;
    self.view.backgroundColor = [UIColor clearColor];
    
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    self.rootControlerModalPresentationStyle = rootController.modalPresentationStyle;
    if (IS_IOS8) {
        rootController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        rootController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [rootController presentViewController:self animated:NO completion:^{
        [self _previewWithShowType];
    }];
    
}

- (void)present {
    
    self.previewType = PreviewTypePresent;
    self.view.backgroundColor = [UIColor blackColor];
    
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    if ([self.delegate respondsToSelector:@selector(photoPreviewController:didTapMoreWithView:completion:)]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(_moreTap)];
    }
    [rootController presentViewController:nav animated:YES completion:nil];
    [self _previewWithPresentType];
}

- (void)_refreshTitle {
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", self.currentPage+1, self.previews.count];
}

- (void)dismiss {
    
    if (self.previewType == PreviewTypeShow) {
        [self _dismissFromShowType];
    } else {
        [self _dismissFromPresentType];
    }
    
}

- (void)deletePhotoAtIndex:(NSUInteger)index {
    if (index < self.previews.count) {
        ETPhotoPreviewView *view = self.previews[index];
        [view.task cancel];
        [view removeFromSuperview];
        [self.previews removeObjectAtIndex:index];
        [self.imageRects removeObjectAtIndex:index];
        if (self.previews.count == 0) {
            [self dismiss];
            return;
        }
        
        [self.previews enumerateObjectsUsingBlock:^(ETPhotoPreviewView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.left = idx*self.scroller.width;
        }];
        
        NSUInteger currentPage = self.currentPage;
        self.pager.numberOfPages = self.previews.count;
        
        if (index < currentPage) {
            self.pager.currentPage--;
            self.lastIndex = self.currentPage;
        } else if (index == currentPage) {
            [self _didScrollToIndex:self.currentPage];
        }
        
        self.scroller.contentSize = CGSizeMake(self.scroller.width*self.previews.count, self.scroller.height);
        [self _scrollToIndex:self.currentPage];
        
    }
}

#pragma mark - private

- (void)_layout
{
    [self.view addSubview:self.backgroundView];
    self.backgroundView.alpha = 0;
    
    [self.sourceURLs enumerateObjectsUsingBlock:^(NSURL*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ETPhotoPreviewView *v = [[ETPhotoPreviewView alloc] initWithFrame:self.scroller.bounds];
        v.scaleViewDelegate = self;
        v.sourceURL = obj;
        v.destationURL = idx < self.destationURLs.count ? self.destationURLs[idx] : nil;
        v.sessionManager = self.downloadManager;
        [self.previews addObject:v];
        v.left = idx*self.scroller.width;
        [self.scroller addSubview:v];
        [v showImageIfIsFileURL];
    }];
    
    self.scroller.contentSize = CGSizeMake(self.scroller.width*self.previews.count, self.scroller.height);
    [self.view addSubview:self.scroller];
    self.scroller.hidden = YES;
    
    [self.view addSubview:self.pager];
    
    [self _scrollToIndex:self.initIndex];
    [self _downloadIfisOnlineURLAtIndex:self.initIndex];
    
}

- (void)_previewWithShowType {
    
    self.pager.hidden = YES;
    self.scroller.hidden = NO;
    self.scroller.scrollEnabled = NO;
    ETPhotoPreviewView *v = self.previews[self.currentPage];
    CGRect rect = [self.imageRects[self.currentPage] CGRectValue];
    CGRect convertRect = [self.scroller convertRect:rect fromView:[UIApplication sharedApplication].delegate.window];
    v.frame = convertRect;
    [v setImageViewCenterImageMode];
    void(^animateBlock)(void) = ^{
        self.backgroundView.alpha = 1;
        v.frame = CGRectMake(self.currentPage*self.scroller.width, 0, self.scroller.width, self.scroller.height);
        [v setImageViewFullScreenMode];
    };
    void(^completeBlock)(BOOL) =  ^(BOOL finished){
        self.scroller.scrollEnabled = YES;
        self.pager.hidden = NO;
        self.fullScreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    ETPhotoPreviewView *view = self.previews[self.currentPage];
    NSString *savePath;
    if ([view.sourceURL isFileURL]) {
        savePath = view.sourceURL.path;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath] && !CGRectEqualToRect(rect, CGRectZero)) {
        [UIView animateWithDuration:0.3f animations:animateBlock completion:completeBlock];
    } else {
        animateBlock();
        completeBlock(YES);
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.2f animations:^{
            self.backgroundView.alpha = 1;
        }];
    }
}

- (void)_previewWithPresentType {
    self.backgroundView.alpha = 1;
    self.pager.hidden = YES;
    self.scroller.hidden = NO;
    self.scroller.scrollEnabled = YES;
    ETPhotoPreviewView *v = self.previews[self.currentPage];
    v.frame = CGRectMake(self.currentPage*self.scroller.width, 0, self.scroller.width, self.scroller.height);
    [v setImageViewFullScreenMode];
}

- (void)_dismissFromShowType {
    self.scroller.scrollEnabled = NO;
    self.pager.hidden = YES;
    
    self.fullScreen = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    ETPhotoPreviewView *v = self.currentPage < self.previews.count ? self.previews[self.currentPage] : nil;
    [v setImageViewFullScreenMode];
    
    CGRect rect = self.currentPage < self.imageRects.count ? [self.imageRects[self.currentPage] CGRectValue] : CGRectZero;
    CGRect convertRect = [self.scroller convertRect:rect fromView:[UIApplication sharedApplication].delegate.window];
    
    void(^animateBlock)(void) = ^{
        v.frame = convertRect;
        [v setImageViewCenterImageMode];
        self.backgroundView.alpha = 0;
    };
    void(^completeBlock)(BOOL) = ^(BOOL finished) {
        UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootController.modalPresentationStyle = self.rootControlerModalPresentationStyle;
        
        [self dismissViewControllerAnimated:NO completion:^{
            self.scroller.scrollEnabled = YES;
            [self.view removeFromSuperview];
        }];
    };
    
    NSString *savePath;
    if ([v.sourceURL isFileURL]) {
        savePath = v.sourceURL.path;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath] && !CGRectEqualToRect(rect, CGRectZero)) {
        [UIView animateWithDuration:0.3f animations:animateBlock completion:completeBlock];
        [UIView animateWithDuration:0.05 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.scroller.alpha = 0;
        } completion:nil];
    } else {
        self.backgroundView.alpha = 1;
        [UIView animateWithDuration:0.1f animations:^{
            self.backgroundView.alpha = 0;
        } completion:completeBlock];
    }
}

- (void)_dismissFromPresentType {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)_setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self.navigationController setNavigationBarHidden:navigationBarHidden animated:YES];
}

- (void)_scrollToIndex:(NSInteger)index {
    self.scroller.contentOffset = CGPointMake(index*self.scroller.width, 0);
}

- (void)_downloadIfisOnlineURLAtIndex:(NSInteger)index {
    ETPhotoPreviewView *view = self.previews[index];
    [view downloadIfIsOnlineURL];
}

- (void)_didScrollToIndex:(NSUInteger)index {
    
    self.pager.currentPage = index;
    
    if (self.lastIndex < self.previews.count) {
        ETPhotoPreviewView *v = self.previews[self.lastIndex];
        [v setImageViewFullScreenMode];
    }
    
    self.lastIndex = index;
    
    [self _downloadIfisOnlineURLAtIndex:index];
    [self _refreshTitle];
}

- (void)_moreTap {
    ETPhotoPreviewView *view = self.previews[self.currentPage];
    if ([self.delegate respondsToSelector:@selector(photoPreviewController:didTapMoreWithView:completion:)]) {
        [self.delegate photoPreviewController:self didTapMoreWithView:view completion:^{
            [self _refreshTitle];
        }];
    }
}

#pragma mark ScaleView Delegate

- (void)scaleViewDidSingleOneTap:(ETScaleView *)scaleView {
    if (self.previewType == PreviewTypeShow) {
        [self dismiss];
    } else {
        self.fullScreen = !self.isFullScreen;
        [self _setNavigationBarHidden:self.isFullScreen];
    }
}

- (void)scaleViewDidLongPressed:(ETScaleView *)scaleView {
    [self _moreTap];
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.width <= 0) {
        return;
    }
    NSUInteger index = scrollView.contentOffset.x/scrollView.width;
    
    if (index == self.lastIndex) {
        return;
    }
    
    [self _didScrollToIndex:index];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.previews enumerateObjectsUsingBlock:^(ETPhotoPreviewView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.scrollEnabled = NO;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.previews enumerateObjectsUsingBlock:^(ETPhotoPreviewView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.scrollEnabled = YES;
    }];
}

#pragma mark - getter and setter

- (NSUInteger)currentPage {
    return self.pager.currentPage;
}

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scroller.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _scroller.delegate = self;
        _scroller.showsVerticalScrollIndicator = NO;
        _scroller.showsHorizontalScrollIndicator = NO;
        _scroller.pagingEnabled = YES;
    }
    return _scroller;
}

- (UIPageControl *)pager {
    if (!_pager) {
        _pager = [[UIPageControl alloc] initWithFrame:CGRectMake(20, self.view.height - 50, self.view.width - 20*2, 10)];
        _pager.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _pager.numberOfPages = self.previews.count;
        _pager.currentPage = self.initIndex;
        _pager.userInteractionEnabled = NO;
    }
    return _pager;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backgroundView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
