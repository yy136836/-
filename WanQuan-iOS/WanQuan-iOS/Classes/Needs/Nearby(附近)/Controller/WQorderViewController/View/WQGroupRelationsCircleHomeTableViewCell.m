//
//  WQGroupRelationsCircleHomeTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupRelationsCircleHomeTableViewCell.h"
#import "WQGroupModel.h"
#import <NSAttributedString+YYText.h>

@interface WQGroupRelationsCircleHomeTableViewCell ()
// 群组头像
@property (nonatomic, strong) UIImageView *groupHeadPortraitimageView;
// 群名
@property (nonatomic, strong) UILabel *groupNameLabel;
// 最新动态头像
@property (nonatomic, strong) UIImageView *latestHeadPortraitimageView;
// 最新动态人的姓名
@property (nonatomic, strong) UILabel *latestNameLabel;
// 置顶的图标
@property (nonatomic, strong) UIImageView *zhidingImageView;

@property (nonatomic, strong) UILabel *latestLabel;


@end

@implementation WQGroupRelationsCircleHomeTableViewCell

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
        make.top.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    // 群名
    UILabel *groupNameLabel = [UILabel labelWithText:@"看颜的世界看颜的世看颜的世看颜的世看颜的世看颜的世" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    groupNameLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    self.groupNameLabel = groupNameLabel;
    groupNameLabel.numberOfLines = 2;
    [self.contentView addSubview:groupNameLabel];
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.left.equalTo(groupHeadPortraitimageView.mas_right).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
    
    // 最新动态的tag
    UILabel *latestLabel = [UILabel labelWithText:@"最新主题:" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:latestLabel];
    self.latestLabel = latestLabel;
    [latestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupNameLabel.mas_left);
        make.top.equalTo(groupNameLabel.mas_bottom).offset(ghStatusCellMargin);
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(64);
    }];
    
    // 最新动态头像
    UIImageView *latestHeadPortraitimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gerenjinglitouxiang"]];
    self.latestHeadPortraitimageView = latestHeadPortraitimageView;
    latestHeadPortraitimageView.contentMode = UIViewContentModeScaleAspectFill;
    latestHeadPortraitimageView.layer.cornerRadius = 10;
    latestHeadPortraitimageView.layer.masksToBounds = YES;
    [self.contentView addSubview:latestHeadPortraitimageView];
    [latestHeadPortraitimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(groupNameLabel);
        make.top.equalTo(latestLabel.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 最新动态人的姓名
    UILabel *latestNameLabel = [UILabel labelWithText:@"呵呵呵呵呵呵呵呵呵呵呵呵呵而发么开发么快" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:14];
    self.latestNameLabel = latestNameLabel;
    latestNameLabel.numberOfLines = 1;
    [self.contentView addSubview:latestNameLabel];
    [latestNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(latestHeadPortraitimageView.mas_centerY).offset(1);
        make.left.equalTo(latestHeadPortraitimageView.mas_right).offset(2);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 底部分隔线
    UIView *bottomLine = [[UIView alloc] init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.top.equalTo(latestHeadPortraitimageView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(groupNameLabel);
        make.bottom.right.equalTo(self.contentView);
    }];
    
    // 置顶的图标
    self.zhidingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhiding"]];
    self.zhidingImageView.hidden = YES;
    [self.contentView addSubview:self.zhidingImageView];
    [self.zhidingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(15, 14));
    }];
}

- (void)setModel:(WQGroupModel *)model {
    _model = model;
    // 群组头像
    [self.groupHeadPortraitimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(model.pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 群名称
    NSMutableAttributedString * groupName = [[NSMutableAttributedString alloc] initWithString: model.name ] ;
    [groupName yy_setLineSpacing:5 range:NSMakeRange(0, model.name.length)];
    self.groupNameLabel.attributedText = groupName;
    // 有没有最新动态
    if ([model.latest_title isEqualToString:@""]) {
        // 没有最新动态
        self.latestNameLabel.text = @"还没有新动态";
    }else {
        // 最新的动态
        self.latestNameLabel.text = [[model.latest_user_name stringByAppendingString:@": "] stringByAppendingString:model.latest_title];
    }
    // 最新动态发布者的头像
    [self.latestHeadPortraitimageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.latest_user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 置顶的显示置顶图标
    if ([model.set_top boolValue]) {
        self.zhidingImageView.hidden = NO;
    }else {
        self.zhidingImageView.hidden = YES;
    }
    
    self.latestLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:11];
    if ([model.unread_count  intValue]) {
        self.latestLabel.textColor = UIColorWithHex16_(0xff3800);
        self.latestLabel.backgroundColor = UIColorWithHex16_(0xffe4e7);
        self.latestLabel.text =[NSString stringWithFormat:@"   新主题  %@   ",model.unread_count]; ;
        self.latestLabel.layer.masksToBounds = YES;
        self.latestLabel.layer.cornerRadius = 10;

    }else{
        self.latestLabel.backgroundColor = [UIColor whiteColor];
        self.latestLabel.textColor = UIColorWithHex16_(0x999999);
        self.latestLabel.text = @"最新主题：";
        self.latestLabel.layer.masksToBounds = NO;

    }
    
    
    [self layoutIfNeeded];
}

- (void)groupHeadPortraitimageViewTapGes {
    if (self.groupHeadPortraitimageViewBlock) {
        self.groupHeadPortraitimageViewBlock();
    }
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
