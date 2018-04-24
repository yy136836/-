//
//  WQNewMembersTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewMembersTableViewCell.h"
#import "WQWaitingForAuditModel.h"

@interface WQNewMembersTableViewCell ()
// 头像
@property (nonatomic, strong) UIImageView *headPortraitImageView;
// 用户名称
@property (nonatomic, strong) UILabel *nameLabel;
// 公司名称
@property (nonatomic, strong) UILabel *companyNameLabel;
@end

@implementation WQNewMembersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    // 头像
    UIImageView *headPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gerenjinglitouxiang"]];
    self.headPortraitImageView = headPortraitImageView;
    headPortraitImageView.layer.cornerRadius = 5;
    headPortraitImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headPortraitImageView];
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ghCellHeight, ghCellHeight));
        make.top.equalTo(self.contentView.mas_top).offset(ghStatusCellMargin);
        make.left.equalTo(self.contentView.mas_left).offset(ghStatusCellMargin);
    }];
    
    // 用户名称
    UILabel *nameLabel = [UILabel labelWithText:@"用户名称" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headPortraitImageView.mas_top).offset(5);
        make.left.equalTo(headPortraitImageView.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 公司名称
    UILabel *companyNameLabel = [UILabel labelWithText:@"公司名称" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:12];
    self.companyNameLabel = companyNameLabel;
    [self.contentView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
    }];
    
    // 底部分隔线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(headPortraitImageView.mas_left);
        make.height.offset(0.5);
    }];
    
    // 同意的按钮
    UIButton *agreedToBtn = [[UIButton alloc] init];
    [agreedToBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreedToBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreedToBtn addTarget:self action:@selector(agreedToBtnClike) forControlEvents:UIControlEventTouchUpInside];
    agreedToBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    agreedToBtn.backgroundColor = [UIColor colorWithHex:0x5d2a89];
    agreedToBtn.layer.cornerRadius = 5;
    agreedToBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:agreedToBtn];
    [agreedToBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

// 同意的按钮
- (void)agreedToBtnClike {
    if (self.agreedToBtnClikeBlock) {
        self.agreedToBtnClikeBlock();
    }
}

- (void)setModel:(WQWaitingForAuditModel *)model {
    _model = model;
    // 头像
    NSString *imageUrl = [imageUrlString stringByAppendingString:model.user_pic];
    [self.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionShowNetworkActivity];
    // 名称
    self.nameLabel.text = model.user_name;
    // 公司名称
    self.companyNameLabel.text = model.user_tag.lastObject;
}

@end
