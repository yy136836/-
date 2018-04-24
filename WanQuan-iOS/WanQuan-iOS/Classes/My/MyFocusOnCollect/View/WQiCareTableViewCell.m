//
//  WQiCareTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQiCareTableViewCell.h"
#import "WQFocusOnModel.h"
#import "WQUserProfileController.h"

@interface WQiCareTableViewCell ()

@end

@implementation WQiCareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xffffff];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 初始化ContentView
- (void)setupContentView {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.creditPointsLabel];
    
    // 头像
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.left.equalTo(self.iconView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 信用分的背景view
    [self addSubview:self.creditBackgroundView];
    [self.creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.self.nameLabel.mas_right).offset(5);
    }];
    
    // 信用分图标
    [self.creditBackgroundView addSubview:self.creditImageView];
    [self.creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_left).offset(5);
    }];
    // 信用分数
    [self.creditBackgroundView addSubview:self.creditPointsLabel];
    [self.creditPointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditImageView.mas_right).offset(1);
    }];
    
    // 标签
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.iconView.mas_bottom);
    }];
    
    // 几度好友
    [self.contentView addSubview:self.aFewDegreesBackgroundLabel];
    [self.aFewDegreesBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_creditBackgroundView.mas_centerY);
        make.left.equalTo(_creditBackgroundView.mas_right).offset(6);
        make.height.offset(14);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.contentView);
    }];
}

- (void)setModel:(WQFocusOnModel *)model {
    _model = model;
    
    self.nameLabel.text = model.user_name;
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"Userpic"]];
    NSString *user_degree;
    if ([model.user_degree integerValue] == 0) {
        user_degree = [@" " stringByAppendingString:[@"自己" stringByAppendingString:@" "]];
    }else if ([model.user_degree integerValue] <= 2) {
        user_degree = [@" " stringByAppendingString:[@"2度内好友" stringByAppendingString:@" "]];
    }else if ([model.user_degree integerValue] == 3) {
        user_degree = [@" " stringByAppendingString:[@"3度好友" stringByAppendingString:@" "]];
    }else {
        user_degree = [@" " stringByAppendingString:[@"4度外好友" stringByAppendingString:@" "]];
    }
    self.aFewDegreesBackgroundLabel.text = user_degree;
    self.creditPointsLabel.text = [[NSString stringWithFormat:@"%@",model.user_creditscore] stringByAppendingString:@"分"];
    if (model.user_tag.count < 1) {
        self.tagLabel.text = [model.user_tag.firstObject stringByAppendingString:model.user_tag.lastObject];
    }else {
        self.tagLabel.text = model.user_tag.firstObject;
    }
}

#pragma mark -- 头像的响应事件
- (void)handleTapGes {
    // 不是自己
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:self.model.user_id];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Userpic"]];
        _iconView.layer.cornerRadius = 22;
        _iconView.layer.masksToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes)];
        [_iconView addGestureRecognizer:tap];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:@"用户名" andTextColor:[UIColor colorWithHex:0X111111] andFontSize:16];
    }
    return _nameLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithText:@"#标签2" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    }
    return _tagLabel;
}

// 信用分数
- (UILabel *)creditPointsLabel {
    if (!_creditPointsLabel) {
        _creditPointsLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHex:0x9871c9] andFontSize:9];
    }
    return _creditPointsLabel;
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

// 信用分图标
- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyexinyongfen"]];
    }
    return _creditImageView;
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

@end
