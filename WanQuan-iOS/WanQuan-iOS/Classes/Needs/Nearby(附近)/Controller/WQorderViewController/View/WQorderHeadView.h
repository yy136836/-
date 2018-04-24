//
//  WQorderHeadView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQorderHeadView : UIView

@property (nonatomic, strong) UIImageView *headPortraitImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *tagOncLabel;
@property (nonatomic, strong) UILabel *tagTwoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

/**
 到期时间图标
 */
@property (nonatomic, strong) UIImageView *timeImageView;

/**
 信用分的背景view
 */
@property (nonatomic, strong) UIView *creditBackgroundView;

/**
 几度好友
 */
@property (nonatomic, strong) UILabel *aFewDegreesBackgroundLabel;

/**
 信用分图标
 */
@property (nonatomic, strong) UIImageView *creditImageView;

/**
 信用分数
 */
@property (nonatomic, strong) UILabel *creditLabel;

/**
 金额
 */
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, copy) void (^headPortraitBlock)();

- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString;

@end
