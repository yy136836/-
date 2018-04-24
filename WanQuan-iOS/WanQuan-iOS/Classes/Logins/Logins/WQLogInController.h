//
//  WQLogInController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/4.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TouristLoginStatus) {
    TouristLoginStatusNoHide = 0,   // 显示游客登录按钮
    TouristLoginStatusHide,         // 隐藏游客登录按钮
    login,
    regist,
};

@interface WQLogInController : UIViewController

- (instancetype)initWithTouristLoginStatus:(TouristLoginStatus)status;

@end
