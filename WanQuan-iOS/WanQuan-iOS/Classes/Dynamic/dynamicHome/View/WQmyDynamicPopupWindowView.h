//
//  WQmyDynamicPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
  
@class WQmyDynamicPopupWindowView;

@protocol WQmyDynamicPopupWindowViewDelegate <NSObject>

/**
 我的动态的响应事件

 @param view self
 */
- (void)wqDynamicBtnClick:(WQmyDynamicPopupWindowView *)view;

/**
 我参与的

 @param view self
 */
- (void)wqParticipateBtnClick:(WQmyDynamicPopupWindowView *)view;

@end

@interface WQmyDynamicPopupWindowView : UIView

@property (nonatomic, weak) id <WQmyDynamicPopupWindowViewDelegate> delegate;

@end
