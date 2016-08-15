# ETPhotoPreviewController
图片预览，查看

@interface ETPhotoPreviewController : UIViewController

@property (nonatomic, weak, nullable) id<ETPhotoPreviewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) NSUInteger currentPage;

/**
 * @param sourceURLs 图片资源URL，可为local url，也可为online url
 * @param destationURLs 图片下载到的位置，当为nil时，由内部指定默认路径
 * @param views 若以show方式打开，则是从这些views的位置弹出和关闭
 * @param index 初始化的图片index
 */
- (nullable instancetype)initWithSourceUrls:(nonnull NSArray<NSURL*> *)sourceURLs destationURLs:(nullable NSArray<NSURL*> *)destationURLs fromViews:(nullable NSArray<UIView*> *)views initIndex:(NSUInteger)index;

- (nullable instancetype)initWithSourceUrls:(nonnull NSArray<NSURL*> *)sourceURLs fromViews:(nullable NSArray<UIView*> *)views initIndex:(NSUInteger)index;

/**
 * show from views just like WeChat
 */
- (void)show;

/**
 * simply present from rootViewController
 */
- (void)present;
- (void)dismiss;

- (void)deletePhotoAtIndex:(NSUInteger)index;

@end

@protocol ETPhotoPreviewControllerDelegate <NSObject>

- (void)photoPreviewController:(nonnull ETPhotoPreviewController*)vc didTapMoreWithView:(nonnull ETPhotoPreviewView*)view completion:(nonnull void(^)())completion;

@end
