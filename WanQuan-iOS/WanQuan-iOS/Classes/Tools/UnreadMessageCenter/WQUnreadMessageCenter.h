//
//  WQUnreadMessageCenter.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMMessage;



/**
 预留我发的订单状态,暂时还没用
 */
typedef NS_ENUM(NSInteger, SelfBelongBidStauts) {
//    待选定
    SelfBelongBidStautsBeforSelect,
//    交易中
    SelfBelongBidStautsOnBiding,
//    已完成
    SelfBelongBidStautsComplete
};


/**
 预留我接的订单状态,暂时还没用
 */

typedef NS_ENUM(NSInteger, TockenBidStauts) {
    //    已抢单
    TockenBidStautsUnaccepted,
    //    交易中
    TockenBidStautsOnBiding,
    //    已完成
    TockenBidStautsComplete
};



/**
 该类用于管理所有未读消息,包括刷新消息路径上的标记状态(红点),以及未读消息的本地存储,
 本地对未读消息的存储分为两大类,一类是好友消息
 
 存储策略:以字典的形式存到 KEY 为 WQFriendChatKey 的字典内
         基本的形式是 WQFriendChatKey : {
                                       conversationId1:@(UNReadNumber),
                                       conversationId2:@(UNReadNumber),
                                       .......
                                      }
         
 
 另外一类是订单相关的消息:
 订单相关的消息根据自己为接单人及发单人来区分为两种
 1.我发的订单
 1.1,我发的订单还未选定询问的人
 1.2,我发的订单已选定询问的人,订单正在进行
 1.3,我发的订单,订单已完成
 
 2.我接的订单
 2.1,已经抢单
 2.2,发单人接受抢单,任务处于进行状态
 2.3,任务已完成的状态
 
 
 */
@interface WQUnreadMessageCenter : NSObject


@property(nonatomic,copy,class) NSString * myUserId;
/**
 当收到消息时首先应该将收到的消息的一些信息储存下来,
 首先判断该消息是好友消息还是和订单相关的消息分别存储,
 然后发通知来通知相关的路径提示该消息(红点)
 
 @param message 收到的该条消息对象
 */
+ (void)messageRecieved:(EMMessage *)message;

/**
 当未读消息被标记为已读状态
 
 @param message 首先判断该消息是好友消息还是和订单相关的消息分别从本地移除,
 然后发通知来通知相关的路径提示该消息(红点)自己去判断是否应该隐藏红点
 */
+ (void)messageRead:(EMMessage *)message;

@end


/**
 获得未读的好友消息的信息
 */
@interface WQUnreadMessageCenter (friendChat)



/**
 是否还有未读的好友消息// tabbar显示红点

 @return 是否还有未读的好友消息
 */
+ (BOOL)haveUnreadFriendMessage;

/**
 是否还有未读的订单消息// tabbar显示红点
 
 @return 是否还有未读的订单消息
 */
+ (BOOL)haveUnreadBidChat;

/**
 获得未读的好友消息数量
 
 @param conversationId 该会话的 id
 @return  与该好友之间对话的未读消息的数量
 */
+ (NSInteger)unreadFiendChatWithConversationId:(NSString *)conversationId;
@end


/**
 获得我发的订单的信息
 */
@interface WQUnreadMessageCenter (bill)

+ (BOOL)MYBILL_haveUnreadBidChatWithMyId:(NSString *)myId;
+ (BOOL)MYBILL_haveUnreadToSelectChatWithMyId:(NSString *)myId;
+ (BOOL)MYBILL_haveUnreadSelfBelongOnBidingChatWithMyId:(NSString *)myId;

+ (BOOL)OTHERSBILL_haveUnreadAcceptedBidChatWithMyId:(NSString *)myId;
+ (BOOL)OTHERSBILL_haveUnreadYiQiangdanChatWithMyId:(NSString *)myId;
+ (BOOL)OTHERSBILL_haveUnreadBidingChatWithMyId:(NSString *)myId;


/**
 某条订单是否有未读消息

 @param bidId 该订单的 id
 @return 某条订单是否有未读消息
 */
+ (BOOL)haveUnreadMessageForBid:(NSString *)bidId;



/**
 某订单是否有未读的临时消息

 @param bidId 该订单的 id
 @return 某订单是否有未读的消息
 */
+ (BOOL)haveUnreadTmpChatForBid:(NSString *)bidId;

/**
 某订单是否有未读的交易消息
 
 @param bidId 该订单的 id
 @return 某订单是否有未读的交易消息
 */
+ (BOOL)haveUnreadBidChatForBid:(NSString *)bidId;

/**
 某订单是否有未读的交易消息
 
 @param bidId 该订单的 id
 @param chaterId 该订单的chater 的 id
 @return 某订单是否有未读的交易消息
 */
+ (BOOL)haveUnreadMessageForBid:(NSString *)bidId withChater:(NSString *)chaterId;

+ (void)removeMessagesAboutBid:(NSString *)bid;


/**
 保存下订单临时会话的订单的id

 @param bid 订单的 id
 @param chaterId 发单者的 id
 */
+ (void)saveTempChatBid:(NSString *)bid withChatter:(NSString *)chaterId;

+ (NSArray *)allTempChatBidIds;

+ (NSDictionary *)allTempChatInfo;

+ (BOOL)haveUnreadTemChatITalkedTo;

/**
  删除已被删掉的订单的信息

 @param bid 订单的 id
 */
+ (void)removeTempChatAboutBid:(NSString *)bid;
@end


