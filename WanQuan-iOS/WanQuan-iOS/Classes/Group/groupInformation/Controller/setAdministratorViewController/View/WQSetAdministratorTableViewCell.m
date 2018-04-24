//
//  WQSetAdministratorTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQSetAdministratorTableViewCell.h"
#import "WQGroupMemberModel.h"

@interface WQSetAdministratorTableViewCell ()
// 头像
@property (nonatomic, strong) UIImageView *headPortraitView;
@end

@implementation WQSetAdministratorTableViewCell {
    // 姓名
    UILabel *nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupContentView {
    // 头像
    UIImageView *headPortraitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.headPortraitView = headPortraitView;
    headPortraitView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    [headPortraitView addGestureRecognizer:tap];
    headPortraitView.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitView.layer.cornerRadius = kScaleX(22);
    headPortraitView.layer.masksToBounds = YES;
    [self.contentView addSubview:headPortraitView];
    [headPortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(44), kScaleX(44)));
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    // 姓名
    nameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headPortraitView.mas_centerY);
        make.left.equalTo(headPortraitView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(headPortraitView.mas_left);
    }];
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if (self.headPortraitViewClickBlock) {
        self.headPortraitViewClickBlock();
    }
}

- (void)setModel:(WQGroupMemberModel *)model {
    _model = model;
    
    [self.headPortraitView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    nameLabel.text = model.user_name;
}

@end
