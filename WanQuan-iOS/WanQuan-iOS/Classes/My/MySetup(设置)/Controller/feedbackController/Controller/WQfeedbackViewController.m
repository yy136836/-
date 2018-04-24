//
//  WQfeedbackViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQfeedbackViewController.h"
#import "WQfeedbackView.h"
#import "WQTextField.h"
#import "WQFeedbackBottomView.h"

@interface WQfeedbackViewController () <WQFeedbackBottomViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) WQfeedbackView *feedbackView;
@end

@implementation WQfeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 代理置空，否则会崩
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // 只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.feedbackView.titleTextField endEditing:YES];
    [self.feedbackView.feedbackTextView endEditing:YES];
}

#pragma make - 初始化UI
- (void)setupUI {
    WQfeedbackView *feedbackView = [[WQfeedbackView alloc]init];
    self.feedbackView = feedbackView;
    [self.view addSubview:feedbackView];
    [feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(51.5 + kScreenHeight / 3);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    WQFeedbackBottomView *bottomView = [[WQFeedbackBottomView alloc] init];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.offset(kScaleX(76));
    }];
}

#pragma mark -- WQFeedbackBottomViewDelegate
- (void)wqSubmitBtnClick:(WQFeedbackBottomView *)bottomView {
    [self feedbackBtnClike];
}

#pragma mark -- 监听事件
- (void)feedbackBtnClike {
    [self.feedbackView.titleTextField endEditing:YES];
    [self.feedbackView.feedbackTextView endEditing:YES];
    if([[self.feedbackView.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入标题" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        
        return;
    }
    
    if([[self.feedbackView.feedbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        
        return;
    }
    
    NSString *urlString = @"api/advice/createadvice";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"content"] = self.feedbackView.feedbackTextView.text;
    params[@"title"] = self.feedbackView.titleTextField.text;
    NSString *type;
    if (self.feedbackType == TYPE_NEED) {
        type = @"TYPE_NEED";
    }
    if (self.feedbackType == TYPE_MOMENT) {
        type = @"TYPE_MOMENT";
    }
    if (self.feedbackType == TYPE_ADVICE) {
        type = @"TYPE_ADVICE";
    }
    if (self.feedbackType == TYPE_GROUP_TOPIC) {
        type = @"TYPE_GROUP_TOPIC";
    }
    if (self.feedbackType == TYPE_CHOICEST_ARTICLE) {
        type = @"TYPE_CHOICEST_ARTICLE";
    }
    params[@"type"] = type;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"%@",response);
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        if ([response[@"success"] boolValue]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示~" message:@"已经有人工跟进您的反馈，万圈力争做得更好！" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
    }];
}

@end
