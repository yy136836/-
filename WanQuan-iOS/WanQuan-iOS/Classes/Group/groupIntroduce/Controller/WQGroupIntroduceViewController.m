//
//  WQGroupIntroduceViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupIntroduceViewController.h"

@interface WQGroupIntroduceViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *writingTwoImageView;
@property (nonatomic, strong) UITextView *introduceTextView;
@property (nonatomic, strong) UIBarButtonItem *saveBtn;

@end

@implementation WQGroupIntroduceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"圈介绍";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnCliek)];
    [saveBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
    self.saveBtn = saveBtn;
    saveBtn.enabled = YES;
    self.navigationItem.rightBarButtonItem = saveBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 群介绍的输入框
    UITextView *introduceTextView = [[UITextView alloc] init];
    introduceTextView.font = [UIFont systemFontOfSize:15];
    self.introduceTextView = introduceTextView;
    introduceTextView.delegate = self;
    introduceTextView.placeholder = @"       快快来介绍一下此群,让更多的人了解并加入,结识更多的伙伴~";
    introduceTextView.text = self.content;
    introduceTextView.placeholderColor = [UIColor colorWithHex:0x999999];
    [self.view addSubview:introduceTextView];
    [introduceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.offset(kScreenHeight / 2);
    }];
    
    
    // TextView的输入图标
    UIImageView *writingTwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
    self.writingTwoImageView = writingTwoImageView;
    [introduceTextView addSubview:writingTwoImageView];
    [writingTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(introduceTextView.mas_left).offset(6);
        make.top.equalTo(introduceTextView.mas_top).offset(7);
    }];
    if (introduceTextView.text.length != 0) {
        writingTwoImageView.hidden = YES;
    }else{
        writingTwoImageView.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.introduceTextView resignFirstResponder];
}

// 保存按钮的响应事件
- (void)saveBtnCliek {
    self.saveBtn.enabled = NO;
    if (self.introduceTextView.text.length > 256) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈介绍请控制在256个字符以内" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                self.saveBtn.enabled = YES;
            });
        }];
        return;
    }
    
    NSString *urlString = @"api/group/updategroup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = self.gid;
    params[@"description"] = self.introduceTextView.text;
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
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"圈介绍修改成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    self.saveBtn.enabled = YES;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
        }
    }];
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

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
