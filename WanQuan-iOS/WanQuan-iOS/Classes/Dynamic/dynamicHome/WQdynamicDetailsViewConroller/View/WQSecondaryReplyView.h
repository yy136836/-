//
//  WQSecondaryReplyView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/12.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSecondaryReplyView;

@protocol WQSecondaryReplyViewDelegate <NSObject>

/**
 label的响应事件
 
 @param view self
 */
- (void)wqTagLabelTap:(WQSecondaryReplyView *)view;

/**
 label的响应事件

 @param view self
 */
- (void)wqTwoTagLabelTap:(WQSecondaryReplyView *)view;

/**
 回复数量的响应事件

 @param view self
 */
- (void)wqReplyNumberLabelTap:(WQSecondaryReplyView *)view;

@end

@interface WQSecondaryReplyView : UIView

@property (nonatomic, weak) id <WQSecondaryReplyViewDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger comment_children_count;

@end
