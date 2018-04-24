//
//  WQForwardingNeedsView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQForwardingNeedsView.h"

@interface WQForwardingNeedsView () 
@property (strong, nonatomic) MASConstraint *bottomCon;
@end

@implementation WQForwardingNeedsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHex:0xededed];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 用户名
    UILabel *userNameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x9767d0] andFontSize:14];
    self.userNameLabel = userNameLabel;
    [self addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(ghStatusCellMargin);
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
    }];
    // 金额
    UILabel *moneyLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:20];
    self.moneyLabel = moneyLabel;
    [self addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userNameLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    // 红包
    [self addSubview:self.forwarDingHongbao];
    [_forwarDingHongbao mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(22, 30));
        make.centerY.equalTo(userNameLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    // 标题
    UILabel *titleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    titleLabel.numberOfLines = 1;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel.mas_left);
        make.top.equalTo(userNameLabel.mas_bottom).offset(ghStatusCellMargin);
    }];
    // 内容
    UILabel *contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:14];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 2;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.right.equalTo(moneyLabel.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(contentLabel.mas_bottom).offset(ghStatusCellMargin);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)forwarDingHongbao {
    if (!_forwarDingHongbao) {
        _forwarDingHongbao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyehongbao"]];
    }
    return _forwarDingHongbao;
}

@end
