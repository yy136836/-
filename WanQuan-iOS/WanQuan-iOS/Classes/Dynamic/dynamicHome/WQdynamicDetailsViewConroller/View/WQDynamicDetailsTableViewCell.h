//
//  WQDynamicDetailsTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicDetailsTableViewCell,WQDynamicDetailsToolBarView,WQparticularsModel,WQdynamicUserInformationView;

@protocol WQDynamicDetailsTableViewCellDelegate <NSObject>

/**
 头像的响应事件

 @param view WQdynamicUserInformationView
 @param cell self
 */
- (void)wqUser_picImageViewClick:(WQdynamicUserInformationView *)view cell:(WQDynamicDetailsTableViewCell *)cell;

/**
 鼓励的响应事件
 
 @param toolBarView WQDynamicDetailsToolBarView
 @param cell self
 */
- (void)wqPlayTourBtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell;

/**
 赞的响应事件

 @param toolBarView WQDynamicDetailsToolBarView
 @param cell self
 */
- (void)wqUnlikeBtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell;

/**
 踩的响应事件

 @param toolBarView WQDynamicDetailsToolBarView
 @param cell self
 */
- (void)wqRetweetbtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell;

@end

@interface WQDynamicDetailsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WQDynamicDetailsTableViewCellDelegate> delegate;

@property (nonatomic, strong) WQparticularsModel *model;

@end
