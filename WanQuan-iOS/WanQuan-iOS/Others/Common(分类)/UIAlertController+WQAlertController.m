//
//  UIAlertController+WQAlertController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UIAlertController+WQAlertController.h"

@implementation UIAlertController (WQAlertController)

+ (instancetype)wqAlertWithController:(UIViewController *)vc addTitle:(NSString *)title andMessage:(NSString *)message andAnimated:(BOOL)animated andTime:(CGFloat)time {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [vc presentViewController:alertVC animated:animated completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    return alertVC;
}

@end
