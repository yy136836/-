//
//  WQSpecifyTheFriendsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSpecifyTheFriendsTableViewCell.h"
#import "WQUserProfileModel.h"
#import "YYWebImage.h"
#import "WQfriend_listModel.h"

@interface WQSpecifyTheFriendsTableViewCell ()
//@property (nonatomic, strong) UIImageView *headImageView;
//@property (nonatomic, strong) UILabel *nameLabel;
//
//@end
//
//@implementation WQSpecifyTheFriendsTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}
//
//#pragma mark -- 初始化UI
//- (void)setupUI {
//    UIImageView *headImageView = [[UIImageView alloc] init];
//    self.headImageView = headImageView;
//    headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    headImageView.layer.cornerRadius = 17.5;
//    headImageView.layer.masksToBounds = YES;
//    [self addSubview:headImageView];
//    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(5);
//        make.left.equalTo(self).offset(10);
//        make.height.width.offset(35);
//    }];
//    
//    UILabel *nameLabel = [[UILabel alloc] init];
//    self.nameLabel = nameLabel;
//    [self addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headImageView.mas_centerY);
//        make.left.equalTo(headImageView.mas_right).offset(8);
//    }];
//    
//    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
//    self.checkImageView = checkImageView;
//    checkImageView.hidden = YES;
//    [self addSubview:checkImageView];
//    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.width.offset(18);
//        make.left.equalTo(self.mas_right).offset(-23);
//        make.top.equalTo(self).offset(18);
//    }];
//}
//
//- (void)setModel:(WQUserProfileModel *)model {
//    _model = model;
//    self.nameLabel.text = model.true_name;
//    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
//}

// 名称
@property (nonatomic, strong) UILabel *titleLabel;
// 标签
@property (nonatomic, strong) UILabel *tagLabel;
// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation WQSpecifyTheFriendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.tagLabel];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.offset(44);
        make.left.equalTo(self).offset(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(3);
        make.left.equalTo(_avatarImageView.mas_right).offset(15);
    }];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView.mas_bottom).offset(-3);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.bottom.equalTo(self);
        make.left.equalTo(_avatarImageView.mas_left);
    }];
    
    UIImageView *quanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanweixuanzhong"]];
    self.quanImageView = quanImageView;
    [self.contentView addSubview:quanImageView];
    [quanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    
    UIImageView *duihaoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanxuanzhong"]];
    duihaoImageView.hidden = YES;
    self.duihaoImageView = duihaoImageView;
    [self.contentView addSubview:duihaoImageView];
    [duihaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-16);
    }];
}

- (void)setModel:(WQfriend_listModel *)model {
    _model = model;
    _titleLabel.text = model.true_name;
    [_avatarImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
    if (model.tag.count >= 1) {
        _tagLabel.text = [NSString stringWithFormat:@"%@",model.tag.firstObject];
    } else {
        _tagLabel.text = @"";
    }
}

#pragma mark -- 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = 22;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    }
    return _tagLabel;
}

@end
