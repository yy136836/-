//
//  WQVisitorsToLoginPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQVisitorsToLoginPopupWindowView.h"

@implementation WQVisitorsToLoginPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wanquanshengjitanchuang"]];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    // 退出登录
    UIButton *logOutBtn = [[UIButton alloc] init];
    logOutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    logOutBtn.backgroundColor = [UIColor whiteColor];
    logOutBtn.layer.cornerRadius = 5;
    logOutBtn.layer.masksToBounds = YES;
    logOutBtn.layer.borderWidth = 1.0f;
    logOutBtn.layer.borderColor = [UIColor colorWithHex:0x7fb0f1].CGColor;
    [logOutBtn setTitleColor:[UIColor colorWithHex:0x7fb0f1] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn setTitle:@"退出登录,作为游客登录" forState:UIControlStateNormal];
    [self addSubview:logOutBtn];
    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(190), kScaleX(42)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(backgroundImageView.mas_bottom).offset(kScaleX(-24));
    }];
    
    // 补充信息
    UIButton *supplementaryInformationBtn = [[UIButton alloc] init];
    supplementaryInformationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    supplementaryInformationBtn.backgroundColor = [UIColor colorWithHex:0x7fb0f1];
    supplementaryInformationBtn.layer.cornerRadius = 5;
    supplementaryInformationBtn.layer.masksToBounds = YES;
    [supplementaryInformationBtn setTitle:@"补充基本信息" forState:UIControlStateNormal];
    [supplementaryInformationBtn addTarget:self action:@selector(supplementaryInformationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [supplementaryInformationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:supplementaryInformationBtn];
    [supplementaryInformationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(190), kScaleX(42)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(logOutBtn.mas_top).offset(kScaleX(-ghDistanceershi));
    }];
}

#pragma mark -- 退出登录的响应事件
- (void)logOutBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqLogOutBtnClick:)]) {
        [self.delegate wqLogOutBtnClick:self];
    }
}

#pragma mark -- 补充信息的响应事件
- (void)supplementaryInformationBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSupplementaryInformationBtnClick:)]) {
        [self.delegate wqSupplementaryInformationBtnClick:self];
    }
}

@end
