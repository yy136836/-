//
//  WQTabBarController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQTabBarController : UITabBarController<UITabBarControllerDelegate>

/**
 是否有订单的推送的消息需要进一步的处理
 */
@property (nonatomic, assign)BOOL haveBidInfoToDealWith;


/**
  是否有系统消息
 */
@property (nonatomic, assign)BOOL haveSystemInfoToDealWith;

/**
 是否有新的评论
 */
@property (nonatomic, assign)BOOL haveCommentInfoToDealWith;

/**
 是否有新的消息(仅系统)
 */
@property (nonatomic, assign)BOOL haveMessageInfoToDealWith;

/**
 是否有入圈申请
 */
@property (nonatomic, assign)BOOL haveGroupApply;


/**
 是否有新的赞
 */
@property (nonatomic, assign) BOOL haveLikeTodealWith;


/**
 是否有圈消息
 */
@property (nonatomic, assign)BOOL haveCircleEvent;


/**
 是否有好友请求
 */
@property (nonatomic, assign) BOOL haveFriendapply;




// 统计未读消息数
-(void)setupUnreadMessageCount:(EMMessage *)message;

-(void)setupNewFriendApplies;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;


//- (void)showBadgeOnItemIndex:(int)index;
//- (void)hideBadgeOnItemIndex:(int)index;

@end
