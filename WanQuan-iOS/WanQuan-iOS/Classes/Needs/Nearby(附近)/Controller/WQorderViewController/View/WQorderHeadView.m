//
//  WQorderHeadView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQorderHeadView.h"

@interface WQorderHeadView ()

@property (nonatomic, strong) UIImageView *distanceImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation WQorderHeadView

- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.headPortraitImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.tagOncLabel];
    [self addSubview:self.tagTwoLabel];
    [self addSubview:self.timeImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.distanceImageView];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.moneyLabel];
    
    [_headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.height.width.offset(50);
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headPortraitImageView.mas_right).offset(ghStatusCellMargin);
        make.top.equalTo(_headPortraitImageView.mas_top).offset(5);
    }];
    
    // 信用分的背景view
    [self addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(_userNameLabel.mas_right).offset(ghStatusCellMargin);
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.creditBackgroundView.hidden = YES;
    }
    
    // 几度好友
    [self addSubview:self.aFewDegreesBackgroundLabel];
    [_aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
        make.height.offset(14);
    }];
    // 信用分图标
    [_creditBackgroundView addSubview:self.creditImageView];
    [_creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
    }];
    // 信用分数
    [_creditBackgroundView addSubview:self.creditLabel];
    [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditImageView.mas_right).offset(1);
    }];
    
    [_tagOncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_left);
        make.bottom.equalTo(_headPortraitImageView.mas_bottom).offset(-3);
    }];
    [_tagTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tagOncLabel.mas_top);
        make.left.equalTo(_tagOncLabel.mas_right).offset(ghStatusCellMargin);
    }];
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_left);
        make.bottom.equalTo(self).offset(-25);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeImageView.mas_centerY);
        make.left.equalTo(_timeImageView.mas_right).offset(5);
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
        make.centerY.equalTo(_timeLabel.mas_centerY);
    }];
    [_distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_distanceLabel.mas_centerY);
        make.right.equalTo(_distanceLabel.mas_left).offset(-5);
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.offset(ghStatusCellMargin);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if (self.headPortraitBlock) {
        self.headPortraitBlock();
    }
}

#pragma mark - 懒加载
- (UIImageView *)headPortraitImageView {
    if (!_headPortraitImageView) {
        _headPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
        _headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headPortraitImageView.layer.cornerRadius = 25;
        _headPortraitImageView.layer.masksToBounds = YES;
        _headPortraitImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_headPortraitImageView addGestureRecognizer:tap];
    }
    return _headPortraitImageView;
}
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    }
    return _userNameLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel labelWithText:@"111" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:24];
    }
    return _moneyLabel;
}

- (UILabel *)tagOncLabel {
    if (!_tagOncLabel) {
        _tagOncLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _tagOncLabel;
}

- (UILabel *)tagTwoLabel {
    if (!_tagTwoLabel) {
        _tagTwoLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _tagTwoLabel;
}
- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyeshijian"]];
    }
    return _timeImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    }
    return _timeLabel;
}
- (UIImageView *)distanceImageView {
    if (!_distanceImageView) {
        _distanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyejuli"]];
    }
    return _distanceImageView;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:10];
    }
    return _distanceLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = WQ_BG_LIGHT_GRAY;
    }
    return _bottomLineView;
}
// 信用分的背景view
- (UIView *)creditBackgroundView {
    if (!_creditBackgroundView) {
        _creditBackgroundView = [[UIView alloc] init];
        _creditBackgroundView.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        _creditBackgroundView.layer.cornerRadius = 2;
        _creditBackgroundView.layer.masksToBounds = YES;
    }
    return _creditBackgroundView;
}

// 几度好友的背景颜色
- (UILabel *)aFewDegreesBackgroundLabel {
    if (!_aFewDegreesBackgroundLabel) {
        _aFewDegreesBackgroundLabel = [UILabel labelWithText:@"2度好友" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:9];
        _aFewDegreesBackgroundLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _aFewDegreesBackgroundLabel.layer.cornerRadius = 2;
        _aFewDegreesBackgroundLabel.layer.masksToBounds = YES;
    }
    return _aFewDegreesBackgroundLabel;
}

// 信用分图标
- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    }
    return _creditImageView;
}

// 信用分数
- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [UILabel labelWithText:@"29分" andTextColor:[UIColor colorWithHex:0x9872ca] andFontSize:9];
    }
    return _creditLabel;
}

@end
