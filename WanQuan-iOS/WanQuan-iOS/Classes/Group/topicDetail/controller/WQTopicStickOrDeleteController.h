//
//  WQTopicStickOrDeleteController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/25.
//  Copyright © 2017年 WQ. All rights reserved.
//




#import "WQViewController.h"

@protocol WQTopicStickOrDeleteControllerDelegate <NSObject>

/**
 置顶或者取消置顶
 */
- (void)WQTopicStickOrDeleteControllerDelegateStickTopic;

/**
 删除帖子
 */
- (void)WQTopicStickOrDeleteControllerDelegateDeleteTopic;
@end




@interface WQTopicStickOrDeleteController : WQViewController




/**
 是否已经置顶
 */
@property (nonatomic, assign, getter=isSticked) BOOL sticked;

@property (nonatomic, assign) id <WQTopicStickOrDeleteControllerDelegate> delegate;
@end
