//
//  WQQuickRegistrationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQQuickRegistrationViewController.h"
#import "NSString+WQSMScountdown.h"

@interface WQQuickRegistrationViewController ()
@property (nonatomic, strong) UITextField *passwordTextFiled; // 密码
@property (nonatomic, strong) UITextField *phoneTextField;    // 手机号
@property (nonatomic, strong) UIButton *toObtain;             // 获取验证码
@property (nonatomic, strong) UILabel *numberLabel;           // 注册数量
@property (nonatomic, strong) UITextField *verificationCodeTextField; // 验证码

@property (nonatomic, retain) UILabel * hasBeenRegisteredLabel;
@end

@implementation WQQuickRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    [self setUpView];
    [self loadData];
}

- (void)setUpView {
    // 手机号
    UITextField *phoneTextField = [[UITextField alloc] init];
    self.phoneTextField = phoneTextField;
    [phoneTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    phoneTextField.placeholder = @" 手机号";
    phoneTextField.textColor = [UIColor colorWithHex:0X8d8d8d];
    phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    phoneTextField.layer.borderWidth = 1.0f;
    phoneTextField.layer.cornerRadius = 5;
    phoneTextField.layer.masksToBounds = YES;
    phoneTextField.layer.borderColor = [UIColor colorWithHex:0Xdcdcdc].CGColor;
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ghStatusCellMargin);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(ghCellHeight);
    }];
    
    // 验证码
    UITextField *verificationCodeTextField = [[UITextField alloc] init];
    self.verificationCodeTextField = verificationCodeTextField;
    [verificationCodeTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    verificationCodeTextField.placeholder = @" 验证码";
    verificationCodeTextField.textColor = [UIColor colorWithHex:0X8d8d8d];
    verificationCodeTextField.clearButtonMode = UITextFieldViewModeAlways;
    verificationCodeTextField.layer.borderWidth = 1.0f;
    verificationCodeTextField.layer.cornerRadius = 5;
    verificationCodeTextField.layer.masksToBounds = YES;
    verificationCodeTextField.layer.borderColor = [UIColor colorWithHex:0Xdcdcdc].CGColor;
    verificationCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:verificationCodeTextField];
    
    // 获取验证码
    UIButton *toObtain = [[UIButton alloc] init];
    self.toObtain = toObtain;
    toObtain.backgroundColor = [UIColor whiteColor];
    toObtain.layer.borderWidth = 1.0f;
    toObtain.layer.cornerRadius = 5;
    toObtain.layer.masksToBounds = YES;
    toObtain.titleLabel.font = [UIFont systemFontOfSize:13];
    toObtain.layer.borderColor = [UIColor colorWithHex:0x5d2a89].CGColor;
    [toObtain setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    [toObtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [toObtain addTarget:self action:@selector(toObtainBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toObtain];
    [toObtain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationCodeTextField.mas_right).offset(ghStatusCellMargin);
        make.height.equalTo(verificationCodeTextField.mas_height);
        make.right.equalTo(phoneTextField.mas_right);
        make.top.equalTo(phoneTextField.mas_bottom).offset(ghStatusCellMargin);
        make.width.offset(85);
    }];
    
    [verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(ghStatusCellMargin);
        make.left.height.equalTo(phoneTextField);
    }];
    
    // 登录密码
    UITextField *passwordTextFiled = [[UITextField alloc] init];
    [passwordTextFiled setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.passwordTextFiled = passwordTextFiled;
    passwordTextFiled.placeholder = @" 设置登录密码";
    passwordTextFiled.textColor = [UIColor colorWithHex:0X8d8d8d];
    passwordTextFiled.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextFiled.layer.borderWidth = 1.0f;
    passwordTextFiled.layer.cornerRadius = 5;
    passwordTextFiled.layer.masksToBounds = YES;
    passwordTextFiled.secureTextEntry = YES;
    passwordTextFiled.layer.borderColor = [UIColor colorWithHex:0Xdcdcdc].CGColor;
    passwordTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:passwordTextFiled];
    [passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(phoneTextField);
        make.top.equalTo(verificationCodeTextField.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 显示密码
    UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [showBtn setImage:[UIImage imageNamed:@"xianshimima"] forState:UIControlStateNormal];
    passwordTextFiled.rightView = showBtn;
    passwordTextFiled.rightViewMode = UITextFieldViewModeAlways;
    [showBtn addTarget:self action:@selector(showBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    // 快速注册的按钮
    UIButton *quickRegistration = [[UIButton alloc] init];
    quickRegistration.backgroundColor = [UIColor colorWithHex:0x5d2a89];
    quickRegistration.titleLabel.font = [UIFont systemFontOfSize:18];
    quickRegistration.layer.borderWidth = 1.0f;
    quickRegistration.layer.cornerRadius = 5;
    quickRegistration.layer.masksToBounds = YES;
    [quickRegistration setTitle:@"快速注册" forState:UIControlStateNormal];
    [quickRegistration addTarget:self action:@selector(quickRegistrationClike) forControlEvents:UIControlEventTouchUpInside];
    [quickRegistration setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [self.view addSubview:quickRegistration];
    [quickRegistration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(passwordTextFiled);
        make.top.equalTo(passwordTextFiled.mas_bottom).offset(60);
    }];
    
    // 提示
    UILabel *promptLabel = [UILabel labelWithText:@"提示:建议您进行实名注册,获得更多的使用权限;实名用户之间完全信任,获得更好的使用体验,更高的信用分数" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:11];
    promptLabel.numberOfLines = 0;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quickRegistration.mas_left).offset(5);
        make.right.equalTo(quickRegistration.mas_right).offset(-5);
        make.top.equalTo(quickRegistration.mas_bottom).offset(15);
    }];
    
    // 多少人已经注册
    _hasBeenRegisteredLabel = [UILabel labelWithText:@"名清华校友已实名认证" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.view addSubview:_hasBeenRegisteredLabel];
    [_hasBeenRegisteredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(quickRegistration.mas_bottom).offset(95);
    }];
    
    UILabel *numberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5d2a89] andFontSize:30];
    self.numberLabel = numberLabel;
    [self.view addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_hasBeenRegisteredLabel.mas_bottom).offset(5);
        make.right.equalTo(_hasBeenRegisteredLabel.mas_left).offset(1);
    }];
}

// 显示密码的点击事件
- (void)showBtnClike {
    if (self.passwordTextFiled.secureTextEntry == NO) {
        self.passwordTextFiled.secureTextEntry = YES;
        self.passwordTextFiled.text = self.passwordTextFiled.text;
    }else {
        self.passwordTextFiled.secureTextEntry = NO;
    }
}

// 获取注册人数
- (void)loadData {
    NSString *urlString = @"api/system/init";
    NSDictionary *params = [[NSDictionary alloc] init];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
            
            
            
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"user_count"]]
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x5d2a89]}]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"名清华校友已实名注册"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithHex:0x111111]}]];
            
            
            self.hasBeenRegisteredLabel.attributedText = str;
            self.hasBeenRegisteredLabel.center =  CGPointMake(self.view.centerX, self.hasBeenRegisteredLabel.centerY);

        }
    }];
}

// 获取验证码
- (void)toObtainBtnClike {
    if (![self valiMobile:self.phoneTextField.text]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入有效的手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    NSString *urlString = @"api/user/sendregistersmscode";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.phoneTextField.text;
    //params[@"cellphone"] = @"15738017516";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
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
            [self.toObtain setTitle:@"正在获取..." forState:UIControlStateNormal];
            self.toObtain.enabled = NO;
            [self.toObtain statWithTimeout:60 eventhandler:^(NSInteger timeout) {
                if(timeout <= 0){ //倒计时结束，关闭
                    //设置界面的按钮显示 根据自己需求设置
                    [self.toObtain setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.toObtain.enabled = YES;
                }else{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.toObtain setTitle:[NSString stringWithFormat:@"%ld秒重试",(long)timeout] forState:UIControlStateNormal];
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

// 快速注册
- (void)quickRegistrationClike {
    NSString *urlString = @"api/user/registerquick";
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"cellphone"] = self.phoneTextField.text;
    params[@"smscode"] = self.verificationCodeTextField.text;
    params[@"password"] = [self.passwordTextFiled.text md5String];
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
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"注册成功请登录" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return;
            
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

#pragma 正则表达式
//判断手机号
- (BOOL)valiMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

@end
