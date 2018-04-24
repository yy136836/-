//
//  WQPeopleWhoAreInterestedInTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPeopleWhoAreInterestedInTableViewCell;

@protocol WQPeopleWhoAreInterestedInTableViewCellDelegate <NSObject>

/**
 头像的响应事件  游客登录时调用!

 @param cell self
 */
- (void)wqHeadPortraitClick:(WQPeopleWhoAreInterestedInTableViewCell *)cell;

/**
 关注按钮的响应事件  游客登录时调用!

 @param cell self
 */
- (void)wqGuanzhuBtnTouristsClick:(WQPeopleWhoAreInterestedInTableViewCell *)cell;

@end

@interface WQPeopleWhoAreInterestedInTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQPeopleWhoAreInterestedInTableViewCellDelegate> delegate;

/**
 数据模型
 */
@property (nonatomic, strong) NSArray *dataArray;

@end
