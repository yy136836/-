//
//  WQDynamicDetailsToolBarView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDynamicDetailsToolBarView.h"

@implementation WQDynamicDetailsToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 发布时间
    UILabel *releaseTimeLabel = [UILabel labelWithText:@"3小时前" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.releaseTimeLabel = releaseTimeLabel;
    [self addSubview:releaseTimeLabel];
    [releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 赞
    UIButton *unlikeBtn = [self addChildButtonWithImageName:@"zan" defaultTitle:@" 赞"];
    self.unlikeBtn = unlikeBtn;
    // 踩
    UIButton *retweetbtn = [self addChildButtonWithImageName:@"DynamicDetailscai" defaultTitle:@" 踩"];
    self.retweetbtn = retweetbtn;
    // 鼓励支持
    UIButton *playTourBtn = [self addChildButtonWithImageName:@"dynamicguli" defaultTitle:@" 鼓励"];
    [retweetbtn addTarget:self action:@selector(retweetbtnClike) forControlEvents:UIControlEventTouchUpInside];
    [unlikeBtn addTarget:self action:@selector(unlikeBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [playTourBtn addTarget:self action:@selector(playTourBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:retweetbtn];
    [self addSubview:unlikeBtn];
    [self addSubview:playTourBtn];
    
    [playTourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [retweetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(playTourBtn.mas_left).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    [unlikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(retweetbtn.mas_left).offset(kScaleY(-ghSpacingOfshiwu));
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UIButton *)addChildButtonWithImageName:(NSString *)imageName  defaultTitle:(NSString *)title {
    UIButton *btn = [UIButton setNormalTitle:title andNormalColor:[UIColor grayColor] andFont:12];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:btn];
    return btn;
}

#pragma mark -- 踩的响应事件
- (void)retweetbtnClike {
    if ([self.delegate respondsToSelector:@selector(wqRetweetbtnClike:)]) {
        [self.delegate wqRetweetbtnClike:self];
    }
}

#pragma mark -- 赞的响应事件
- (void)unlikeBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqUnlikeBtnClike:)]) {
        [self.delegate wqUnlikeBtnClike:self];
    }
}

#pragma mark -- 鼓励的响应事件
- (void)playTourBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqPlayTourBtnClike:)]) {
        [self.delegate wqPlayTourBtnClike:self];
    }
}

@end
