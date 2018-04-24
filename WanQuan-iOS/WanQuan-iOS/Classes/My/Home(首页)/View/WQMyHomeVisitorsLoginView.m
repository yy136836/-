//
//  WQMyHomeVisitorsLoginView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyHomeVisitorsLoginView.h"
#import "WQLogInController.h"

@implementation WQMyHomeVisitorsLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVisitorsLoginView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化游客登录
- (void)setupVisitorsLoginView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youkengdengluwode"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        //make.top.equalTo(self.mas_top).offset(60);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    UILabel *tagonc = [UILabel labelWithText:@"你在万圈的痕迹保存在这里" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagonc];
    [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [UIColor colorWithHex:0x901f87].CGColor;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn setTitleColor:[UIColor colorWithHex:0x901f87] forState:UIControlStateNormal];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tagonc.mas_bottom).offset(20);
        make.height.offset(36);
        make.width.offset(100);
    }];
    
    [loginBtn addClickAction:^(UIButton * _Nullable sender) {
        //WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:TouristLoginStatusHide];
        //WQlogonnNavViewController *navc = [[WQlogonnNavViewController alloc] initWithRootViewController:vc];
        //[self.viewController presentViewController:navc animated:YES completion:nil];
        if (self.loginBtnClickBlock) {
            self.loginBtnClickBlock();
        }
    }];
}

@end
