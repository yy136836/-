//
//  WQDynamicDetailsToolBarView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicDetailsToolBarView;

@protocol WQdynamicTableViewCellDelegate <NSObject>

/**
 踩的响应事件

 @param toolBarView self
 */
- (void)wqRetweetbtnClike:(WQDynamicDetailsToolBarView *)toolBarView;

/**
 赞的响应事件

 @param toolBarView self
 */
- (void)wqUnlikeBtnClike:(WQDynamicDetailsToolBarView *)toolBarView;

/**
 鼓励的响应事件

 @param toolBarView self
 */
- (void)wqPlayTourBtnClike:(WQDynamicDetailsToolBarView *)toolBarView;

@end

@interface WQDynamicDetailsToolBarView : UIView

@property (nonatomic, weak) id <WQdynamicTableViewCellDelegate> delegate;

/**
 赞
 */
@property (nonatomic, strong) UIButton *unlikeBtn;

/**
 踩
 */
@property (nonatomic, strong) UIButton *retweetbtn;

/**
 发布时间
 */
@property (nonatomic, strong) UILabel *releaseTimeLabel;

@end
