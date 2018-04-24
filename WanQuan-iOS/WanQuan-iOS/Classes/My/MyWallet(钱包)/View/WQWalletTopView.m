//
//  WQWalletTopView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQWalletTopView.h"

@interface WQWalletTopView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *LineView;
@property (nonatomic, strong) UILabel *accountBalanceTextLabel;
@property (nonatomic, strong) UILabel *freezeFundsTextLabel;
@end

@implementation WQWalletTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:0];
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.headPortraitImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.LineView];
    [self addSubview:self.accountBalanceLabel];
    [self addSubview:self.accountBalanceTextLabel];
    [self addSubview:self.freezeFundsTextLabel];
    [self addSubview:self.freezeFundsLabel];
    
    // 背景图
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.offset(kScaleX(286));
    }];
    
    // 头像
    [_headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_backgroundImageView.mas_top).offset(kScaleX(90));
        make.size.mas_equalTo(CGSizeMake(kScaleY(70), kScaleX(70)));
    }];
    
    // 用户名
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headPortraitImageView.mas_centerX);
        make.top.equalTo(_headPortraitImageView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 账户余额和冻结金额中间的线
    [_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userNameLabel.mas_centerX);
        make.bottom.equalTo(self).offset(kScaleX(-23));
        make.size.mas_equalTo(CGSizeMake(0.5, kScaleX(30)));
    }];
    
    // 账户余额的字
    [_accountBalanceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScaleY(58));
        make.bottom.equalTo(self.mas_bottom).offset(kScaleX(-ghDistanceershi));
    }];
    
    // 账户余额金额
    [_accountBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_accountBalanceTextLabel.mas_centerX);
        make.bottom.equalTo(_accountBalanceTextLabel.mas_top).offset(kScaleX(-ghStatusCellMargin));
    }];
    
    // 冻结金额的字
    [_freezeFundsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleY(-58));
        make.bottom.equalTo(_accountBalanceTextLabel.mas_bottom);
    }];
    
    // 冻结金额金额
    [_freezeFundsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_freezeFundsTextLabel.mas_centerX);
        make.bottom.equalTo(_freezeFundsTextLabel.mas_top).offset(kScaleX(-ghStatusCellMargin));
    }];
    
    // 问号的按钮
    UIButton *questionMarkBtn = [[UIButton alloc] init];
    [questionMarkBtn addTarget:self action:@selector(questionMarkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [questionMarkBtn setImage:[UIImage imageNamed:@"dongjiejine"] forState:UIControlStateNormal];
    [self addSubview:questionMarkBtn];
    [questionMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.freezeFundsTextLabel.mas_right).offset(kScaleY(5));
        make.centerY.equalTo(self.freezeFundsTextLabel.mas_centerY);
    }];
}

#pragma mark -- 问号的响应事件
- (void)questionMarkBtnClick {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"冻结金额说明" message:@"正在发布中或进行中的需求金额将会被冻结，暂时不能使用或提现，直至需求完成支付给接需求者、或需求取消返还到万圈钱包。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

#pragma mark -- 懒加载
- (UIImageView *)headPortraitImageView {
    if (!_headPortraitImageView) {
        _headPortraitImageView = [[UIImageView alloc] init];
        _headPortraitImageView.image = [UIImage imageNamed:@"zhanweitubai"];
        _headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headPortraitImageView.layer.cornerRadius = kScaleY(35);
        _headPortraitImageView.layer.masksToBounds = YES;
    }
    return _headPortraitImageView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianbaobeijing"]];
    }
    return _backgroundImageView;
}
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel labelWithText:@"用户名" andTextColor:[UIColor colorWithHex:0x000000] andFontSize:18];
    }
    return _userNameLabel;
}
- (UIView *)LineView {
    if (!_LineView) {
        _LineView = [[UIView alloc] init];
        _LineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _LineView;
}
- (UILabel *)accountBalanceLabel {
    if (!_accountBalanceLabel) {
        _accountBalanceLabel = [UILabel labelWithText:@"200" andTextColor:[UIColor colorWithHex:0x9767d0] andFontSize:22];
    }
    return _accountBalanceLabel;
}
- (UILabel *)accountBalanceTextLabel {
    if (!_accountBalanceTextLabel) {
        _accountBalanceTextLabel = [UILabel labelWithText:@"账户余额" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
    }
    return _accountBalanceTextLabel;
}

- (UILabel *)freezeFundsTextLabel {
    if (!_freezeFundsTextLabel) {
        _freezeFundsTextLabel = [UILabel labelWithText:@"冻结资金" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
    }
    return _freezeFundsTextLabel;
}
- (UILabel *)freezeFundsLabel {
    if (!_freezeFundsLabel) {
        _freezeFundsLabel = [UILabel labelWithText:@"100" andTextColor:[UIColor colorWithHex:0x9767d0] andFontSize:22];
    }
    return _freezeFundsLabel;
}

@end
