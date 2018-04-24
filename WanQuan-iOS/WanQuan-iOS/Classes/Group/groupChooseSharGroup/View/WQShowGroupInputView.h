//
//  WQShowGroupInputView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQShowGroupInputView;

@protocol WQShowGroupInputViewDelegate <NSObject>
// 取消的点击事件
- (void)wqCancelBtnClike:(WQShowGroupInputView *)showGroupInputView;
// 确认的点击事件
- (void)wqSubmitBtnClike:(WQShowGroupInputView *)showGroupInputView;
@end

@interface WQShowGroupInputView : UIView
@property (nonatomic, weak) id<WQShowGroupInputViewDelegate>delegate;

// 输入框
@property (nonatomic, strong) UITextView *textView;
@end
