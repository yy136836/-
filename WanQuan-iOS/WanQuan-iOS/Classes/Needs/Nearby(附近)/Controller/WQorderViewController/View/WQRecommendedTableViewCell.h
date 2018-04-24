//
//  WQRecommendedTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQRecommendedTableViewCell,WQGroupModel;

@protocol WQRecommendedTableViewCellDelegate <NSObject>

/**
 加入按钮的响应事件

 @param cell self
 */
- (void)wqJoinBtnClickRecommendedTableViewCell:(WQRecommendedTableViewCell *)cell;

/**
 点击头像

 @param cell self
 */
- (void)wqGroupHeadPortraitimageViewTableViewCell:(WQRecommendedTableViewCell *)cell;
@end

@interface WQRecommendedTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQRecommendedTableViewCellDelegate> delegate;
@property (nonatomic, strong) WQGroupModel *model;
@property (nonatomic, copy) NSString *groupDescription;

@end
