//
//  WQBBSTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQBBSTableViewCell.h"
#import "WQPeopleListModel.h"

@interface WQBBSTableViewCell ()
@property (nonatomic, strong) UIImageView *headPortraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation WQBBSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    //底部分隔线
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
    // 头像
    UIImageView *headPortraitImageView = [[UIImageView alloc] init];
    self.headPortraitImageView = headPortraitImageView;
    headPortraitImageView.layer.cornerRadius = 25;
    headPortraitImageView.layer.masksToBounds = YES;
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headPortraitImageView];
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
    }];
    
    // 用户名
    UILabel *nameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headPortraitImageView.mas_top).offset(4);
        make.left.equalTo(headPortraitImageView.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 信用分的背景view
    [self.contentView addSubview:self.creditBackgroundView];
    [_creditBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 14));
        make.left.equalTo(self.nameLabel.mas_right).offset(ghStatusCellMargin);
    }];
    // 几度好友
    [self.contentView addSubview:self.aFewDegreesBackgroundLabel];
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
    
//    // 信用分
//    UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinyongfen"]];
//    self.creditImageView = creditImageView;
//    [self.contentView addSubview:creditImageView];
//    [creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(18, 18));
//        make.centerY.equalTo(nameLabel.mas_centerY);
//        make.left.equalTo(nameLabel.mas_right).offset(ghStatusCellMargin);
//    }];
//    UILabel *creditLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x901f87] andFontSize:12];
//    self.creditLabel = creditLabel;
//    [self.contentView addSubview:creditLabel];
//    [creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(nameLabel.mas_centerY);
//        make.left.equalTo(creditImageView.mas_right).offset(5);
//    }];
//    
//    //几度好友
//    UILabel *isFriendsLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x888888] andFontSize:10];
//    self.isFriendsLabel = isFriendsLabel;
//    isFriendsLabel.layer.borderWidth = 1.0f;
//    isFriendsLabel.layer.cornerRadius = 5;
//    isFriendsLabel.layer.borderColor = [UIColor colorWithHex:0Xa03f98].CGColor;
//    [self.contentView addSubview:isFriendsLabel];
//    [isFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(nameLabel.mas_centerY);
//        make.left.equalTo(creditLabel.mas_right).offset(15);
//    }];
    
    //观看时间
    UILabel *timeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(nameLabel.mas_left);
//        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
//        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
//    //底部分隔线
//    UIView *bottomLineView = [[UIView alloc] init];
//    self.bottomLineView = bottomLineView;
//    bottomLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
//    [self.contentView addSubview:bottomLineView];
//    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(ghStatusCellMargin);
//        make.height.offset(0.5);
//    }];
    
}

- (void)setModel:(WQPeopleListModel *)model {
    _model = model;
    [self.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAppendingString:model.user_pic]] placeholder:[UIImage imageWithColor:HEX(0xededed)]];
    self.headPortraitImageView.clipsToBounds = YES;
    self.nameLabel.text = model.user_name;
    self.creditLabel.text = [model.user_creditscore stringByAppendingString:@"分"];
    
    //NSMutableString * timeStr = model.work_status_time.mutableCopy;
    //timeStr =  [[timeStr substringWithRange:NSMakeRange(0, timeStr.length - 3)] mutableCopy];
    
    self.timeLabel.text = model.work_status_time;
    
    self.aFewDegreesBackgroundLabel.text = [WQTool friendship:[model.user_degree integerValue]];
    
}

#pragma mark -- 懒加载
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
