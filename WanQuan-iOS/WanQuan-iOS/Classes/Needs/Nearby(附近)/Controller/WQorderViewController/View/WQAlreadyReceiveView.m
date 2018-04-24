//
//  WQAlreadyReceiveView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAlreadyReceiveView.h"

@interface WQAlreadyReceiveView ()

@end

@implementation WQAlreadyReceiveView {
    UILabel *moneyLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAlreadyReceiveView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark - 初始化红包
- (void)setupAlreadyReceiveView {
    UIImageView *redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kaihogbao"]];
    redImageView.userInteractionEnabled = YES;
    [self addSubview:redImageView];
    [redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    moneyLabel = [UILabel labelWithText:@"111" andTextColor:[UIColor colorWithHex:0xf8e71c] andFontSize:30];
    [self addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(redImageView.mas_bottom).offset(-48);
    }];
    
    UIButton *shutDownBtn = [[UIButton alloc] init];
    [shutDownBtn addTarget:self action:@selector(shutDownBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [shutDownBtn setTitle:@"" forState:UIControlStateNormal];
    [redImageView addSubview:shutDownBtn];
    [shutDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redImageView.mas_top).offset(25);
        make.right.equalTo(redImageView.mas_right).offset(-25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)setMoneyString:(NSString *)moneyString {
    _moneyString = moneyString.copy;

    moneyLabel.text = [moneyString.copy stringByAppendingString:@"元"];
}

#pragma mark - 关闭按钮的响应事件
- (void)shutDownBtnClike {
    if ([self.delegate respondsToSelector:@selector(shutDownBtnClikeWQAlreadyReceiveView:)]) {
        [self.delegate shutDownBtnClikeWQAlreadyReceiveView:self];
    }
}

@end
