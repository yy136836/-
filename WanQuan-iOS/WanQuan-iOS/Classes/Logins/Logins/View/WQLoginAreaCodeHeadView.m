//
//  WQLoginAreaCodeHeadView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLoginAreaCodeHeadView.h"

@implementation WQLoginAreaCodeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 标题
    UILabel *titleLabel = [UILabel labelWithText:@"选择国家/地区" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    // x号的按钮
    UIButton *shutDownBtn = [[UIButton alloc] init];
    [shutDownBtn setImage:[UIImage imageNamed:@"denglushanchu"] forState:UIControlStateNormal];
    [shutDownBtn addTarget:self action:@selector(shutDownBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shutDownBtn];
    [shutDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghDistanceershi));
    }];
}

#pragma mark -- x号按钮的响应事件
- (void)shutDownBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqShutDownBtnClick:)]) {
        [self.delegate wqShutDownBtnClick:self];
    }
}

@end
