//
//  WQLogInController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/4.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>
#import "WQLogInController.h"
#import "WQlogonnNavViewController.h"
#import "WQlogonnRootViewController.h"
#import "WQTabBarController.h"
#import "WQloginModel.h"
#import "WQSingleton.h"
#import "WQforgetPasswordViewController.h"
#import "WQNavigationController.h"
#import "JPUSHService.h"
#import "WQRegisteredViewController.h"

#import "WQRegisteredView.h"
#import "WQLoginView.h"
#import "WQRealNameInformationViewController.h"
#import "WQLoginAreaCodeView.h"
#import "WQReegisteredOptionsViewController.h"
#import "WQAddBasicInformationViewController.h"
#import "WQTextInputView.h"
#import "WQAddressBookFriendsViewController.h"
#import "WQPhoneBookFriendsViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define TAG_ANIMAT_VIEW 10000

@interface WQLogInController () <UITextFieldDelegate,WQRegisteredViewDelegate,WQLoginViewDelegate,WQLoginAreaCodeViewDelegate>

/**
 登录底部的横线
 */
@property (nonatomic, strong) UIView *loginPurpleView;

/**
 枚举状态
 */
@property (nonatomic, assign) TouristLoginStatus status;

/**
 注册的view
 */
@property (nonatomic, strong) WQRegisteredView *registeredView;

/**
 登录的view
 */
@property (nonatomic, strong) WQLoginView *loginView;

/**
 区号的view
 */
@property (nonatomic, strong) WQLoginAreaCodeView *loginAreaCodeView;
@end

@implementation WQLogInController

- (instancetype)initWithTouristLoginStatus:(TouristLoginStatus)status {
    if (self = [super init]) {
        self.status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];

    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听通知
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // do something...
}


- (void)keyboardWillHide:(NSNotification *)notification {
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [animationDurationValue getValue:&animationDuration];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WQLogInController"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarbtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarbtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WQLogInController"];
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registeredbeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backgroundImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundImageViewClick)];
    [backgroundImageView addGestureRecognizer:backgroundImageViewTap];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    backgroundImageView.tag = TAG_ANIMAT_VIEW + 1;
    
    // 欢迎来到万圈
    UILabel *tagLabel = [UILabel labelWithText:@"欢 迎 来 到 万 圈" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:30];
    tagLabel.font = [UIFont fontWithName:@".PingFangSC-Thin" size:30];
    [backgroundImageView addSubview:tagLabel];
    // 5的话字体为26
    if (iPhone5) {
        tagLabel.font = [UIFont systemFontOfSize:26];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view).offset(kScaleX(40));
        }];
    }else {
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view).offset(kScaleX(112));
        }];
    }
    
    // 注册按钮
    UIButton *registeredBnt = [UIButton setNormalTitle:@"注 册" andNormalColor:[UIColor colorWithHex:0x999999] andFont:20];
    registeredBnt.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:20];
    [backgroundImageView addSubview:registeredBnt];
    [registeredBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(kScaleY(-37));
        make.top.equalTo(tagLabel.mas_bottom).offset(kScaleX(45));
    }];
    registeredBnt.tag = TAG_ANIMAT_VIEW;
    
    // 登录的按钮
    UIButton *loginBtn = [UIButton setNormalTitle:@"登 录" andNormalColor:[UIColor colorWithHex:0x333333] andFont:20];
    loginBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:20];
    [backgroundImageView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(kScaleY(37));
        make.top.equalTo(registeredBnt.mas_top);
    }];
    loginBtn.tag = TAG_ANIMAT_VIEW;
    
    // 注册底部的横线
    UIView *registeredPurpleView = [[UIView alloc] init];
    registeredPurpleView.hidden = YES;
    registeredPurpleView.backgroundColor = [UIColor colorWithRed:151/255.0 green:103/255.0 blue:208/255.0 alpha:1/1.0];
    [backgroundImageView addSubview:registeredPurpleView];
    [registeredPurpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 3));
        make.centerX.equalTo(registeredBnt.mas_centerX);
        make.top.equalTo(registeredBnt.mas_bottom).offset(5);
    }];
    
    _registeredView.tag = TAG_ANIMAT_VIEW;
    
    // 登录底部的横线
    UIView *loginPurpleView = [[UIView alloc] init];
    self.loginPurpleView = loginPurpleView;
    loginPurpleView.backgroundColor = [UIColor colorWithRed:151/255.0 green:103/255.0 blue:208/255.0 alpha:1/1.0];
    [backgroundImageView addSubview:loginPurpleView];
    [loginPurpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 3));
        make.centerX.equalTo(loginBtn.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).offset(5);
    }];
    
    loginBtn.tag = TAG_ANIMAT_VIEW;
    
    // 游客登录按钮下的三角
    UIButton *visitorsLoginTriangleBtn = [[UIButton alloc] init];
    [visitorsLoginTriangleBtn setImage:[UIImage imageNamed:@"denglujiantouxia"] forState:UIControlStateNormal];
    [visitorsLoginTriangleBtn addTarget:self action:@selector(visitorsLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:visitorsLoginTriangleBtn];
    [visitorsLoginTriangleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-ghSpacingOfshiwu);
    }];
    
    // 游客登录的按钮
    UIButton *visitorsLoginBtn = [[UIButton alloc] init];
    visitorsLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [visitorsLoginBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [visitorsLoginBtn addTarget:self action:@selector(visitorsLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [visitorsLoginBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.view addSubview:visitorsLoginBtn];
    [visitorsLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(visitorsLoginTriangleBtn.mas_top).offset(kScaleX(5));
    }];
    
    // 注册的view
    WQRegisteredView *registeredView = [[WQRegisteredView alloc] init];
    self.registeredView = registeredView;
    registeredView.delegate = self;
    registeredView.hidden = YES;
    [self.view addSubview:registeredView];
    [registeredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginPurpleView.mas_bottom).offset(58);
        make.left.right.equalTo(backgroundImageView);
        make.bottom.equalTo(visitorsLoginBtn.mas_top).offset(-ghStatusCellMargin);
    }];
    
    // 登录的view
    WQLoginView *loginView = [[WQLoginView alloc] init];
    loginView.delegate = self;
    self.loginView = loginView;
    loginView.hidden = NO;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginPurpleView.mas_bottom).offset(58);
        make.left.right.equalTo(backgroundImageView);
        make.bottom.equalTo(visitorsLoginBtn.mas_top).offset(-ghStatusCellMargin);
    }];
    
    // 区号的view
    WQLoginAreaCodeView *loginAreaCodeView = [[WQLoginAreaCodeView alloc] init];
    loginAreaCodeView.delagate = self;
    loginAreaCodeView.hidden = YES;
    self.loginAreaCodeView = loginAreaCodeView;
    [self.view addSubview:loginAreaCodeView];
    [loginAreaCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 显示注册
    if (self.status == regist) {
        // 隐藏登录按钮底部的紫色view和登录控件的view改变登录按钮颜色
        loginView.hidden = YES;
        loginPurpleView.hidden = YES;
        [loginBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        // 显示注册按钮底部的紫色view和注册控件的view改变注册按钮颜色
        registeredView.hidden = NO;
        registeredPurpleView.hidden = NO;
        [registeredBnt setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }else {
        // 显示登录
        // 显示登录按钮底部的紫色view和注册控件的view改变登录按钮颜色
        loginView.hidden = NO;
        loginPurpleView.hidden = NO;
        [loginBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        // 隐藏注册按钮底部的紫色view和登录控件的view改变注册按钮颜色
        registeredView.hidden = YES;
        registeredPurpleView.hidden = YES;
        [registeredBnt setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }
    
    __weak typeof(registeredBnt) weakRegisteredBnt = registeredBnt;
    // 注册按钮的点击事件
    [registeredBnt addClickAction:^(UIButton * _Nullable sender) {
        // 隐藏登录按钮底部的紫色view和登录控件的view改变登录按钮颜色
        loginView.hidden = YES;
        loginPurpleView.hidden = YES;
        [loginBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        // 显示注册按钮底部的紫色view和注册控件的view改变注册按钮颜色
        registeredView.hidden = NO;
        registeredPurpleView.hidden = NO;
        [weakRegisteredBnt setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }];
    
    __weak typeof(loginBtn) weakLoginBtn = loginBtn;
    // 登录的按钮的点击事件
    [loginBtn addClickAction:^(UIButton * _Nullable sender) {
        // 显示登录按钮底部的紫色view和注册控件的view改变登录按钮颜色
        loginView.hidden = NO;
        loginPurpleView.hidden = NO;
        [weakLoginBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        // 隐藏注册按钮底部的紫色view和登录控件的view改变注册按钮颜色
        registeredView.hidden = YES;
        registeredPurpleView.hidden = YES;
        [registeredBnt setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }];
}

#pragma mark -- 区号的选择  WQLoginAreaCodeViewDelegate
- (void)wqDidSelectRowAtIndexPath:(WQLoginAreaCodeView *)loginAreaCodeView areaCode:(NSString *)areaCodeString {
    // 选择完区号 隐藏区号view
    loginAreaCodeView.hidden = YES;
}

#pragma mark -- 游客登录
- (void)visitorsLoginBtnClick {
    NSString *urlString = @"api/user/loginguest";
    NSMutableDictionary *touristLoginParams = [NSMutableDictionary dictionary];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:touristLoginParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
        [userDefaults setObject:response[@"im_namelogin"] forKey:@"im_namelogin"];
        [userDefaults setObject:response[@"im_password"] forKey:@"im_password"];
        [userDefaults setObject:response[@"role_id"] forKey:@"role_id"];
        NSLog(@"%@",[userDefaults objectForKey:@"role_id"]);
        [WQDataSource sharedTool].join_alumnus_group_success = YES;
        WQTabBarController *tabBarVc= [[WQTabBarController alloc] init];
        [self presentViewController:tabBarVc animated:NO completion:nil];
        if (self.view.window == nil) {
            UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            window.rootViewController = tabBarVc;
            [window makeKeyAndVisible];
        }
    }];
}

#pragma mark -- WQRegisteredViewDelegate
// 获取验证码
- (void)wqRegisterVerificationCodeBtnClick:(WQRegisteredView *)registeredView phoneString:(NSString *)phoneString {
    NSString *urlString = @"api/user/sendregistersmscode";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = [registeredView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL success = [response [@"success"] boolValue];
        if (success == YES) {
            [self.registeredView.verificationCodeBtn setTitle:@"正在获取..." forState:UIControlStateNormal];
            self.registeredView.verificationCodeBtn.enabled = NO;
            [self.registeredView.verificationCodeBtn statWithTimeout:60 eventhandler:^(NSInteger timeout) {
                if(timeout <= 0){ //倒计时结束，关闭
                    // 设置界面的按钮显示 根据自己需求设置
                    [self.registeredView.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.registeredView.verificationCodeBtn.enabled = YES;
                }else{
                    // 设置界面的按钮显示 根据自己需求设置
                    [self.registeredView.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒重试",(long)timeout] forState:UIControlStateNormal];
                }
            }];
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
    }];
}

// 注册按钮的响应事件
- (void)wqRegisteredBtnClick:(WQRegisteredView *)registeredView phoneString:(NSString *)phoneString verificationCodeString:(NSString *)verificationCodeString passwordString:(NSString *)passwordString inviteCodeString:(NSString *)inviteCodeString {
    if (![phoneString isVisibleString]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (![passwordString isVisibleString]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    NSString *urlString = @"api/user/register2/s1register";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = [self.loginView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString];
    params[@"smscode"] = verificationCodeString;
    params[@"password"] = [passwordString md5String];
    params[@"invite_code"] = inviteCodeString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response [@"success"] boolValue]) {
            NSString* appDomain = [[NSBundle mainBundle]bundleIdentifier];
            [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];

            [WQDataSource sharedTool].cellphone = [self.loginView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString];
            [WQDataSource sharedTool].password = [passwordString md5String];
            // 注册成功
            [WQDataSource sharedTool].secretkey = response[@"secretkey"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];

            [self loadBasicInfo:response[@"secretkey"]];
            // 没有邀请码
            if (![inviteCodeString isVisibleString]) {
                WQReegisteredOptionsViewController *vc = [[WQReegisteredOptionsViewController alloc] init];
                WQlogonnNavViewController *nav = [[WQlogonnNavViewController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                WQAddBasicInformationViewController *vc = [[WQAddBasicInformationViewController alloc] init];
                vc.isInviteCode = YES;
                WQlogonnNavViewController *nav = [[WQlogonnNavViewController alloc]initWithRootViewController:vc];
                //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];

            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
        }
    }];
}

// 区号按钮的响应事件
- (void)wqRegisteredViewAreaCodeBtnClick:(WQRegisteredView *)registeredView {
    self.loginAreaCodeView.hidden = NO;
}


//#pragma mark -- WQLoginViewDelegate
//- (void)tryLogin:(EMError **)e {
//    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
//    NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_password"];
//    *e = [[EMClient sharedClient] loginWithUsername:userName
//                                           password:passWord];
//    if (!*e) {
//        [EMClient sharedClient].options.isAutoLogin = YES;
//    }
//}
//
//- (void)checkLoginStatusAndLogin {
//    if ([EMClient sharedClient].isLoggedIn) {
//        dispatch_async(dispatch_get_global_queue(0, 999), ^{
//
//            EMError * e = [[EMError alloc] init];
//            while (e) {
//                e = [[EMClient sharedClient] logout:YES];
//            }
//            e = [[EMError alloc] init];
//            while (e) {
//                [self tryLogin:&e];
//            }
//
//        });
//    } else {
//        dispatch_async(dispatch_get_global_queue(0, 1999), ^{
//            EMError * e = [[EMError alloc] init];
//            while (e) {
//                [self tryLogin:&e];
//            }
//        });
//    }
//}

// 登录按钮的响应事件
- (void)wqLoginBtnClick:(WQLoginView *)loginView phoneString:(NSString *)phoneString password:(NSString *)password {
    [self.view endEditing:YES];

    NSString *urlString = @"api/user/login";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"登录中…"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = [self.loginView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString];
    params[@"password"] = [password md5String];
    params[@"version"] = @"1";
    params[@"device"] = @"iOS";
    [WQDataSource sharedTool].cellphone = [self.loginView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString];
    [WQDataSource sharedTool].password = [password md5String];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(1 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [alertVC dismissViewControllerAnimated:YES completion:nil];
                               });
            }];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);

        
        if (response[@"success"]) {
            

            BOOL successbool = [response[@"success"] boolValue];
            if (successbool) {
                
                NSString *im_namelogin = response[@"im_namelogin"];
                NSString *im_password = response[@"im_password"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [JPUSHService setAlias:im_namelogin
                          callbackSelector:nil
                                    object:nil];
                });
                
                [SVProgressHUD dismissWithDelay:0.1];
                WQloginModel *model = [WQloginModel new];
                model.access_token = response[@"secretkey"];
                NSString *secretkey = response[@"secretkey"];
                [self loadBasicInfo:secretkey];
                [WQSingleton sharedManager].userIMId = im_namelogin;
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[self.loginView.areaCodeBtn.titleLabel.text stringByAppendingString:phoneString] forKey:@"phoneString"];
                [userDefaults setObject:[password md5String] forKey:@"password"];
                [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
                [WQDataSource sharedTool].secretkey = response[@"secretkey"] ;
                [WQDataSource sharedTool].join_alumnus_group_success = YES;
                [userDefaults setObject:response[@"im_namelogin"] forKey:@"im_namelogin"];
                [userDefaults setObject:response[@"im_password"] forKey:@"im_password"];
                [userDefaults setObject:response[@"role_id"] forKey:@"role_id"];
                
//                [WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
                // 转换为可识别的时间
                NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[response[@"expiredtime"] doubleValue] / 1000];
                model.expiredtime = timeDate;
                [[WQSingleton sharedManager]saveAccount:model];
                WQTabBarController *vc = [WQTabBarController new];
                
                [[EaseSDKHelper shareHelper] logOutForced:YES shouldReLogin:YES];

                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            } else {
                [SVProgressHUD dismiss];
                
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC
                                   animated:YES completion:^{
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                                    (int64_t)(1 * NSEC_PER_SEC)),
                                                      dispatch_get_main_queue(), ^{
                                                          [alertVC dismissViewControllerAnimated:YES completion:nil];
                                                      });
                                   }];
                return;
            }
        }
    }];
}
// 区号按钮的响应事件
- (void)wqAreaCodeBtnClick:(WQLoginView *)loginView {
    [self.view endEditing:YES];
    self.loginAreaCodeView.hidden = NO;
}
// 忘记密码的响应事件
- (void)wqForgotPasswordBtnClick:(WQLoginView *)loginView {
    WQforgetPasswordViewController *vc = [[WQforgetPasswordViewController alloc] initWithBarBtnhind:loginBarBtnhide];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    vc.navigationItem.leftBarButtonItem = leftBarItem;
    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    WQNavigationController *nav = [[WQNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadBasicInfo:(NSString *)secretKey {
    NSString *urlString = @"api/user/getbasicinfo";
    //NSDictionary *dict = @{@"secretkey":secretKey};
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"secretkey"] = secretKey;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        
        NSLog(@"%@",response);
        WQUserProfileModel *model = [WQUserProfileModel yy_modelWithJSON:response];
        
        [WQDataSource sharedTool].loginStatus = response[@"idcard_status"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:model.true_name forKey:@"true_name"];
        [userDefaults setObject:model.pic_truename forKey:@"pic_truename"];
        [userDefaults setObject:model.flower_name forKey:@"flower_name"];
        [userDefaults setObject:model.pic_flowername forKey:@"pic_flowername"];
        [userDefaults synchronize];
    }];
}

#pragma mark -- 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 背景图的响应事件
- (void)backgroundImageViewClick {
    [self.view endEditing:YES];
}

@end
