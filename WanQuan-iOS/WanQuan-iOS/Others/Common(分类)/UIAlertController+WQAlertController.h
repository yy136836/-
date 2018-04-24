//
//  UIAlertController+WQAlertController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (WQAlertController)

+ (instancetype)wqAlertWithController:(UIViewController *)vc addTitle:(NSString *)title andMessage:(NSString *)message andAnimated:(BOOL)animated andTime:(CGFloat)time;

@end
