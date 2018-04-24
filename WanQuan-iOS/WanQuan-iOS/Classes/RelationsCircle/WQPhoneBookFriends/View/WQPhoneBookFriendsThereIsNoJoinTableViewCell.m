//
//  WQPhoneBookFriendsThereIsNoJoinTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhoneBookFriendsThereIsNoJoinTableViewCell.h"
#import "WQPhoneBookFriendsModel.h"

@interface WQPhoneBookFriendsThereIsNoJoinTableViewCell ()
/**
 头像
 */
@property (nonatomic, strong) UIImageView *user_pic;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *user_name;

/**
 标签
 */
@property (nonatomic, strong) UILabel *tagLabel;
@end

@implementation WQPhoneBookFriendsThereIsNoJoinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    // 头像
    self.user_pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglushoujizhucetouxiang"]];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.layer.cornerRadius = 22;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.userInteractionEnabled = YES;
    [self.contentView addSubview:self.user_pic];
    [self.user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ghCellHeight, ghCellHeight));
        make.left.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
    }];
    // 姓名
    self.user_name = [UILabel labelWithText:@"姓名" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self.contentView addSubview:self.user_name];
    [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user_pic.mas_right).offset(kScaleY(ghSpacingOfshiwu));
        make.top.equalTo(self.user_pic.mas_top);
    }];
    // 添加的按钮
    self.invitationBtn = [UIButton setNormalTitle:@"邀请" andNormalColor:[UIColor colorWithHex:0x9767d0] andFont:14];
    self.invitationBtn.backgroundColor = [UIColor whiteColor];
    self.invitationBtn.layer.masksToBounds = YES;
    self.invitationBtn.layer.cornerRadius = 5;
    self.invitationBtn.layer.borderWidth = 1.0f;
    self.invitationBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
    [self.invitationBtn addTarget:self action:@selector(invitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.invitationBtn];
    [self.invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    // 标签
    self.tagLabel = [UILabel labelWithText:@"清华大学清华大学清华大学清华大学清华大学清华" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.user_pic.mas_bottom);
        make.left.equalTo(self.user_name.mas_left);
        make.right.equalTo(self.invitationBtn.mas_left).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.bottom.left.right.equalTo(self.contentView);
    }];
}

- (void)setModel:(WQPhoneBookFriendsModel *)model {
    _model = model;
    
    self.user_name.text = model.name;
    self.tagLabel.text = model.phone;
    
    // 是否已邀请进入万圈
    if (model.invited) {
        [self.invitationBtn setEnabled:NO];
        [self.invitationBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        self.invitationBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        self.invitationBtn.layer.borderColor = [UIColor colorWithHex:0xede6ff].CGColor;
        [self.invitationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScaleY(60), 25));
        }];
    }else {
        [self.invitationBtn setEnabled:YES];
        [self.invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
        self.invitationBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        self.invitationBtn.backgroundColor = [UIColor whiteColor];
        [self.invitationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
        }];
    }
}

#pragma mark -- 邀请的响应事件
- (void)invitationBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqInvitationClick:)]) {
        [self.delegate wqInvitationClick:self];
    }
}

@end
