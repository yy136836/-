//
//  WQReleaseFriendsCirclePromptView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQReleaseFriendsCirclePromptView;

@protocol WQReleaseFriendsCirclePromptViewDelegate <NSObject>

/**
 x号的响应事件
 @param promptView
 */
- (void)wqDeleteBtnClickCirclePromptView:(WQReleaseFriendsCirclePromptView *)promptView;
@end

@interface WQReleaseFriendsCirclePromptView : UIView

@property (nonatomic, weak) id <WQReleaseFriendsCirclePromptViewDelegate> delegate;

@end
