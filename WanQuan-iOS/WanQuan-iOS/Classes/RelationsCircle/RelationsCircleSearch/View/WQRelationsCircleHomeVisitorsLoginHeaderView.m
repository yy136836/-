//
//  WQRelationsCircleHomeVisitorsLoginHeaderView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRelationsCircleHomeVisitorsLoginHeaderView.h"

@implementation WQRelationsCircleHomeVisitorsLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHeaderView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化HeaderView
- (void)setupHeaderView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaruquanzi"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(25);
    }];
    
    UILabel *oncLabel = [UILabel labelWithText:@"浏览好友动态" andTextColor:[UIColor colorWithHex:0xb46fb0] andFontSize:14];
    [self addSubview:oncLabel];
    [oncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.right.equalTo(self.mas_right).offset(-48);
    }];
    
    UILabel *twoLabel = [UILabel labelWithText:@"加入感兴趣的圈子" andTextColor:[UIColor colorWithHex:0xb46fb0] andFontSize:14];
    [self addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oncLabel.mas_centerX);
        make.top.equalTo(oncLabel.mas_bottom).offset(5);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(ghStatusCellMargin);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [loginBtn setTitle:@"立即登录>" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithHex:0x4f73b7] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oncLabel.mas_centerX);
        make.bottom.equalTo(lineView.mas_top).offset(-10);
    }];
}

- (void)loginBtnClick {
    if (self.loginBtnClickBlock) {
        self.loginBtnClickBlock();
    }
}

@end
