//
//  WQGroupDynamicActlvltyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/20.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQGroupDynamicActlvltyView.h"

@interface WQGroupDynamicActlvltyView ()

@property (strong, nonatomic) MASConstraint *bottomCon;

@end

@implementation WQGroupDynamicActlvltyView

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
    UILabel *titleLabel = [UILabel labelWithText:@"活动标题" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.top.equalTo(self.mas_top);
    }];
    
    UIImageView *actlvltyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    actlvltyImageView.contentMode = UIViewContentModeScaleAspectFill;
    actlvltyImageView.layer.masksToBounds = YES;
    actlvltyImageView.layer.cornerRadius = 0;
    self.actlvltyImageView = actlvltyImageView;
    [self addSubview:actlvltyImageView];
    [actlvltyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.height.offset(150);
    }];
    
    UILabel *timeLabel = [UILabel labelWithText:@"时间" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:13];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(actlvltyImageView.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    UILabel *addrLabel = [UILabel labelWithText:@"地点" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:13];
    self.addrLabel = addrLabel;
    [self addSubview:addrLabel];
    [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(timeLabel.mas_bottom).offset(7);
        make.bottom.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(addrLabel.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

@end
