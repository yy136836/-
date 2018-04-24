//
//  WQDynamicDetailsPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/2.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQDynamicDetailsPopupWindowView;

@protocol WQDynamicDetailsPopupWindowViewDelegate <NSObject>

/**
 弹窗背景的响应事件

 @param view self
 */
- (void)wqDynamicDetailsPopupWindowViewClick:(WQDynamicDetailsPopupWindowView *)view;

/**
 收藏的响应事件

 @param view self
 */
- (void)wqScBtnClick:(WQDynamicDetailsPopupWindowView *)view;

/**
 举报的响应事件

 @param view self
 */
- (void)wqReportBtnClick:(WQDynamicDetailsPopupWindowView *)view;

/**
 删除的响应事件

 @param view self
 */
- (void)wqDeleteBtnClick:(WQDynamicDetailsPopupWindowView *)view;

@end

@interface WQDynamicDetailsPopupWindowView : UIView

@property (nonatomic, weak) id <WQDynamicDetailsPopupWindowViewDelegate> delegate;

/**
 是否显示删除按钮
 */
@property (nonatomic, assign) BOOL isDeleteBtn;

/**
 收藏的按钮
 */
@property (nonatomic, strong) UIButton *scBtn;

@end
