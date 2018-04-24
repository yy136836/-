//
//  TZImagePickerController+WQCircleCrop.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>

/**
 定制的头像裁剪页面
 */
@interface TZImagePickerController (WQCircleCrop)

- (instancetype)WQinitCropTypeWithAsset:(id)asset photo:(UIImage *)photo completion:(void (^)(UIImage *cropImage,id asset))completion;

@end
