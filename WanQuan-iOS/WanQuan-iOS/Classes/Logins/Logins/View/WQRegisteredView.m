//
//  WQRegisteredView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRegisteredView.h"

@interface WQRegisteredView () 

@end

@implementation WQRegisteredView {
    // 手机号输入框
    UITextField *phoneTextField;
    // 验证码
    UITextField *verificationCodeTextField;
    // 设置密码
    UITextField *passwordTextField;
    // 邀请码
    UITextField *inviteCodeTextField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqdidSelectAreaCodeClick:) name:WQdidSelectAreaCodeClick object:nil];
    }
    return self;
}

- (void)wqdidSelectAreaCodeClick:(NSNotification *)noti {
    [self.areaCodeBtn setTitle:[[@"+" stringByAppendingString:[NSString stringWithFormat:@"%@",noti.userInfo[@"code"]]] stringByAppendingString:@""] forState:UIControlStateNormal];
}

#pragma mark - 初始化View
- (void)setupView {
    // 手机号的输入框
    phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"输入手机号";
    phoneTextField.userInteractionEnabled = YES;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX).offset(-kScaleY(20));
        make.left.equalTo(self).offset(kScaleY(120));
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
    }];
    
    // 区号的按钮
    UIButton *areaCodeBtn = [UIButton setNormalTitle:@"+86" andNormalColor: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] andFont:0];
    self.areaCodeBtn = areaCodeBtn;
    areaCodeBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:15];
    [areaCodeBtn addTarget:self action:@selector(areaCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:areaCodeBtn];
    [areaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneTextField.mas_centerY);
        make.right.equalTo(phoneTextField.mas_left).offset(-20);
    }];
    
    // 区号后的三角
    UIButton *triangleBtn = [[UIButton alloc] init];
    [triangleBtn addTarget:self action:@selector(areaCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [triangleBtn setImage:[UIImage imageNamed:@"dengluxiangxiajiantou"] forState:UIControlStateNormal];
    [self addSubview:triangleBtn];
    [triangleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(areaCodeBtn.mas_centerY);
        make.left.equalTo(areaCodeBtn.mas_right);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.left.equalTo(areaCodeBtn.mas_left);
        make.top.equalTo(phoneTextField.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 验证码
    verificationCodeTextField = [[UITextField alloc] init];
    verificationCodeTextField = [[UITextField alloc] init];
    verificationCodeTextField.placeholder = @"输入验证码";
    verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verificationCodeTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:verificationCodeTextField];
    [verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.right.equalTo(lineView);
    }];
    
    // 获取验证码
    UIButton *verificationCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 33)];
    self.verificationCodeBtn = verificationCodeBtn;
    [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [verificationCodeBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [verificationCodeBtn addTarget:self action:@selector(verificationCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    verificationCodeTextField.rightView = verificationCodeBtn;
    verificationCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 获取验证码下的分割线
    UIView *twolineView = [[UIView alloc] init];
    twolineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:twolineView];
    [twolineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.left.equalTo(areaCodeBtn.mas_left);
        make.top.equalTo(verificationCodeTextField.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 邀请码
    inviteCodeTextField = [[UITextField alloc] init];
    inviteCodeTextField.placeholder = @"邀请码 (选填)";
    inviteCodeTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:inviteCodeTextField];
    [inviteCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView);
        make.top.equalTo(twolineView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 邀请码下的线
    UIView *inviteCodeBottomLine = [[UIView alloc] init];
    inviteCodeBottomLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:inviteCodeBottomLine];
    [inviteCodeBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.left.equalTo(areaCodeBtn.mas_left);
        make.top.equalTo(inviteCodeTextField.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 设置密码
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"设置密码";
    passwordTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView);
        make.top.equalTo(inviteCodeBottomLine.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 眼睛
    UIButton *eyesBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluweixianshimima"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluxianshimima"] forState:UIControlStateSelected];
    [eyesBtn addTarget:self action:@selector(eyesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    passwordTextField.rightView = eyesBtn;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 最底部的分割线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.left.equalTo(areaCodeBtn.mas_left);
        make.top.equalTo(passwordTextField.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 注册的按钮
    UIButton *registeredBtn = [UIButton setNormalTitle:@"下一步" andNormalColor:[UIColor whiteColor] andFont:20];
    registeredBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    registeredBtn.layer.cornerRadius = 5;
    registeredBtn.layer.masksToBounds = YES;
    [registeredBtn addTarget:self action:@selector(registeredBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registeredBtn];
    [registeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom).offset(kScaleX(42));
        make.left.right.equalTo(lineView);
        make.height.offset(45);
    }];
}

#pragma mark -- 注册按钮的响应事件
- (void)registeredBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqRegisteredBtnClick:phoneString:verificationCodeString:passwordString:inviteCodeString:)]) {
        [self.delegate wqRegisteredBtnClick:self phoneString:phoneTextField.text verificationCodeString:verificationCodeTextField.text passwordString:passwordTextField.text inviteCodeString:inviteCodeTextField.text];
    }
}

#pragma mark -- 区号按钮的响应事件
- (void)areaCodeBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqRegisteredViewAreaCodeBtnClick:)]) {
        [self.delegate wqRegisteredViewAreaCodeBtnClick:self];
    }
}

#pragma mark -- 获取验证码
- (void)verificationCodeBtnClick {
    
    if ([[phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入有效的手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(wqRegisterVerificationCodeBtnClick:phoneString:)]) {
        [self.delegate wqRegisterVerificationCodeBtnClick:self phoneString:phoneTextField.text];
    }
}

#pragma mark -- 眼睛的点击事件
- (void)eyesBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (passwordTextField.secureTextEntry == NO) {
        passwordTextField.secureTextEntry = YES;
        passwordTextField.text = passwordTextField.text;
    }else {
        passwordTextField.secureTextEntry = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [passwordTextField endEditing:YES];
    [phoneTextField endEditing:YES];
    [verificationCodeTextField endEditing:YES];
    [inviteCodeTextField endEditing:YES];
}

#pragma 正则表达式
//判断手机号
- (BOOL)valiMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
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
