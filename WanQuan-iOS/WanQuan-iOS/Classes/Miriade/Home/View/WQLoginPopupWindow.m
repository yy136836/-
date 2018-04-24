//
//  WQLoginPopupWindow.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginPopupWindow.h"

@implementation WQLoginPopupWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLoginPopupWindowView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
    }
    return self;
}

#pragma mark -- 初始化弹窗
- (void)setupLoginPopupWindowView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginPopupWindowView"]];
    self.imageView = imageView;
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    //imageView.layer.cornerRadius = 0;
    //imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(0);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    //[loginBtn setTitle:@"loginBtn" forState:UIControlStateNormal];
    //[loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(imageView.mas_centerX);
        make.height.offset(36);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    
    UIButton *registeredBtn = [[UIButton alloc] init];
    //[registeredBtn setTitle:@"registeredBtn" forState:UIControlStateNormal];
    //[registeredBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registeredBtn addTarget:self action:@selector(registeredBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registeredBtn];
    [registeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.height.offset(36);
        make.left.equalTo(imageView.mas_centerX);
    }];
    
    // 弹窗上边的透明Btn  点击隐藏弹框
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(translucentAreaClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_top);
        make.left.right.top.equalTo(self);
    }];
}

// 半透明区域的点击
- (void)translucentAreaClick {
    if ([self.delegate respondsToSelector:@selector(wqTranslucentAreaClick:)]) {
        [self.delegate wqTranslucentAreaClick:self];
    }
}
// 登录的响应事件
- (void)loginBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqLoginBtnClick:)]) {
        [self.delegate wqLoginBtnClick:self];
    }
}
// 注册的响应事件
- (void)registeredBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqRegisteredBtnClick:)]) {
        [self.delegate wqRegisteredBtnClick:self];
    }
}

@end
