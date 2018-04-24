//
//  WQiCareTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQFocusOnModel;

@interface WQiCareTableViewCell : UITableViewCell 

@property (nonatomic, strong) WQFocusOnModel *model;

/**
 用户头像
 */
@property (strong, nonatomic) UIImageView *iconView;

/**
 昵称
 */
@property (strong, nonatomic) UILabel *nameLabel;

/**
 标签
 */
@property (strong, nonatomic) UILabel *tagLabel;

/**
 信用分
 */
@property (nonatomic, strong) UILabel *creditPointsLabel;
/**
 信用分的背景view
 */
@property (nonatomic, strong) UIView *creditBackgroundView;

/**
 信用分图标
 */
@property (nonatomic, strong) UIImageView *creditImageView;

/**
 几度好友
 */
@property (nonatomic, strong) UILabel *aFewDegreesBackgroundLabel;

@end
