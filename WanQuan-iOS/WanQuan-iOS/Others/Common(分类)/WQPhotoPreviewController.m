//
//  WQPhotoPreviewController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhotoPreviewController.h"
#import <objc/runtime.h>
#import <TZImagePickerController/TZImageCropManager.h>
#import <TZImagePickerController/TZImagePickerController.h>
//#import "TZPhotoPreviewView.h"


@interface WQPhotoPreviewController ()
@property (nonatomic, retain) UIView * cropView;
@property (nonatomic, retain) UIView * cropBgView;

@end

@implementation WQPhotoPreviewController {
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configCropView {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    //    if (!_tzImagePickerVc.showSelectBtn && _tzImagePickerVc.allowCrop) {
    [_cropView removeFromSuperview];
    [_cropBgView removeFromSuperview];
    
    _cropBgView = [UIView new];
    _cropBgView.userInteractionEnabled = NO;
    _cropBgView.frame = self.view.bounds;
    _cropBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cropBgView];
    [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:_tzImagePickerVc.cropRect containerView:self.view needCircleCrop:_tzImagePickerVc.needCircleCrop];
    
    _cropView = [UIImageView new];
    [(UIImageView *)_cropView setImage:[UIImage imageNamed:@"ImagePickerBG"]];
     _cropView.userInteractionEnabled = NO;
     _cropView.frame = _tzImagePickerVc.cropRect;
     _cropView.backgroundColor = [UIColor clearColor];
//     _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
//     _cropView.layer.borderWidth = 1.0;
     if (_tzImagePickerVc.needCircleCrop) {
         _cropView.layer.cornerRadius = _tzImagePickerVc.cropRect.size.width / 2;
         _cropView.clipsToBounds = YES;
     }
    [self.view addSubview:_cropView];
    if (_tzImagePickerVc.cropViewSettingBlock) {
        _tzImagePickerVc.cropViewSettingBlock(_cropView);
    }
    
    for (UIView * view in self.view.subviews) {
        if (view.frame.origin.y  > kScreenWidth) {
            [self.view bringSubviewToFront:view];
        }
    }
    UIView * view1 = [self valueForKey:@"_toolBar"];
    [self.view bringSubviewToFront:view1];

}






@end
