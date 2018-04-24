//
//  WQSearchView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSearchView;

@protocol WQSearchViewDelegate <NSObject>

/**
 取消的响应事件

 @param searchView self
 */
- (void)wqSearchViewCancelBtnClick:(WQSearchView *)searchView;

/**
 X号的响应事件

 @param searchView self
 */
- (void)wqDeleteClick:(WQSearchView *)searchView;

@end

@interface WQSearchView : UIView

@property (nonatomic, weak) id <WQSearchViewDelegate> delegate;

/**
 搜索框
 */
@property (nonatomic, strong) UITextField *searchTextField;

/**
 X的按钮
 */
@property (nonatomic, strong) UIButton *xBtn;

@end
