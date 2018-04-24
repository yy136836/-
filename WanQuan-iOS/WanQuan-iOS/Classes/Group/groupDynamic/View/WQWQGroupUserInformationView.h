//
//  WQWQGroupUserInformationView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQWQGroupUserInformationView;

@protocol WQWQGroupUserInformationViewDelegate <NSObject>

/**
 点击头像

 @param groupUserInformationView
 */
- (void)wqGroupUserInformationViewHeadPortraitCliek:(WQWQGroupUserInformationView *)groupUserInformationView;
@end

@interface WQWQGroupUserInformationView : UIView
@property (nonatomic, weak) id <WQWQGroupUserInformationViewDelegate> delegate;

/**
 是否是活动
 */
@property (nonatomic, assign) BOOL isActlvlty;

@property (nonatomic, copy) NSString *type;

/**
 用户的头像
 */
@property (nonatomic, strong) UIImageView *HeadPortraitImageView;

/**
 用户的名称
 */
@property (nonatomic, strong) UILabel *userLabel;

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
 需求
 */
/**
 标签
 */
@property (nonatomic, strong) UILabel *tagOncLabel;
@property (nonatomic, strong) UILabel *tagTwoLabel;

/**
 截止时间
 */
@property (nonatomic, strong) UILabel *stopTimeLabel;

/**
 紫色的条
 */
@property (nonatomic, strong) UIView *articlePurpleView;

/**
 金额
 */
@property (nonatomic, strong) UILabel *moneyLabel;

/**
 距离
 */
@property (nonatomic, strong) UILabel *distanceLabel;

/**
 截止时间图片
 */
@property (nonatomic, strong) UIImageView *stopTimeImageView;

/**
 距离的图片
 */
@property (nonatomic, strong) UIImageView *distanceImageView;

/**
 红包
 */
@property (nonatomic, strong) UIImageView *hongbaoImageView;

/**
 主题
 */

/**
 发布时间
 */
@property (nonatomic, strong) UILabel *timeLbale;

/**
 回复的按钮
 */
@property (nonatomic, strong) UIButton *replyBtn;

@end
