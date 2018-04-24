//
//  WQLoadingError.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/25.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQLoadingError.h"

@implementation WQLoadingError

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

#pragma mark -- 初始化游客登录
- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wangluojiazaishibai"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(94);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *label = [UILabel labelWithText:@"内容获取失败" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:label];
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
    
    
    // 点击重试的按钮
    UIButton *clickRetryBtn = [[UIButton alloc] init];
    clickRetryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    clickRetryBtn.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    clickRetryBtn.layer.cornerRadius = 5;
    clickRetryBtn.layer.masksToBounds = YES;
    [clickRetryBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    [clickRetryBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    clickRetryBtn.layer.borderColor = [UIColor colorWithHex:0x9767d0].CGColor;
    clickRetryBtn.layer.borderWidth = 1.0f;
    [self addSubview:clickRetryBtn];
    [clickRetryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 36));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(ghDistanceershi);
    }];
    
    __weak typeof(self) weakself = self;
    [clickRetryBtn addClickAction:^(UIButton * _Nullable sender) {
        if (weakself.clickRetryBtnClickBlock) {
            weakself.clickRetryBtnClickBlock();
        }
    }];
}

- (void)dismiss {
    self.hidden = YES;
}

- (void)show {
    self.hidden = NO;
}

@end
