//
//  WQCommentsInputView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCommentsInputView;

@protocol WQCommentsInputViewDelegate <NSObject>

/**
 return的响应事件

 @param commentsView self
 @param commentsContent 评论内容
 */
- (void)wqCommentsTextField:(WQCommentsInputView *)commentsView commentsContentString:(NSString *)commentsContent;

/**
 开始编辑的响应事件

 @param commentsView self
 */
- (void)wqStartEditing:(WQCommentsInputView *)commentsView;
@end

@interface WQCommentsInputView : UIView

@property (nonatomic, weak) id <WQCommentsInputViewDelegate> delagate;

@property (nonatomic, copy) void(^wqChangeHeightBlock)(CGFloat h);

/**
 评论的输入框
 */
@property (nonatomic, strong) UITextView *commentsTextView;

/**
 书写图标
 */
@property (nonatomic, strong) UIImageView *writingTwoImageView;

@end
