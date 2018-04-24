//
//  WQforgetPasswordViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BarBtnhind) {
    loginBarBtnhide = 0,   // 登录页面
    loginBarBtnNOhide,     // 设置页面
};

@interface WQforgetPasswordViewController : UIViewController

- (instancetype)initWithBarBtnhind:(BarBtnhind)barbtnhind;

@end
