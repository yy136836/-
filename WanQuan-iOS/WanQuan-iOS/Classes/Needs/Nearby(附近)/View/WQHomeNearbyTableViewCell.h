//
//  WQHomeNearbyTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQHomeNearbyTagModel;
@interface WQHomeNearbyTableViewCell : UITableViewCell
@property (nonatomic, strong) WQHomeNearbyTagModel *homeNearbyTagModel;
@property (nonatomic, copy) void(^headBtnClikeBlock)();

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
 时间倒计时图标
 */
@property (nonatomic, strong) UIImageView *daoqishijian;

/**
 地理位置的图标
 */
@property (nonatomic, strong) UIImageView *locationImageView;

/**
 地址
 */
@property (strong, nonatomic) UILabel *addr;

@end
