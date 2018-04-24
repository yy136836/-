//
//  WQGroupDynamicTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupDynamicHomeModel,WQGroupDynamicTableViewCell,WQThemeImageView;

@protocol WQGroupDynamicTableViewCellDelegate <NSObject>

/**
 点击头像

 @param groupDynamicTableViewCell self
 */
- (void)wqGroupDynamicTableViewCellHeadPortraitCliek:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell;

/**
 链接的响应事件

 @param groupDynamicTableViewCell self
 */
- (void)wqLinksContentViewClick:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell;

/**
 活动的响应事件

 @param groupDynamicTableViewCell self
 */
- (void)wqActlvltyViewClick:(WQGroupDynamicTableViewCell *)groupDynamicTableViewCell;

@end

@interface WQGroupDynamicTableViewCell : UITableViewCell
@property (nonatomic, weak) id <WQGroupDynamicTableViewCellDelegate> delegate;

/**
 模型
 */
@property (nonatomic, strong) WQGroupDynamicHomeModel *model;

/**
 图片
 */
@property (nonatomic, strong) WQThemeImageView *picView;

@end
