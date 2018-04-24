//
//  WQJoinAlumniPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQJoinAlumniPopupWindowView;

@protocol WQJoinAlumniPopupWindowViewDelegate <NSObject>

/**
 申请加入的响应事件

 @param view self
 */
- (void)wqImmediatelyToJoinBtnClick:(WQJoinAlumniPopupWindowView *)view;

/**
 x号按钮的响应事件

 @param view self
 */
- (void)wqDeleteBtnClick:(WQJoinAlumniPopupWindowView *)view;

@end

@interface WQJoinAlumniPopupWindowView : UIView

@property (nonatomic, weak) id <WQJoinAlumniPopupWindowViewDelegate> delegate;

/**
 圈组名称
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 圈组头像
 */
@property (nonatomic, strong) UIImageView *headPortraitImageView;;

/**
 高斯模糊
 */
@property (nonatomic, strong) UIImageView *fuzzyImageView;

@end
