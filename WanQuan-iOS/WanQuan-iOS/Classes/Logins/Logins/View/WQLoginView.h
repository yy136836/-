//
//  WQLoginView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLoginView;

@protocol WQLoginViewDelegate <NSObject>

/**
 忘记密码的响应事件

 @param loginView 
 */
- (void)wqForgotPasswordBtnClick:(WQLoginView *)loginView;

/**
 区号按钮的响应事件

 @param loginView 
 */
- (void)wqAreaCodeBtnClick:(WQLoginView *)loginView;

/**
 登录按钮的响应事件

 @param loginView self
 @param phoneString 手机号
 @param password 密码
 */
- (void)wqLoginBtnClick:(WQLoginView *)loginView phoneString:(NSString *)phoneString password:(NSString *)password;
@end

@interface WQLoginView : UIView

@property (nonatomic, weak) id <WQLoginViewDelegate> delegate;

/**
 区号的btn
 */
@property (nonatomic, strong) UIButton *areaCodeBtn;

@end
