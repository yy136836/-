//
//  WQpushnewFriendsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQpushnewFriendsTableViewCell.h"
#import "WQnewFriendsModel.h"
#import "YYWebImage.h"
#import "WQmyFriendsModel.h"

@interface WQpushnewFriendsTableViewCell()

@property (nonatomic, strong) UIImageView *headimageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *additionalInformationLabel;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UILabel *recommendFriendsLabel;

@end

@implementation WQpushnewFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(WQnewFriendsModel *)model
{
    _model = model;
    self.nameLabel.text = model.aUsername;
    self.additionalInformationLabel.text = model.aUserMessage;
}

- (void)setMyFriendsModel:(WQmyFriendsModel *)myFriendsModel
{
    _myFriendsModel = myFriendsModel;
    self.nameLabel.text = myFriendsModel.true_name;
    //NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",myFriendsModel.pic_truename]];
    [self.headimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(myFriendsModel.pic_truename)] options:0];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI
{
    [self addSubview:self.headimageView];
    [self addSubview:self.nameLabel];
//    [self addSubview:self.additionalInformationLabel];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.recommendFriendsLabel];
    
    [_headimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(40);
        //make.top.left.equalTo(self).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headimageView.mas_top).offset(3);
        make.left.equalTo(_headimageView.mas_right).offset(10);
    }];
//    [_additionalInformationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLabel.mas_left);
//        make.bottom.equalTo(_headimageView.mas_bottom);
//    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];
    [_recommendFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(_headimageView.mas_bottom).offset(-3);
    }];
}

#pragma mark -- 接受同意
- (void)agreeBtnClike
{
    if (self.agreeBtnClikeBlock) {
        self.agreeBtnClikeBlock();
    }
}

#pragma mark -- 懒加载
- (UIImageView *)headimageView
{
    if (!_headimageView) {
        _headimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        _headimageView.contentMode = UIViewContentModeScaleAspectFill;
        _headimageView.layer.cornerRadius = 1;
        _headimageView.layer.masksToBounds = YES;
    }
    return _headimageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:14];
    }
    return _nameLabel;
}

- (UILabel *)additionalInformationLabel
{
    if (!_additionalInformationLabel) {
        _additionalInformationLabel = [[UILabel alloc]init];
        _additionalInformationLabel.text = @"我是小明";
        _additionalInformationLabel.font = [UIFont systemFontOfSize:14];
        _additionalInformationLabel.textColor = [UIColor colorWithHex:0Xcacaca];
    }
    return _additionalInformationLabel;
}

- (UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc]init];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClike) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn setImage:[UIImage imageNamed:@"accept"] forState:0];
    }
    return _agreeBtn;
}
- (UILabel *)recommendFriendsLabel {
    if (!_recommendFriendsLabel) {
        _recommendFriendsLabel = [UILabel labelWithText:@"推荐好友" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    }
    return _recommendFriendsLabel;
}

@end
