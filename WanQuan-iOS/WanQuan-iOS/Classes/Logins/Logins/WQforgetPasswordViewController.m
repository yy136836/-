//
//  WQforgetPasswordViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQforgetPasswordViewController.h"
#import "NSString+WQSMScountdown.h"
#import "WQLineView.h"

#define gHspacing 16

@interface WQforgetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) BarBtnhind barbtnhind;
@property (nonatomic, copy) NSString *cellphoneString;
@end

@implementation WQforgetPasswordViewController {
    // 手机号输入框
    UITextField *phoneTextField;
    // 验证码输入框
    UITextField *getVerificationCodeTextField;
    // 新密码
    UITextField *passwordTextField;
    // 获取验证码
    UIButton *verificationCodeBtn;
}

- (instancetype)initWithBarBtnhind:(BarBtnhind)barbtnhind {
    if (self = [super init]) {
        self.barbtnhind = barbtnhind;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    self.navigationItem.title = @"重置密码";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    // 登录页面过来的 显示取消
    if (self.barbtnhind == loginBarBtnhide) {
        //UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
        //self.navigationItem.leftBarButtonItem = leftBarItem;
        //UIBarButtonItem *apperance = [UIBarButtonItem appearance];
        //uitextattributetextcolor替代方法
        //[apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
        
        
    }else {
        //        UIBarButtonItem *leftBarbtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector()];
        //        self.navigationItem.leftBarButtonItem = leftBarbtn;
        //        self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor blackColor]];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 取消的响应事件
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.cellphoneString = [[NSString alloc] init];
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 白色的背景view
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(167));
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.right.left.equalTo(self.view);
    }];
    
    // 手机号输入框
    phoneTextField = [[UITextField alloc] init];
    phoneTextField.delegate = self;
    [self.view addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(55));
        make.top.equalTo(backgroundView.mas_top);
        make.left.equalTo(self.view).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.view).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 手机号的标签
    UILabel *phoneLabel = [UILabel labelWithText:@"手机号:" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    phoneLabel.frame = CGRectMake(0, 0, kScaleY(65), kScaleX(18));
    phoneTextField.leftView = phoneLabel;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;

    // 分割线
    WQLineView *lineView = [[WQLineView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.view);
        make.height.offset(0.5);
        make.top.equalTo(phoneTextField.mas_bottom);
    }];
    
    // 验证码输入框
    getVerificationCodeTextField = [[UITextField alloc] init];
    [self.view addSubview:getVerificationCodeTextField];
    [getVerificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(phoneTextField);
        make.height.offset(kScaleX(55));
    }];

    // 获取验证码
    verificationCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 33)];
    [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [verificationCodeBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [verificationCodeBtn addTarget:self action:@selector(gainBntClike) forControlEvents:UIControlEventTouchUpInside];
    getVerificationCodeTextField.rightView = verificationCodeBtn;
    getVerificationCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 验证码标签
    UILabel *getVerificationCodeLabel = [UILabel labelWithText:@"验证码:" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    getVerificationCodeLabel.frame = CGRectMake(0, 0, kScaleY(65), kScaleX(18));
    getVerificationCodeTextField.leftView = getVerificationCodeLabel;
    getVerificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 分割线
    WQLineView *twolineView = [[WQLineView alloc] init];
    [self.view addSubview:twolineView];
    [twolineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.view);
        make.height.offset(0.5);
        make.top.equalTo(getVerificationCodeTextField.mas_bottom);
    }];
    
    // 新密码输入框
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.secureTextEntry = YES;
    [self.view addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twolineView.mas_bottom);
        make.left.right.equalTo(phoneTextField);
        make.height.offset(kScaleX(55));
    }];
    
    // 眼睛
    UIButton *eyesBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluweixianshimima"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"dengluxianshimima"] forState:UIControlStateSelected];
    [eyesBtn addTarget:self action:@selector(eyesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    passwordTextField.rightView = eyesBtn;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 新密码标签
    UILabel *passwordLabel = [UILabel labelWithText:@"新密码:" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    passwordLabel.frame = CGRectMake(0, 0, kScaleY(65), kScaleX(18));
    passwordTextField.leftView = passwordLabel;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 保存
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    saveBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kScaleX(45));
        make.left.equalTo(self.view).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.view).offset(kScaleY(-ghSpacingOfshiwu));
        make.top.equalTo(backgroundView.mas_bottom).offset(kScaleX(50));
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [phoneTextField endEditing:YES];
    [passwordTextField endEditing:YES];
    [getVerificationCodeTextField endEditing:YES];
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

#pragma mark - 获取验证码的响应事件
- (void)gainBntClike {
    if (![self valiMobile:phoneTextField.text]) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入有效的手机号" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    [getVerificationCodeTextField becomeFirstResponder];
    
    NSString *urlString = @"api/user/sendrstpwdsmscode";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cellphone"] = phoneTextField.text;
    self.cellphoneString = phoneTextField.text;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL success = [response [@"success"] boolValue];
        if (success == YES) {
            [verificationCodeBtn setTitle:@"正在获取..." forState:UIControlStateNormal];
            verificationCodeBtn.enabled = NO;
            [verificationCodeBtn statWithTimeout:60 eventhandler:^(NSInteger timeout) {
                if(timeout <= 0){
                    [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    verificationCodeBtn.enabled = YES;
                }else{
                    [verificationCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒重试",(long)timeout] forState:UIControlStateNormal];
                }
            }];
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

#pragma mark -- 保存按钮的点击事件
- (void)saveBtnClike {
    if (![phoneTextField.text isEqualToString:self.cellphoneString]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (passwordTextField.text.length < 6) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入至少6位密码" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    NSString *urlString = @"api/user/rstpwd";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cellphone"] = phoneTextField.text;
    params[@"password"] = [passwordTextField.text md5String];
    params[@"smscode"] = getVerificationCodeTextField.text;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL success = [response [@"success"] boolValue];
        if (success) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"密码重置成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

#pragma mark - TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == phoneTextField) {
        if (phoneTextField.text.length > 11) {
            [phoneTextField endEditing:YES];
            return YES;
        }
    }
    return YES;
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
