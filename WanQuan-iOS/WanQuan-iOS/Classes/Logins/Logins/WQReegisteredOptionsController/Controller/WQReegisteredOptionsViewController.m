//
//  WQReegisteredOptionsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQReegisteredOptionsViewController.h"
#import "WQSocialScienceInformationViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface WQReegisteredOptionsViewController ()

@end

@implementation WQReegisteredOptionsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
//    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarMetricsDefault target:self action:@selector(backkk)];
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)backkk {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"rootvcdisms" object:nil];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registeredbeijing"]];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"以下哪种描述符合您的情况:" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:18];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kScaleX(166));
    }];
    
    // 第一个选项的按钮
    UIButton *oncOptionsBtn = [[UIButton alloc] init];
    oncOptionsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [oncOptionsBtn addTarget:self action:@selector(oncOptionsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [oncOptionsBtn setBackgroundImage:[UIImage imageNamed:@"zhucezhuanyebeijing"] forState:UIControlStateNormal];
    [oncOptionsBtn setTitle:@"我是清华MBA校友" forState:UIControlStateNormal];
    [oncOptionsBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.view addSubview:oncOptionsBtn];
    [oncOptionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(50)));
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(55));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 第二个选项的按钮
    UIButton *twoOptionsBtn = [[UIButton alloc] init];
    twoOptionsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [twoOptionsBtn addTarget:self action:@selector(twoOptionsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [twoOptionsBtn setBackgroundImage:[UIImage imageNamed:@"zhucezhuanyebeijing"] forState:UIControlStateNormal];
    [twoOptionsBtn setTitle:@"我是清华社科学院校友" forState:UIControlStateNormal];
    [twoOptionsBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.view addSubview:twoOptionsBtn];
    [twoOptionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(50)));
        make.top.equalTo(oncOptionsBtn.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 第三个选项
    UIButton *threeOptionsBtn = [[UIButton alloc] init];
    threeOptionsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [threeOptionsBtn addTarget:self action:@selector(threeOptionsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [threeOptionsBtn setBackgroundImage:[UIImage imageNamed:@"zhucezhuanyebeijing"] forState:UIControlStateNormal];
    [threeOptionsBtn setTitle:@"以上都不是" forState:UIControlStateNormal];
    [threeOptionsBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [self.view addSubview:threeOptionsBtn];
    [threeOptionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(50)));
        make.top.equalTo(twoOptionsBtn.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark -- MBA校友
- (void)oncOptionsBtnClick {
    WQSocialScienceInformationViewController *vc = [[WQSocialScienceInformationViewController alloc] init];
    vc.type = MBA;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 社科学院校友
- (void)twoOptionsBtnClick {
    WQSocialScienceInformationViewController *vc = [[WQSocialScienceInformationViewController alloc] init];
    vc.type = SocialScience;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 以上都不是的响应事件
- (void)threeOptionsBtnClick {
    WQSocialScienceInformationViewController *vc = [[WQSocialScienceInformationViewController alloc] init];
    vc.type = AreNot;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
