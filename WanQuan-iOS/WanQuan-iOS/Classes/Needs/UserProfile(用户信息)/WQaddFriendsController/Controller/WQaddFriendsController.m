//
//  WQaddFriendsController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQaddFriendsController.h"

@interface WQaddFriendsController () <UITextViewDelegate>

@property (nonatomic, copy) NSString *huanxinId;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *verificationInformationLabel;
@property (nonatomic, strong) UIImageView *writingTwoImageView;

@end

@implementation WQaddFriendsController

- (instancetype)initWithIMId:(NSString *)imId {
    if (self = [super init]) {
        self.huanxinId = imId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
    
    
    
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    
    // 输入内容
    [self.view addSubview:self.textView];
    // 提示标签
    [self.view addSubview:self.verificationInformationLabel];
    // 书写图标
    [_textView addSubview:self.writingTwoImageView];
    
    [_verificationInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ghStatusCellMargin);
//        if ([self.type isEqualToString:@"加入圈"]) {
            make.top.equalTo(@(64 + 15));
//        }else {
//            make.top.equalTo(self.view).offset(15);
//        }
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verificationInformationLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.offset(kScreenHeight / 3);
    }];
//    [_textView setPlaceholder:@""];
    
//    [_textView setValue:@",最长不超过50个字" forKey:@"placeholder"];
    
    [self.writingTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(_textView.mas_left).offset(ghStatusCellMargin);
        make.top.equalTo(_textView.mas_top).offset(ghStatusCellMargin);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = [self.type isEqualToString:@"加入圈"]? @"加入圈":self.type;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepBtnClike)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    
    if (changedString.length != 0) {
        self.writingTwoImageView.hidden = YES;
    }else{
        self.writingTwoImageView.hidden = NO;
    }
    
    return YES;
}

#pragma mark - BarBtn监听事件
- (void)nextStepBtnClike {
//    EMError *error = [[EMClient sharedClient].contactManager addContact:self.huanxinId message:self.textView.text];
//    api/friend/applyfriend
//    uid false string
//    message false string
    
    if (self.textView.text.length > 50) {
        
        [WQAlert showAlertWithTitle:nil message:@"验证信息不应超过50字" duration:1];
        return;
    }
//
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tip = [NSString stringWithFormat:@"你好！我是%@",[userDefaults objectForKey:@"true_name"]];
    NSString * secreteKey = [userDefaults objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }

    if ([self.type isEqualToString:@"加入圈"]) {
        NSString *urlString = @"api/group/applyjoingroup";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = secreteKey;
        params[@"gid"] = self.gid;
        params[@"message"] = self.textView.text.length ? self.textView.text : tip;
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
    
            if ([response[@"success"] boolValue]) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"申请已发送，请等候圈主批准" preferredStyle:UIAlertControllerStyleAlert];
    
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
                return ;
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                return ;
            }
        }];
    }else {//加好友
        NSString * strURL = @"api/friend/applyfriend";
        
        NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
        param[@"uid"] = self.huanxinId;
        param[@"message"] = self.textView.text.isVisibleString ? self.textView.text :tip;
        
        WQNetworkTools *tools = [WQNetworkTools sharedTools];
        [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
            if (error) {
                return ;
            }
            
            if ([response[@"success"] boolValue]) {
                
                [WQAlert showAlertWithTitle:nil message:@"已发送添加申请" duration:1.3];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } else {
                [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
            }
        }];
        
    }

    
    
    
//    if (!error) {
//        [self showHint:@"发送请求成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if (error) {
//        NSLog(@"%@", error.errorDescription);
//        [self showHint:@"发送失败"];
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView endEditing:YES];
}

#pragma mark - 懒加载
- (UIImageView *)writingTwoImageView {
    if (!_writingTwoImageView) {
        _writingTwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
    }
    return _writingTwoImageView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.placeholder = @"        请在此输入验证内容(50个字以内)";
        _textView.placeholderColor = [UIColor colorWithHex:0x999999];
        _textView.delegate = self;
        _textView.layer.borderWidth= 1.0f;
        _textView.layer.borderColor= [UIColor colorWithHex:0Xececec].CGColor;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

- (UILabel *)verificationInformationLabel {
    
    if (!_verificationInformationLabel) {
        _verificationInformationLabel = [UILabel labelWithText: [_type isEqualToString:@"加入圈"]? @"你需要发送验证信息,等待对方通过" : @"你需要发送验证信息,等待圈主通过" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
        if ([self.type isEqualToString:@"添加好友"]) {
            _verificationInformationLabel.text = @"你需要发送验证信息,等待对方通过";
        }else if ([self.type isEqualToString:@"加入圈"]) {
            _verificationInformationLabel.text = @"你需要发送验证信息,等待圈主通过";
        }
    }
    return _verificationInformationLabel;
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
