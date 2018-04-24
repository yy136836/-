//
//  WQBBSTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQPeopleListModel;
@interface WQBBSTableViewCell : UITableViewCell
@property (nonatomic, strong) WQPeopleListModel *model;
// 底部分隔线
@property (nonatomic, strong) UIView *bottomLineView;

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
@end
