//
//  WQRegisteredView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQRegisteredView;

@protocol WQRegisteredViewDelegate <NSObject>

/**
 获取验证码的响应事件

 @param registeredView self
 @param phoneString 手机号
 */
- (void)wqRegisterVerificationCodeBtnClick:(WQRegisteredView *)registeredView phoneString:(NSString *)phoneString;

/**
 区号按钮的响应事件

 @param registeredView 
 */
- (void)wqRegisteredViewAreaCodeBtnClick:(WQRegisteredView *)registeredView;

/**
 注册按钮的响应事件
 
 @param registeredView self
 @param phoneString 手机号
 @param verificationCodeString 验证码
 @param passwordString 密码
 @param inviteCodeString 邀请码
 */
- (void)wqRegisteredBtnClick:(WQRegisteredView *)registeredView phoneString:(NSString *)phoneString verificationCodeString:(NSString *)verificationCodeString passwordString:(NSString *)passwordString inviteCodeString:(NSString *)inviteCodeString;
@end

@interface WQRegisteredView : UIView

@property (nonatomic, weak) id <WQRegisteredViewDelegate> delegate;

/**
 获取验证码
 */
@property (nonatomic, strong) UIButton *verificationCodeBtn;

/**
 区号的按钮
 */
@property (nonatomic, strong) UIButton *areaCodeBtn;

@end
