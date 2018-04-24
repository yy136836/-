//
//  WQJoinAlumniPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQJoinAlumniPopupWindowView.h"

@implementation WQJoinAlumniPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaruxiaoyouquantanchuang"]];
//    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
//    [imageView addGestureRecognizer:tap];
//    [self addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.equalTo(self);
//    }];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notToJoinThesuccess"]];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(304,304));
    }];
    
    // X号的按钮  透明的
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(backImageView);
        make.size.mas_equalTo(CGSizeMake(kScaleY(ghDistanceershi), ghDistanceershi));
    }];
    
    // 高斯模糊的图
    UIImageView *fuzzyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
    self.fuzzyImageView = fuzzyImageView;
    fuzzyImageView.layer.cornerRadius = 3;
    fuzzyImageView.layer.masksToBounds = YES;
    fuzzyImageView.userInteractionEnabled = YES;
    [backImageView addSubview:fuzzyImageView];
    [fuzzyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(176);
        make.bottom.equalTo(backImageView);
        make.left.equalTo(backImageView.mas_left).offset(kScaleY(1.1));
        make.right.equalTo(backImageView.mas_right).offset(kScaleY(-1.1));
    }];
//    UIVisualEffectView *eff = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, kScaleY(301), floor(176))];
//    [fuzzyImageView addSubview:eff];
//    eff.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//    UIView * darkCover = [[UIView alloc] initWithFrame:eff.frame];
//    [fuzzyImageView addSubview:darkCover];
//    darkCover.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.25];
    
    // 申请加入的按钮
    UIButton *immediatelyToJoinBtn = [[UIButton alloc] init];
    immediatelyToJoinBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    immediatelyToJoinBtn.layer.cornerRadius = 3;
    immediatelyToJoinBtn.layer.masksToBounds = YES;
    immediatelyToJoinBtn.layer.borderWidth = 1.0f;
    immediatelyToJoinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [immediatelyToJoinBtn addTarget:self action:@selector(immediatelyToJoinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [immediatelyToJoinBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    [immediatelyToJoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backImageView addSubview:immediatelyToJoinBtn];
    [immediatelyToJoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-ghDistanceershi);
        make.size.mas_equalTo(CGSizeMake(kScaleY(261), kScaleX(40)));
        make.centerX.equalTo(backImageView.mas_centerX);
    }];

    // 群组头像
    UIImageView *headPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    self.headPortraitImageView = headPortraitImageView;
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitImageView.layer.cornerRadius = 3;
    headPortraitImageView.layer.masksToBounds = YES;
    [backImageView addSubview:headPortraitImageView];
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(62), kScaleX(62)));
        make.left.equalTo(immediatelyToJoinBtn.mas_left);
        make.bottom.equalTo(immediatelyToJoinBtn.mas_top).offset(-ghSpacingOfshiwu);
    }];

    // 圈组名称
    UILabel *nameLabel = [UILabel labelWithText:@"圈组名称圈组名称圈组名称圈组名称圈组名称圈组名称圈组名称" andTextColor:[UIColor whiteColor] andFontSize:16];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 3;
    [backImageView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headPortraitImageView);
        make.left.equalTo(headPortraitImageView.mas_right).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(backImageView.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
    }];
}

#pragma mark -- 申请加入的响应事件
- (void)immediatelyToJoinBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqImmediatelyToJoinBtnClick:)]) {
        [self.delegate wqImmediatelyToJoinBtnClick:self];
    }
}

#pragma mark -- X号按钮的响应事件
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDeleteBtnClick:)]) {
        [self.delegate wqDeleteBtnClick:self];
    }
}

@end
