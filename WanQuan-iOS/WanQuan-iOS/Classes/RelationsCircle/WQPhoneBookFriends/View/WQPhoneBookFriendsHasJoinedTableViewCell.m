//
//  WQPhoneBookFriendsHasJoinedTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhoneBookFriendsHasJoinedTableViewCell.h"
#import "WQPhoneBookFriendsModel.h"

@interface WQPhoneBookFriendsHasJoinedTableViewCell ()

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

@implementation WQPhoneBookFriendsHasJoinedTableViewCell

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
    self.addBtn = [UIButton setNormalTitle:@"添加" andNormalColor:[UIColor colorWithHex:0x9767d0] andFont:14];
    self.addBtn.backgroundColor = [UIColor whiteColor];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.borderWidth = 1.0f;
    self.addBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.right.equalTo(self.addBtn.mas_left).offset(kScaleY(-ghSpacingOfshiwu));
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
    NSString *imageString = @"https://wanquan.belightinnovation.com/file/download?fileID=";
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:[imageString stringByAppendingString:model.user_pic]] placeholder:[UIImage imageNamed:@"denglushoujizhucetouxiang"]];
    switch (model.user_tag.count) {
        case 0: {
            self.tagLabel.text = @"暂未填写信息";
        }
            break;
        case 1: {
            self.tagLabel.text = model.user_tag.firstObject;
        }
            break;
        case 2: {
            self.tagLabel.text = model.user_tag.firstObject;
        }
            break;
            
        default:
            break;
    }
    // 是否已经发送邀请
    if (model.sent_friend_apply) {
        [self.addBtn setEnabled:NO];
        [self.addBtn setTitle:@"已发送好友申请" forState:UIControlStateNormal];
        self.addBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        self.addBtn.layer.borderColor = [UIColor colorWithHex:0xede6ff].CGColor;
        [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScaleY(115), 30));
        }];
    }else {
        [self.addBtn setEnabled:YES];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        self.addBtn.backgroundColor = [UIColor whiteColor];
        self.addBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
        [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScaleY(54), 25));
        }];
    }
}

#pragma mark -- 添加按钮的响应事件
- (void)addBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqAddClick:)]) {
        [self.delegate wqAddClick:self];
    }
}

@end
