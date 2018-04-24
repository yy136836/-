//
//  WQICanHelpTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQICanHelpTableViewCell,WQHomeNearby;

@protocol WQICanHelpTableViewCellDelegate <NSObject>

- (void)wqICanHelpTableViewCell:(WQICanHelpTableViewCell *)cell askBtnClike:(UIButton *)askBtn;
- (void)wqICanHelpTableViewCell:(WQICanHelpTableViewCell *)cell helpBtnClike:(UIButton *)helpBtn;

@end

@interface WQICanHelpTableViewCell : UITableViewCell

@property (nonatomic, weak) id<WQICanHelpTableViewCellDelegate>delegate;
@property (nonatomic, strong) WQHomeNearby *model;

/**
 询问按钮
 */
@property (nonatomic, strong) UIButton *askBtn;

/**
 我能帮助按钮
 */
@property (nonatomic, strong) UIButton *helpBtn;

/**
 投诉按钮
 */
@property (nonatomic, strong) UIButton *feedbackBtn;

/**
 我的订单
 */
@property (nonatomic, strong) UIButton *myOrderBtn;

@end
