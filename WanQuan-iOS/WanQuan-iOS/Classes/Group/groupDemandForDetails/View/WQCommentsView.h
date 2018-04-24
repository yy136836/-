//
//  WQCommentsView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCommentsView,WQTextField;

@protocol WQCommentsViewDelegate <NSObject>

- (void)wqCommentsTextField:(WQCommentsView *)commentsView commentsContentString:(NSString *)commentsContent;

@end

@interface WQCommentsView : UIView

@property (nonatomic, weak) id<WQCommentsViewDelegate>delegate;
// 评论的输入框
@property (nonatomic, strong) WQTextField *commentsTextField;
@end
