//
//  ViewController.m
//  ETPhotoPreviewController
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "ViewController.h"
#import "ETPhotoPreviewController.h"
#import "ETPhotoPreviewView.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ViewController () <ETPhotoPreviewControllerDelegate>

@property (nonatomic, strong) NSArray *thumbURLs;
@property (nonatomic, strong) NSArray *URLs;
@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.thumbURLs = @[[NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201605/apic20823_s.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201605/apic20610_s.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201605/apic20826_s.jpg"],
                       [NSURL URLWithString:@"http://pic.sc.chinaz.com/Files/pic/pic9/201608/apic22496_s.jpg"],
                       [NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201605/apic20862_s.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5493_s.jpg"],
                       [NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201607/apic21732_s.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5469_s.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5632_s.jpg"]
                        ];
    self.URLs = @[[NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201605/apic20823.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201605/apic20610.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201605/apic20826.jpg"],
                       [NSURL URLWithString:@"http://pic.sc.chinaz.com/Files/pic/pic9/201608/apic22496.jpg"],
                       [NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201605/apic20862.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5493.jpg"],
                       [NSURL URLWithString:@"http://pic1.sc.chinaz.com/Files/pic/pic9/201607/apic21732.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5469.jpg"],
                       [NSURL URLWithString:@"http://pic2.sc.chinaz.com/Files/pic/pic9/201607/fpic5632.jpg"]
                       ];
    CGFloat margen = 10;
    CGFloat width = 90;
    NSInteger number = 3;
    CGFloat offsetX = (self.view.width - width*number - margen*(number-1))/2;
    CGFloat offsetY = 50;
    
    self.views = [NSMutableArray new];
    
    [self.thumbURLs enumerateObjectsUsingBlock:^(NSURL*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width+margen)*(idx%number) + offsetX, (width+margen)*(idx/number) + offsetY, width, width)];
        [imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageFromColor:[UIColor grayColor]]];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.tag = idx;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show:)]];
        [self.view addSubview:imageView];
        [self.views addObject:imageView];
    }];
}

- (void)show:(UIGestureRecognizer*)gesture {
    
    ETPhotoPreviewController *v = [[ETPhotoPreviewController alloc] initWithSourceUrls:self.URLs fromViews:self.views initIndex:gesture.view.tag];
    v.delegate = self;
//    [v present];
    [v show];
}

- (void)photoPreviewController:(ETPhotoPreviewController *)vc didTapMoreWithView:(ETPhotoPreviewView *)view completion:(void (^)())completion {
    NSString *savePath;
    if (![view.sourceURL isFileURL]) {
        return;
    }
    savePath = view.sourceURL.path;
    
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    RIButtonItem *download = [RIButtonItem itemWithLabel:@"下载图片" action:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:savePath isDirectory:nil]) {
            UIImage *image = [UIImage imageWithContentsOfFile:savePath];
            [image saveToAlbumWithMetadata:nil customAlbumName:@"MyPorject" completionBlock:^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"保存成功";
                [hud hide:YES afterDelay:1.2f];
                
            } failureBlock:^(NSError *error) {
                RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"确定"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"需要访问您的照片" message:@"请启用照片-设置/隐私/照片" cancelButtonItem:cancel otherButtonItems:nil];
                [alert show];
            }];
        }
    }];
    RIButtonItem *delete = [RIButtonItem itemWithLabel:@"删除图片" action:^{
        [vc deletePhotoAtIndex:vc.currentPage];
        completion();
    }];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancel destructiveButtonItem:nil otherButtonItems:download, delete, nil];
    [sheet showInView:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
