//
//  WQGroupListCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupListCell.h"
#import "WQGroupModel.h"
@interface WQGroupListCell ()
@property (strong, nonatomic) UIImageView *avatarImageView;
//@property (strong, nonatomic) UILabel *groupLabelName;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
//@property (strong, nonatomic) UILabel *GroupTitleLabel;

@end

@implementation WQGroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 头像
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    avatarImageView.layer.cornerRadius = 5;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView = avatarImageView;
    [self.contentView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.top.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 群名称
    UILabel *groupNameLabel = [UILabel labelWithText:@"圈名称" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    groupNameLabel.numberOfLines = 0;
    self.groupNameLabel = groupNameLabel;
    [self.contentView addSubview:groupNameLabel];
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(avatarImageView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    // 圈介绍
    UILabel *introduceLabel = [UILabel labelWithText:@"介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍介绍" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    self.introduceLabel = introduceLabel;
    introduceLabel.numberOfLines = 1;
    [self.contentView addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupNameLabel.mas_left);
        make.top.equalTo(groupNameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(kScaleY(-ghSpacingOfshiwu));
        make.height.equalTo(@17);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(WQGroupModel *)model {
    _model = model;
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    self.groupNameLabel.text = model.name;
}

- (void)setGroupDescriptionString:(NSString *)groupDescriptionString {
    _groupDescriptionString = groupDescriptionString;
    
    self.introduceLabel.text = groupDescriptionString;
}

- (void)setSearchContent:(NSString *)searchContent {
    _searchContent = searchContent;
    // 判断有没有该字符
    if([_model.name rangeOfString:searchContent].location !=NSNotFound) {
        NSRange range = [_model.name rangeOfString:searchContent];
        
        NSMutableAttributedString *text= [[NSMutableAttributedString alloc] initWithString:_model.name];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x9767d0] range:NSMakeRange(range.location, searchContent.length)];
        _groupNameLabel.attributedText = text;
    }
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//    _avatarImageView.layer.cornerRadius = 5;
//    _avatarImageView.clipsToBounds = YES;
//    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _avatarImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
////    _avatarImageView.backgroundColor = [UIColor whiteColor];
//    [_avatarImageView addGestureRecognizer:tap];
//}
//
//- (void)handleTapGes:(UITapGestureRecognizer *)tap {
//    if (self.wqAvatarImageViewClikeBlock) {
//        self.wqAvatarImageViewClikeBlock();
//    }
//}
//
//- (void)setModel:(WQGroupModel *)model {
//    _model = model;
//
//    [_avatarImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic)] options:YYWebImageOptionShowNetworkActivity];
//
//    _groupLabelName.text = model.name;
//    _GroupTitleLabel.text = model.latest_topic_name;
//
//
//}

@end
