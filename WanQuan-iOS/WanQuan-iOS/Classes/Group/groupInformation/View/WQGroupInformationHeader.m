//
//  WQGroupInformationHeader.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupInformationHeader.h"

@implementation WQGroupInformationHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 组的头像
    UIImageView *groupHeadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner-1"]];
    self.groupHeadImageView = groupHeadImageView;
    groupHeadImageView.userInteractionEnabled = YES;
    groupHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    //添加长摁手势
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    //设置长按时间
//    longPressGesture.minimumPressDuration = 0.5;
//    [groupHeadImageView addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupHeadImageViewClick:)];
    [groupHeadImageView addGestureRecognizer:tap];
    
    [self addSubview:groupHeadImageView];
    [groupHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        // make.height.offset(kScreenWidth);
    }];
    
    // 渐变
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxidingbujianbian"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.offset(kScaleX(120));
    }];
    
    // 头像下边的背景view
    UIView *tagBackground = [[UIView alloc] init];
    tagBackground.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
    [groupHeadImageView addSubview:tagBackground];

    
    // 群组名称
    UILabel *groupNameLabel = [UILabel labelWithText:@"圈组名称" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:20];
    groupNameLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:20];
    self.groupNameLabel = groupNameLabel;
    _groupNameLabel.numberOfLines = 0;
    [tagBackground addSubview:groupNameLabel];
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagBackground.mas_top).offset(ghSpacingOfshiwu);
        make.left.equalTo(tagBackground.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(tagBackground.mas_right).offset(-ghSpacingOfshiwu);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    // 群主名称
    UILabel *GroupmainName = [UILabel labelWithText:@"圈主: 群主名称" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:17];
    GroupmainName.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    self.GroupmainName = GroupmainName;
    [tagBackground addSubview:GroupmainName];
    GroupmainName.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToUserHome)];
    [GroupmainName addGestureRecognizer:nameTap];
    
    
    
    [GroupmainName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupNameLabel.mas_left);
        make.top.equalTo(groupNameLabel.mas_bottom).offset(ghStatusCellMargin);
        make.height.equalTo(@17);
        make.bottom.equalTo(tagBackground.mas_bottom).offset(-10);
    }];
    
    
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baijiantou"]];
    [self addSubview:triangleImage];
    [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleX(9), kScaleY(11)));
        make.left.equalTo(GroupmainName.mas_right).offset(ghStatusCellMargin);
        make.centerY.equalTo(GroupmainName.mas_centerY);
    }];
    
    
    [tagBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(@80);
    }];
}

- (void)ToUserHome
{
    if (_delegte && [_delegte respondsToSelector:@selector(clickedMainName)]) {
        [_delegte clickedMainName];
    }}


// 常按头像手势触发方法
//-(void)longPressGesture:(UITapGestureRecognizer *)sender {
//    
//}
#pragma mark -- 头像的响应事件
- (void)groupHeadImageViewClick:(UITapGestureRecognizer *)tap {
    if (self.isGroupHeadClikeBlock) {
        self.isGroupHeadClikeBlock();
    }
}

@end
