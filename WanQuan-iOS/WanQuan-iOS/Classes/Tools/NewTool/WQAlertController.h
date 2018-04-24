//
//  WQAlertController.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAlertController : UIAlertController


/**
 初始化弹框
 
 @param title 弹框的标题
 @param message 弹框的展示的信息
 @param style 0或者1;代表弹框的类型;UIAlertControllerStyleActionSheet = 0,UIAlertControllerStyleAlert = 1
 @param titleArray 弹框中出现的按钮标题的数组
 @param alertAction block回调事件
 */
+ (instancetype)initWQAlertControllerWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style titleArray:(NSArray *)titleArray alertAction:(void (^)(NSInteger index))alertAction;

/**
 展示弹框
 */
- (void)showWQAlert;



@end
