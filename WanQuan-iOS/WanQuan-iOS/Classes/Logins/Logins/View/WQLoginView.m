//
//  WQLoginView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginView.h"

@implementation WQLoginView {
    // 密码的输入框
    UITextField *passwordTextField;
    // 手机号的输入框
    UITextField *phoneTextField;
    // 区号的按钮
    UIButton *areaCodeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqdidSelectAreaCodeClick:) name:WQdidSelectAreaCodeClick object:nil];
    }
    return self;
}

- (void)wqdidSelectAreaCodeClick:(NSNotification *)noti {
    [areaCodeBtn setTitle:[[@"+" stringByAppendingString:[NSString stringWithFormat:@"%@",noti.userInfo[@"code"]]] stringByAppendingString:@""] forState:UIControlStateNormal];
}

#pragma mark - 初始化View
- (void)setupView {
    // 手机号的输入框
    phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"输入手机号";
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.userInteractionEnabled = YES;
    phoneTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(-kScaleY(20));
        make.left.equalTo(self).offset(kScaleY(120));
        make.right.equalTo(self.mas_right).offset(kScaleY(-65));
        make.height.equalTo(@40);
    }];
    
    // 区号的按钮
    areaCodeBtn = [UIButton setNormalTitle:@"+86" andNormalColor: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0] andFont:0];
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
        make.top.equalTo(phoneTextField.mas_bottom);
    }];
    
    // 密码的输入框
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"输入密码";
    passwordTextField.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
    [self addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(lineView);
        make.height.equalTo(@40);
        
    }];
    
    // 底部分割线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView);
        make.height.offset(0.5);
        make.top.equalTo(passwordTextField.mas_bottom);
    }];
    
    // 眼睛
    UIButton *eyesBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluweixianshimima"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluxianshimima"] forState:UIControlStateSelected];
    [eyesBtn addTarget:self action:@selector(eyesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    passwordTextField.rightView = eyesBtn;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 登录按钮
    UIButton *loginBtn = [UIButton setNormalTitle:@"登录" andNormalColor:[UIColor whiteColor] andFont:20];
    loginBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineView.mas_bottom).offset(kScaleX(42));
        make.left.right.equalTo(lineView);
        make.height.offset(45);
    }];
    
    // 忘记密码
    UIButton *forgotPassword = [UIButton setNormalTitle:@"忘记密码" andNormalColor:[UIColor colorWithHex:0x333333] andFont:15];
    [forgotPassword addTarget:self action:@selector(forgotPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgotPassword];
    [forgotPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(loginBtn.mas_right);
    }];
}

#pragma mark -- 忘记密码的响应事件
- (void)forgotPasswordClick {
    if ([self.delegate respondsToSelector:@selector(wqForgotPasswordBtnClick:)]) {
        [self.delegate wqForgotPasswordBtnClick:self];
    }
}

#pragma mark -- 区号按钮的响应事件
- (void)areaCodeBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqAreaCodeBtnClick:)]) {
        [self.delegate wqAreaCodeBtnClick:self];
    }
}

#pragma mark -- 登录的按钮
- (void)loginBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqLoginBtnClick:phoneString:password:)]) {
        
        if (![phoneTextField.text isVisibleString]) {
            [WQAlert showAlertWithTitle:nil message:@"请检查您的手机号" duration:1];
            return;
        }
        
        if (![passwordTextField.text isVisibleString]) {
            [WQAlert showAlertWithTitle:nil message:@"请检查您的密码" duration:1];
            return;
        }
        
        [self.delegate wqLoginBtnClick:self phoneString:phoneTextField.text password:passwordTextField.text];
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
}

@end
