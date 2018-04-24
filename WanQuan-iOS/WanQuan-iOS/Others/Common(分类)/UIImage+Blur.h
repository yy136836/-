//
//  UIImage+Blur.h
//  gh_load
//
//  Created by André gh_load on 10.07.14.
//  Copyright (c) 2014 André gh_load. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)


/**
 高斯模糊一张图片,但算法有问题边上会留白

 @return 处理过的图片
 */
- (UIImage *)blur;


/**
 接近

 @return UIVisualEffectView效果的模糊效果,如果需要加黑请自行添加蒙版
 */
- (UIImage *)GPUImageBlur;
@end
