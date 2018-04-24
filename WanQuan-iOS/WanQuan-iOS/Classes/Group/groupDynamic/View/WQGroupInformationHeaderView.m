//
//  WQGroupInformationHeaderView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupInformationHeaderView.h"

@implementation WQGroupInformationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 组的大头像
    UIImageView *groupBackgroundHeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.groupBackgroundHeadPortraitImageView = groupBackgroundHeadPortraitImageView;
    groupBackgroundHeadPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 切掉,否则拖拽的时候有问题
    groupBackgroundHeadPortraitImageView.clipsToBounds = YES;
    [self addSubview:groupBackgroundHeadPortraitImageView];
    [groupBackgroundHeadPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//
//    UIVisualEffectView *eff = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, floor(kScaleY(204)))];
//    [groupBackgroundHeadPortraitImageView addSubview:eff];
//    eff.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//
//    UIView * darkCover = [[UIView alloc] initWithFrame:eff.frame];
//    [groupBackgroundHeadPortraitImageView addSubview:darkCover];
//    darkCover.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.25];
    
    // 组的小头像
    UIImageView *groupHeadPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.groupHeadPortraitImageView = groupHeadPortraitImageView;
    groupHeadPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    groupHeadPortraitImageView.layer.cornerRadius = 3;
    groupHeadPortraitImageView.layer.masksToBounds = YES;
    groupHeadPortraitImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
    groupHeadPortraitImageView.backgroundColor = [UIColor whiteColor];
    [groupHeadPortraitImageView addGestureRecognizer:tap];
    [self addSubview:groupHeadPortraitImageView];
    [groupHeadPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    // 群组名称
    UILabel *groupNameLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:18];
    groupNameLabel.numberOfLines = 2;
    self.groupNameLabel = groupNameLabel;
    [self addSubview:groupNameLabel];
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupHeadPortraitImageView.mas_top).offset(3);
        make.left.equalTo(groupHeadPortraitImageView.mas_right).offset(20);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    
    // 群主名称
    UILabel *groupManagerNamelLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:15];
    groupManagerNamelLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *groupManagerNamelLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupManagerNamelLabelTap:)];
    [groupManagerNamelLabel addGestureRecognizer:groupManagerNamelLabelTap];
    self.groupManagerNamelLabel = groupManagerNamelLabel;
    [self addSubview:groupManagerNamelLabel];
    [groupManagerNamelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(groupHeadPortraitImageView.mas_bottom).offset(-3);
        make.left.equalTo(groupNameLabel.mas_left);
    }];
    
    // 三角
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baijiantou"]];
    [self addSubview:triangleImage];
    [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleX(9), kScaleY(11)));
        make.left.equalTo(groupManagerNamelLabel.mas_right).offset(ghStatusCellMargin);
        make.centerY.equalTo(groupManagerNamelLabel.mas_centerY);
    }];
    
    // 群人数
    UILabel *numberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0xffffff] andFontSize:15];
    numberLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *numberLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numberLabel:)];
    [numberLabel addGestureRecognizer:numberLabelTap];
    self.numberLabel = numberLabel;
    [self addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(groupManagerNamelLabel.mas_top).offset(-ghStatusCellMargin);
        make.left.equalTo(groupNameLabel.mas_left);
    }];
    
    // 三角
    UIImageView *numberLabelTriangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baijiantou"]];
    [self addSubview:numberLabelTriangleImage];
    [numberLabelTriangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleX(9), kScaleY(11)));
        make.left.equalTo(numberLabel.mas_right).offset(ghStatusCellMargin);
        make.centerY.equalTo(numberLabel.mas_centerY);
    }];
    UIView * view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

#pragma mark - 响应事件
// 点击群头像
- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqHeadPortraitImageViewClike:)]) {
        [self.delegate wqHeadPortraitImageViewClike:self];
    }
}
// 群人数
- (void)numberLabel:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqNumberLabelClike:)]) {
        [self.delegate wqNumberLabelClike:self];
    }
}
// 群主
- (void)groupManagerNamelLabelTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqGroupManagerNamelLabelTap:)]) {
        [self.delegate wqGroupManagerNamelLabelTap:self];
    }
}

@end
