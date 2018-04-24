//
//  WQUnreadMessageCenter.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUnreadMessageCenter.h"
#import <IEMChatManager.h>
@implementation WQUnreadMessageCenter



#pragma mark - public
#pragma mark - common
+ (void)messageRecieved:(EMMessage *)message {
    //必须在数据处理完成时才能发通知
    
    
    //    @property (nonatomic, copy) NSString *messageId;
    //    @property (nonatomic, copy) NSString *conversationId;
    //    @property (nonatomic) EMMessageDirection direction;
    //    @property (nonatomic, copy) NSString *from;
    //    @property (nonatomic, copy) NSString *to;
    
    
    
    //订单临时消息的 ext
    //    {
    //        "from_name" = "王芷妍";
    //        "from_pic" = e6e330fc0ac948f6b46e4cd4c1ac6f57;
    //        isBidTureName = 1;
    //        "is_bidding" = 0;
    //        istruename = 1;
    //        nbid = eaae16d342e14aa3ba6106b35147efd37a8aa313754940869996c8206af2b3be;
    //        "need_owner_id" = a540b005bd834cfd90ddd3145661b737;
    //        nid = eaae16d342e14aa3ba6106b35147efd3;
    //        "to_name" = "韩扬";
    //        "to_pic" = 6698d58f23144f069ec9d7bea1927721;
    //        type = need;
    //    }
    
    
    //订单进行时的消息 的 ext
    //    {
    //        "from_name" = "王芷妍";
    //        "from_pic" = e6e330fc0ac948f6b46e4cd4c1ac6f57;
    //        isBidTureName = 1;
    //        "is_bidding" = 1;
    //        istruename = 1;
    //        nbid = eaae16d342e14aa3ba6106b35147efd37a8aa313754940869996c8206af2b3be;
    //        "need_owner_id" = a540b005bd834cfd90ddd3145661b737;
    //        nid = eaae16d342e14aa3ba6106b35147efd3;
    //        "to_name" = "韩扬";
    //        "to_pic" = 6698d58f23144f069ec9d7bea1927721;
    //        type = need;
    //    }
    
    //    //好友的对话
    //    {
    //        "from_name" = "王芷妍";
    //        "from_pic" = e6e330fc0ac948f6b46e4cd4c1ac6f57;
    //        isBidTureName = 1;
    //        "is_bidding" = 1;
    //        istruename = 1;
    //        "to_name" = "韩扬";
    //        "to_pic" = 6698d58f23144f069ec9d7bea1927721;
    //    }
    
    //    @"friend_chat"
    //    @"need_chat"
    
    [self resetDefaults];
    
    //    首先判断该订单是否是好友信息,好友信息里面没有 nid 字段
    
    
    
    NSDictionary * ext = message.ext;
    
    if (ext[@"nid"]) {
        [self distinguishBid:message];
        return;
    }
    
    [self saveMessage:message];
    
    NSDictionary * fchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
    NSDictionary * nchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:message];
    NSDictionary *dict = @{@"message":message};
    [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:self userInfo:dict];
}



+ (void)distinguishBid:(EMMessage *)message {
    
    
    //    secretkey true string 00dd0fb115c44dd9956be31653aad688 用户密钥
    //    nid true string 4019d85290f64c64b0e9ce18988a350e 需求ID，一般从需求列表中获得
    NSDictionary * ext = message.ext;
    NSString * nid = ext[@"nid"];
    
    NSDictionary * param = @{
                             @"secretkey":[[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"],
                             @"nid":nid
                             };
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:@"api/need/getneedinfo" parameters:param completion:^(id response, NSError *error) {
        
        if (!error) {
            if ([response[@"category_level_1"] isEqualToString:@"BBS"]) {
                return;
            }
            
            [self saveMessage:message];
            
            NSDictionary * fchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
            NSDictionary * nchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
            
            
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:message];
            NSDictionary *dict = @{@"message":message};
            [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:self userInfo:dict];
        }
        
    }];
    
    
}


+ (void)messageRead:(EMMessage *)message {
    //必须在数据处理完成时才能发通知
    
    
    
    
    [self removeMessage:message];
    
    NSDictionary * fchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
    NSDictionary * nchat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSDictionary *dict = @{@"message":message};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:self userInfo:dict];
}



#pragma mark - friendChat

+ (BOOL)haveUnreadFriendMessage {
    
    
    BOOL ret = NO;
    NSArray * conversations = [[EMClient sharedClient].chatManager getAllConversations];
    for (EMConversation * conversation in conversations) {
        NSMutableDictionary * conversationMessageInfo;
        NSArray * allMessages = [conversation loadMoreMessagesFromId:nil limit:MAXFLOAT direction:EMMessageSearchDirectionUp];
        
        for (EMMessage * message in allMessages) {
            NSDictionary * ext = message.ext;
            if (message.isRead) {
                continue;
                
            }
            if (![ext[@"nid"] length] && !message.isRead){
                ret = YES;
            }
        }
    }

    return ret;
}

+ (NSInteger)unreadFiendChatWithConversationId:(NSString *)conversationId {
    
    NSDictionary * fChats = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
    if (fChats[conversationId]) {
        
        return  [fChats[conversationId] integerValue];
    }
    return 0;
}


#pragma mark - bill

/**
 是否还有未读的订单消息 //tabbar使用
 
 @return  是否还有未读的订单消息
 */
+ (BOOL)haveUnreadBidChat {
    //    NSArray * arr =  [EMClient sharedClient].chatManager.getAllConversations;
    //
    //    __block BOOL have = NO;
    //
    //    for (EMConversation * conver in arr) {
    //        [conver loadMessagesStartFromId:nil count:1000 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
    //            for (EMMessage * message in aMessages) {
    //                NSDictionary * dic =message.ext;
    //                if ([dic[@"nid"] length]) {
    //                    if(!message.isRead) {
    //                        have = YES;
    //                        return;
    //                    }
    //                }
    //            }
    //
    //        }];
    //    }
    //    return have;
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    return dic.count;
}





/**
 是否我发的订单还有未读消息 //我的页面使用
 @param myId 我的 id
 @return  是否还有未读的已发订单的消息
 */
+ (BOOL)MYBILL_haveUnreadBidChatWithMyId:(NSString *)myId {
    
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * key in bidChat.allKeys) {
        
        if ([bidChat[key] hasPrefix:myId]) {
            return YES;
        }
    }
    
    return NO;
}




/**
 是否有我发的订单待选定的未读临时消息
 
 @param myId 我的 id
 @return 是否还有待选定的未读订单临时消息
 */
+ (BOOL)MYBILL_haveUnreadToSelectChatWithMyId:(NSString *)myId {
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * key in bidChat.allKeys) {
        
        if (key.length == 64 && [bidChat[key] hasPrefix:myId]) {
            return YES;
        }
    }
    
    return NO;
}


/**
 是否有我发的订单已选定的未读订单消息
 
 @param myId 我的 id
 @return 是否还有已选定的未读订单消息
 */
+ (BOOL)MYBILL_haveUnreadSelfBelongOnBidingChatWithMyId:(NSString *)myId {
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * key in bidChat.allKeys) {
        
        if (key.length == 32 && [bidChat[key] hasPrefix:myId]) {
            return YES;
        }
    }
    
    return NO;
}



/**
 我接的订单是否还有未读的订单消息 //我的页面使用
 
 @return  我接的订单是否还有未读的订单消息
 */

+ (BOOL)OTHERSBILL_haveUnreadAcceptedBidChatWithMyId:(NSString *)myId {
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * value in bidChat.allValues) {
        if (![value hasPrefix:myId]) {
            return YES;
        }
    }
    return NO;
}



/**
 我接的订单已抢单是否还有未读的订单消息 //我的页面使用
 
 @return  我接的订单已抢单是否还有未读的订单消息
 */

+ (BOOL)OTHERSBILL_haveUnreadYiQiangdanChatWithMyId:(NSString *)myId {
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * key in bidChat.allKeys) {
        if ((![bidChat[key] hasPrefix:myId]) && key.length == 64) {
            return YES;
        }
    }
    return NO;
}


/**
 我接的订单进行中的是否还有未读的订单消息 //我的页面使用
 
 @return  我接的订单进行中的是否还有未读的订单消息
 */

+ (BOOL)OTHERSBILL_haveUnreadBidingChatWithMyId:(NSString *)myId {
    if (!myId) {
        myId = [EMClient sharedClient].currentUsername;
    }
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    for (NSString * key in bidChat.allKeys) {
        if ((![bidChat[key] hasPrefix:myId]) && key.length == 32) {
            return YES;
        }
    }
    return NO;
}


/**
 某条订单是否有未读消息
 
 @param bidId 该订单的 id
 @return 某条订单是否有未读消息
 */
+ (BOOL)haveUnreadMessageForBid:(NSString *)bidId {
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    for (NSString * key in bidChat.allKeys) {
        if ([key hasSuffix:bidId]) {
            return YES;
        }
    }
    return NO;
}


/**
 订单是否还有未读的临时会话
 
 @param bidId 该订单的 id
 @return 我接的订单是否还有未读的临时会话
 */
+ (BOOL)haveUnreadTmpChatForBid:(NSString *)bidId {
    
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    for (NSString * key in bidChat.allKeys) {
        if ([key hasSuffix:bidId] && key.length == 64) {
            return YES;
        }
    }
    return NO;
}

/**
 订单是否还有未读的交易会话
 
 @param bidId 该订单的 id
 @return 我接的订单是否还有未读的交易会话
 */
+ (BOOL)haveUnreadBidChatForBid:(NSString *)bidId {
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    for (NSString * key in bidChat.allKeys) {
        if ([key isEqualToString:bidId]) {
            return YES;
        }
    }
    return NO;
}



+ (BOOL)haveUnreadMessageForBid:(NSString *)bidId withChater:(NSString *)chaterId {
    NSDictionary * bidChat = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    for (NSString * key in bidChat.allKeys) {
        if ([key isEqualToString:bidId] && [bidChat[key] hasSuffix:chaterId]) {
            return YES;
        }
    }
    return NO;
    
}


#pragma mark - tempChat

+ (NSArray *)allTempChatBidIds {
    NSDictionary * info = [[NSUserDefaults standardUserDefaults] objectForKey:WQTempChatBidIdKey];
    NSArray * ret = info.allKeys;
    
    return ret;
}

+ (NSDictionary *)allTempChatInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:WQTempChatBidIdKey];
    
}

+ (void)saveTempChatBid:(NSString *)bid withChatter:(NSString *)chaterId{
    NSDictionary *  ret = [self allTempChatInfo];
    if (!ret.count) {
        ret = @{};
    }
    NSMutableDictionary * newInfo = ret.mutableCopy;
    
    for (NSInteger i = 0 ; i < newInfo.allKeys.count; ++ i) {
        NSString * oneBid = newInfo.allKeys[i];
        if ([bid isEqualToString:oneBid]) {
            NSMutableArray * oneNeedChatters = [newInfo[oneBid] mutableCopy];
            [oneNeedChatters addObject:chaterId];
            
            newInfo[bid] = oneNeedChatters;
            [[NSUserDefaults standardUserDefaults] setObject:newInfo forKey:WQTempChatBidIdKey];
            return;
        }
    }
    
    newInfo[bid] = @[chaterId];
    [[NSUserDefaults standardUserDefaults] setObject:newInfo forKey:WQTempChatBidIdKey];
}

+ (BOOL)haveUnreadTemChatITalkedTo{
    NSDictionary * bidChats = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    NSArray * needOwners = bidChats.allKeys;
    
    NSString * myId = [EMClient sharedClient].currentUsername;
    if (!myId) {
        return NO;
    }
    BOOL haveTemp = NO;
    for (NSString * needOwner in needOwners) {
        if (([needOwner rangeOfString:myId].location == NSNotFound) && needOwner.length > 32 && (![bidChats[needOwner] isEqualToString:myId])) {
            haveTemp = YES;
        }
    }
    
    return haveTemp;
}


+ (void)removeTempChatAboutBid:(NSString *)bid {
    NSDictionary * bidChats = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    
    NSArray * needOwners = bidChats.allValues;
    
    NSString * myId = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
    
    NSMutableDictionary * new = bidChats.mutableCopy;
    
    [new removeObjectForKey:@"bid"];
    
    [[NSUserDefaults standardUserDefaults] setObject:bidChats forKey:WQBidChatKey];
}
#pragma mark - private
/**
 在本地按照相关的规则存储收到的消息
 
 @param message 收到的消息
 */
+ (void)saveMessage:(EMMessage *)message {
    
    NSDictionary * ext = message.ext;
    if (![ext[@"nid"] length]) {
        [self handleRecievedFriendChat:message];
        
        //        如果含有订单信息则该条会话是和订单相关的对话
    } else {
        
        //        在判断这条会话是否是订单的询问,即未接单的临时会话 ext[@"is_bidding"] 记录的值为该条订单是否处于交易状态
        if ([ext[@"is_bidding"] integerValue] == 1) {
            
            
            [self handleRecievedBidingNeedChat:message];
            
            //        在判断这条会话是否是订单的询问,即未接单的临时会话 ext[@"is_bidding"] 记录的值为该条订单是否处于交易状态
        } else {
            [self handleRecievedTempNeedChat:message];
        }
        
    }
    
    
}

/**
 当消息被阅读后删除相关的未读消息信息
 
 @param message 阅读过的消息
 */
+ (void)removeMessage:(EMMessage *)message {
    
    NSDictionary * ext = message.ext;
    
    if (![ext[@"nid"] length]) {
        [self handleReadFriendMessage:message];
        
        //        如果含有订单信息则该条会话是和订单相关的对话
    } else {
        
        //        在判断这条会话是否是订单的询问,即未接单的临时会话 ext[@"is_bidding"] 记录的值为该条订单是否处于交易状态
        if ([ext[@"is_bidding"] integerValue] == 1) {
            
            [self handleReadBidingMessage:message];
            //        在判断这条会话是否是订单的询问,即未接单的临时会话 ext[@"is_bidding"] 记录的值为该条订单是否处于交易状态
        } else {
            
            [self handeReadTempMessage:message];
        }
    }
}



/**
 因为之前的 userdefaults 里面可能存有本不该提示的数据,可能会导致新存的数据互相混淆所以在最开始先对 userdefaults 进行初始化
 */
+(void)resetDefaults {
    
    //    删掉之前版本的红点相关的数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"friend_chat"]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"friend_chat"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"need_chat"]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"need_chat"];
    }
    
    //    如果之前没有接收到过未读消息为该消息初始化 defaults;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@{}
                                                  forKey:WQBidChatKey];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@{}
                                                  forKey:WQFriendChatKey];
    }
}



/**
 处理收到的好友消息
 处理的策略是:该条消息所属的会话 id 作为键 未读消息的数量作为值
 @param message 待处理的消息
 */
+ (void)handleRecievedFriendChat:(EMMessage *)message {
    NSDictionary * old = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
    NSMutableDictionary * new = old.mutableCopy;
    
    NSNumber * newCount = @0;
    
    //        当存储 friend对话记录的字典里面没有当前会话则说明该会话未读消息数为0 应创建该条消息对应的字段并将值改为@1
    if(!new[message.conversationId]) {
        
        newCount = @1;
    }else {
        
        //          如果当前存储内包含该会话的未读消息则应将字段对应的值 +1
        NSInteger oldCount = [new[message.conversationId] integerValue];
        newCount =  @(++ oldCount);
    }
    
    new[message.conversationId] = newCount;
    [[NSUserDefaults standardUserDefaults] setObject:new forKey:WQFriendChatKey];
}


/**
 处理收到的交易中未读消息
 
 处理的策略是:订单的 id 作为键, 该条消息的needOnwerid
 [nidChatDict setObject:needOwnerId forKey:nid];
 
 1,当 needOwnerId 为自己时该消息属于自己自己所发的订单的消息
 1.1, 当 key 为64位是还未开始订单的消息
 1.2, 当 key 为32位是已经开始交易的消息
 1.3, 字典的值为当前对话人的 id
 
 
 
 @param message 待处理的订单消息
 */
+ (void)handleRecievedBidingNeedChat:(EMMessage *)message {
    
    NSString * nid = message.ext[@"nid"];
    NSString * from = message.from;
    NSString * needOwnerId = message.ext[@"need_owner_id"];
    
    NSDictionary * oldNeeds = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSMutableDictionary * newNeeds = oldNeeds.mutableCopy;
    newNeeds[nid] =[NSString stringWithFormat:@"%@%@", needOwnerId,from];
    
    [[NSUserDefaults standardUserDefaults] setObject:newNeeds forKey:WQBidChatKey];
}



/**
 处理收到的还未开始交易的订单未读消息
 
 处理的策略是:订单的 id + 订单所属人的 id 作为键, 该条消息的来源作为值
 
 [nidChatDict setObject:needOwnerId forKey:[from stringByAppendingString:nid]];
 
 1,当 needOwnerId 为自己时该消息属于自己自己所发的订单的消息
 1.1, 当 key 为64位是还未开始订单的消息
 1.2, 当 key 为32位是已经开始交易的消息
 1.3, 字典的值为当前对话人的 id
 
 @param message 待处理的订单消息
 */
+ (void)handleRecievedTempNeedChat:(EMMessage *)message {
    
    NSString * from = message.from;
    NSString * nid = message.ext[@"nid"];
    NSString * needOwnerId = message.ext[@"need_owner_id"];
    
    NSDictionary * oldNeeds = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSMutableDictionary * newNeeds = oldNeeds.mutableCopy;
    // MARK: 发消息的人的 ID + 订单的 ID : 发单者的 ID
    newNeeds[[from stringByAppendingString:nid]] = needOwnerId;
    [[NSUserDefaults standardUserDefaults] setObject:newNeeds forKey:WQBidChatKey];
    
}


/**
 处理已读的好友消息
 
 @param message  处理已读的好友消息
 */
+ (void)handleReadFriendMessage:(EMMessage *)message {
    
    NSDictionary * oldFriendChats = [[NSUserDefaults standardUserDefaults] objectForKey:WQFriendChatKey];
    NSMutableDictionary * newFriendChats = oldFriendChats.mutableCopy;
    
    if ([newFriendChats objectForKey:message.conversationId]) {
        [newFriendChats removeObjectForKey:message.conversationId];
        [[NSUserDefaults standardUserDefaults] setValue:newFriendChats forKey:WQFriendChatKey];
        return;
    }
    
}


/**
 处理交易中的已读订单消息
 
 @param message 处理交易中的已读订单消息
 */
+ (void)handleReadBidingMessage:(EMMessage *)message {
    NSDictionary * oldBidng = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSMutableDictionary * newBiding = oldBidng.mutableCopy;
    if (newBiding.count) {
        NSArray * keys = newBiding.allKeys;
        
        for (NSString * key in keys) {
            if ([key isEqualToString:message.ext[@"nid"]]) {
                [newBiding removeObjectForKey:key];
                [[NSUserDefaults standardUserDefaults] setObject:newBiding forKey:WQBidChatKey];
                return;
            }
        }
    }
}

+ (void)handeReadTempMessage:(EMMessage *)message {
    NSDictionary * oldBidng = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSMutableDictionary * newBiding = oldBidng.mutableCopy;
    if (newBiding.count) {
        NSArray * keys = newBiding.allKeys;
        
        for (NSString * key in keys) {
            if ([key hasSuffix:message.ext[@"nid"]] && key.length == 64) {
                [newBiding removeObjectForKey:key];
                [[NSUserDefaults standardUserDefaults] setObject:newBiding forKey:WQBidChatKey];
                return;
            }
        }
    }
}


+ (void)removeMessagesAboutBid:(NSString *)bid {
    NSDictionary * oldBidng = [[NSUserDefaults standardUserDefaults] objectForKey:WQBidChatKey];
    NSMutableDictionary * newBiding = oldBidng.mutableCopy;
    
    for (NSString * key in oldBidng) {
        if ([key hasSuffix:bid]) {
            [newBiding removeObjectForKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newBiding forKey:WQBidChatKey];
}


@end
