//
//  TZImagePickerController+WQCircleCrop.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "TZImagePickerController+WQCircleCrop.h"
#import "WQPhotoPreviewController.h"


@implementation TZImagePickerController (WQCircleCrop)
- (instancetype)WQinitCropTypeWithAsset:(id)asset photo:(UIImage *)photo completion:(void (^)(UIImage *cropImage,id asset))completion {
    TZPhotoPreviewController *previewVc = [[WQPhotoPreviewController alloc] init];
    TZImagePickerController * picker;
    picker = [super initWithRootViewController:previewVc];
    if (picker) {
        picker.maxImagesCount = 1;
        picker.allowCrop = YES;
        picker.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
        [picker configDefaultSetting];
        
        previewVc.photos = [NSMutableArray arrayWithArray:@[photo]];
        previewVc.isCropImage = YES;
        previewVc.currentIndex = 0;
        __weak typeof(self) weakSelf = self;
        [previewVc setDoneButtonClickBlockCropMode:^(UIImage *cropImage, id asset) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (completion) {
                    completion(cropImage,asset);
                }
            }];
        }];
    }
    return picker;
}



- (void)configDefaultSetting {
    self.timeout = 15;
    self.photoWidth = 828.0;
    self.photoPreviewMaxWidth = 600;
    self.naviTitleColor = [UIColor whiteColor];
    self.naviTitleFont = [UIFont systemFontOfSize:17];
    self.barItemTextFont = [UIFont systemFontOfSize:15];
    self.barItemTextColor = [UIColor whiteColor];
    self.allowPreview = YES;
    
    [self configDefaultImageName];
    [self configDefaultBtnTitle];
    
    CGFloat cropViewWH = kScreenWidth;
    self.cropRect = CGRectMake(0, (kScreenHeight - cropViewWH) / 2, cropViewWH, cropViewWH);
}

- (void)configDefaultImageName {
    self.takePictureImageName = @"takePicture";
    self.photoSelImageName = @"photo_sel_photoPickerVc";
    self.photoDefImageName = @"photo_def_photoPickerVc";
    self.photoNumberIconImageName = @"photo_number_icon";
    self.photoPreviewOriginDefImageName = @"preview_original_def";
    self.photoOriginDefImageName = @"photo_original_def";
    self.photoOriginSelImageName = @"photo_original_sel";
}

- (void)configDefaultBtnTitle {
    self.doneBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Done"];
    self.cancelBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Cancel"];
    self.previewBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Preview"];
    self.fullImageBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Full image"];
    self.settingBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Setting"];
    self.processHintStr = [NSBundle tz_localizedStringForKey:@"Processing..."];
}


@end
