//
//  WQRecommendedTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRecommendedTableViewCell.h"
#import "WQGroupModel.h"

@interface WQRecommendedTableViewCell ()

/**
 群头像
 */
@property (nonatomic, strong) UIImageView *groupHeadPortraitimageView;

/**
 群名
 */
@property (nonatomic, strong) UILabel *groupNameLabel;

/**
 内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 加入的按钮
 */
@property (nonatomic, strong) UIButton *joinBtn;

@end

@implementation WQRecommendedTableViewCell

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
    // 群组头像
    UIImageView *groupHeadPortraitimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.groupHeadPortraitimageView = groupHeadPortraitimageView;
    groupHeadPortraitimageView.contentMode = UIViewContentModeScaleAspectFill;
    groupHeadPortraitimageView.layer.cornerRadius = 3;
    groupHeadPortraitimageView.layer.masksToBounds = YES;
    groupHeadPortraitimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupHeadPortraitimageViewTapGes)];
    [groupHeadPortraitimageView addGestureRecognizer:tap];
    [self.contentView addSubview:groupHeadPortraitimageView];
    [groupHeadPortraitimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    // 群名
    UILabel *groupNameLabel = [UILabel labelWithText:@"看颜的世界" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    groupNameLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    self.groupNameLabel = groupNameLabel;
    groupNameLabel.numberOfLines = 1;
    [self.contentView addSubview:groupNameLabel];
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupHeadPortraitimageView.mas_top);
        make.left.equalTo(groupHeadPortraitimageView.mas_right).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 加入的按钮
    UIButton *joinBtn = [[UIButton alloc] init];
    self.joinBtn = joinBtn;
    joinBtn.backgroundColor = [UIColor whiteColor];
    joinBtn.layer.borderWidth = 1.0f;
    joinBtn.layer.borderColor = [UIColor colorWithHex:0X9555cf].CGColor;
    joinBtn.layer.cornerRadius = 5;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [joinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [joinBtn setTitle:@"加入" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor colorWithHex:0X9555cf] forState:UIControlStateNormal];
    [self.contentView addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 25));
        make.centerY.equalTo(groupHeadPortraitimageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    // 内容
    UILabel *contentLabel = [UILabel labelWithText:@"大伤脑筋都是你的就是你的就是你短时间内第三季度年四季度那就是的那就是你倒计时的你是嫉妒你手机" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 2;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinBtn.mas_centerY);
        make.left.equalTo(groupNameLabel.mas_left);
        make.right.equalTo(joinBtn.mas_left).offset(-ghStatusCellMargin);
    }];
    
    // 底部分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.right.bottom.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
}

// 加入按钮的响应事件
- (void)joinBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqJoinBtnClickRecommendedTableViewCell:)]) {
        [self.delegate wqJoinBtnClickRecommendedTableViewCell:self];
    }
}

// 点击头像
- (void)groupHeadPortraitimageViewTapGes {
    if ([self.delegate respondsToSelector:@selector(wqGroupHeadPortraitimageViewTableViewCell:)]) {
        [self.delegate wqGroupHeadPortraitimageViewTableViewCell:self];
    }
}

- (void)setModel:(WQGroupModel *)model {
    _model = model;
    // 群头像
    [self.groupHeadPortraitimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 群名称
    self.groupNameLabel.text = model.name;
    
    // 是否是私密圈  true:私密圈
    if ([model.privacy boolValue]) {
        [self.joinBtn setTitle:@"申请" forState:UIControlStateNormal];
    }else {
        [self.joinBtn setTitle:@"加入" forState:UIControlStateNormal];
    }
}

- (void)setGroupDescription:(NSString *)groupDescription {
    _groupDescription = groupDescription;
    self.contentLabel.text = groupDescription;
}

@end
