/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatHelper.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "WQTabBarController.h"
#import "TTGlobalUICommon.h"
#import "EaseSDKHelper.h"
#import "WQLogInController.h"

static ChatHelper *helper = nil;

@implementation ChatHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}

//- (void)dealloc
//{
//    [[EMClient sharedClient] removeDelegate:self];
//    [[EMClient sharedClient].groupManager removeDelegate:self];
//    [[EMClient sharedClient].contactManager removeDelegate:self];
//    [[EMClient sharedClient].roomManager removeDelegate:self];
//    [[EMClient sharedClient].chatManager removeDelegate:self];
//}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

#pragma mark - setter

- (void)setMainVC:(WQTabBarController *)mainVC
{
    _mainVC = mainVC;
}

#pragma mark - init

- (void)initHelper
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];

    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}

- (void)asyncGroupFromServer
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[EMClient sharedClient].groupManager getJoinedGroups];
//        EMError *error = nil;
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            
        }];
//        [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
//        if (!error) {
//            /*if (weakself.contactViewVC) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakself.contactViewVC reloadGroupView];
//                });
//            }*/
//        }
    });
}

- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            /*if (weakself.conversationListVC) {
                [weakself.conversationListVC refreshDataSource];
            }
            
            if (weakself.mainVC) {
                [weakself.mainVC setupUnreadMessageCount];
            }*/
        });
    });
}

#pragma mark - EMClientDelegate

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    //[self.mainVC networkChanged:connectionState];
}

- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
    } else if([[EMClient sharedClient] isConnected]){
        UIView *view = self.mainVC.view;
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] migrateDatabaseToLatestSDK];
            if (flag) {
//                暂时不需要群组的信息
//                [self asyncGroupFromServer];
                [self asyncConversationFromDB];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            });
        });
    }
}

- (void)userAccountDidLoginFromOtherDevice
{
    [self _clearHelper];
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];*/
    
    
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"您当前的帐号已在其他设备上登录，请您重新登录！" preferredStyle:UIAlertControllerStyleAlert];
    
    ROOT(root);
    [root presentViewController:alertVC animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            WQLogInController *vc = [WQLogInController new];
            
            NSString* appDomain = [[NSBundle mainBundle]bundleIdentifier];
            [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
            
            NSFileManager *fileManager = [NSFileManager  defaultManager];
            if ([fileManager removeItemAtPath:[WQSingleton sharedManager].archivePath error:nil]) {
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            }
        });
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}


- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    if (aConnectionState == EMConnectionConnected) {
        NSLog(@"环信链接已连接");
    }
    
    if (aConnectionState == EMConnectionDisconnected) {
        NSLog(@"环信链接已断开");
    }
}


- (void)userAccountDidRemoveFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)userDidForbidByServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"servingIsBanned", @"Serving is banned") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

//- (void)didServersChanged
//{
//    [self _clearHelper];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}
//
//- (void)didAppkeyChanged
//{
//    [self _clearHelper];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    if (self.conversationListVC) {
        [_conversationListVC refreshDataSource];
    }
}


- (void)didReceiveMessages:(NSArray *)aMessages
{
    _chatVC = nil;
    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        
       
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:message.from type:EMConversationTypeChat createIfNotExist:YES];
        
        
        NSMutableDictionary * coiffedExt = message.ext.mutableCopy;
        
//        conversation.ext = @{};
//        NSDictionary * ext = @{@"group" : str,
//                               @"from_name":fromName,
//                               @"from_pic":fromPic,
//                               @"to_name":model.true_name,
//                               @"to_pic":model.pic_truename,
//                               @"istruename":@(YES),
//                               @"is_bidding":@(YES),
//                               @"isBidTureName":@(YES)};
        
        
        if (![message.ext[@"nid"] length]) {
            
            coiffedExt[@"from_name"] = message.ext[@"from_name"];
            coiffedExt[@"from_pic"] = message.ext[@"from_pic"];
            coiffedExt[@"to_name"] = message.ext[@"to_name"];
            coiffedExt[@"to_pic"] = message.ext[@"to_pic"];
            coiffedExt[@"istruename"] = @(YES);
            coiffedExt[@"is_bidding"] = @(YES);
            coiffedExt[@"isBidTureName"] = @(YES);
            
            if ([message.ext[@"group"] length]) {
                coiffedExt[@"group"] = message.ext[@"group"];
                
            }
            message.ext = coiffedExt;
        } else {
            coiffedExt = message.ext.mutableCopy;
            if (message.ext[@"group"]) {
                [coiffedExt removeObjectForKey:@"group"];
            }
            message.ext = coiffedExt;
            
            NSLog(@"%@",coiffedExt);
            
        }
        
        
        
        
        
        NSMutableDictionary *dict = message.ext.mutableCopy;
        [EaseConversationListViewController updateConversationExt:message conversation:conversation];
        NSString *nid = (dict && [dict objectForKey:@"nid"]) ? [dict objectForKey:@"nid"] : nil;
        [EaseConversationListViewController setLatestMessageTitle:message nid:nid conversation:conversation];
        [ChatHelper updateUnreadStatus:message];
        
        if (_chatVC == nil) {
            _chatVC = [self _getCurrentChatView];
        }
        BOOL chatting = NO;
        if (_chatVC) {
            chatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
        }
        
        if (!chatting) {
            [WQUnreadMessageCenter messageRecieved:message];
        }
        
        
        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        
#ifdef REDPACKET_AVALABLE
        /**
         *  屏蔽红包被抢消息的提示
         */
        
        needShowNotification = (dict && [dict valueForKey:RedpacketKeyRedpacketTakenMessageSign]) ? NO : needShowNotification;
#endif
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                    [self.mainVC playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self.mainVC playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self.mainVC showNotificationWithMessage:message];      
                    break;
                default:
                    break;
            }
#endif
        }
        
        if (_chatVC == nil) {
            _chatVC = [self _getCurrentChatView];
        }
        BOOL isChatting = NO;
        if (_chatVC) {
            isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
        }
        if (_chatVC == nil || !isChatting || state == UIApplicationStateBackground) {
            [self _handleReceivedAtMessage:message];
            
            if (self.conversationListVC) {
                [_conversationListVC refresh];
            }
            
            return;
        }
        
        if (_chatVC == nil || !isChatting || state == UIApplicationStateActive) {
            [_mainVC playSoundAndVibration];
        }
        
        if (isChatting) {
            isRefreshCons = NO;
        }
    }
    
    if (isRefreshCons) {
        if (self.conversationListVC) {
            [_conversationListVC refresh];
        }
        
        if(self.mainVC && [self.mainVC isKindOfClass:[WQTabBarController class]]){
            [self.mainVC setupUnreadMessageCount:nil];
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:aMessages];
    
}

    
- (void)messagesDidRead:(NSArray *)aMessages {
    for (EMMessage * message in aMessages) {
        [WQUnreadMessageCenter messageRead:message];
    }
    
    [_mainVC setupUnreadMessageCount:nil];
}

    
    
+ (void)updateUnreadStatus:(EMMessage *)message
{
    if(message.direction != EMMessageDirectionReceive) return;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *ext = message.ext;
    
    NSMutableDictionary *friendChatDict = [[defaults objectForKey:@"friend_chat"] mutableCopy];
    if(friendChatDict == nil){
        friendChatDict = [[NSMutableDictionary alloc] init];
    }
    if(ext == nil || [ext objectForKey:@"nid"] == nil || ((NSString *)[ext objectForKey:@"nid"]).length == 0){//是好友对话
        NSNumber *unreadNum = [friendChatDict objectForKey:message.conversationId];
        if(unreadNum == nil){
            unreadNum = [NSNumber numberWithInt:0];
        }
        unreadNum = [NSNumber numberWithInt:[unreadNum intValue] + 1];
        [friendChatDict setObject:unreadNum forKey:message.conversationId];
        [defaults setObject:friendChatDict forKey:@"friend_chat"];
    }else{
        NSString *needOwnerId = [ext objectForKey:@"need_owner_id"];
        NSString *nid = [ext objectForKey:@"nid"];
        NSString *from = message.from;
        NSMutableDictionary *nidChatDict = [[defaults objectForKey:@"need_chat"] mutableCopy];
        if(nidChatDict == nil){
            nidChatDict = [[NSMutableDictionary alloc] init];
        }
        
        if ([ext[@"is_bidding"] boolValue]) {
            [nidChatDict setObject:needOwnerId forKey:nid];

        } else {
        
            [nidChatDict setObject:needOwnerId forKey:[from stringByAppendingString:nid]];
        }
        
        [defaults setObject:nidChatDict forKey:@"need_chat"];
        
    }
    [defaults synchronize];
}

+(NSInteger)getUnreadCount:(NSString *)conversationId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *friendChatDict = [defaults objectForKey:@"friend_chat"];
    if(friendChatDict == nil){
        return 0;
    }
    if(conversationId == nil){
        return friendChatDict.count;
    }else{
        if([friendChatDict objectForKey:conversationId]){
            return [[friendChatDict objectForKey:conversationId] intValue];
        }else{
            return 0;
        }
    }
}

+(void)readChat:(NSString *)nid withChatter:(NSString *)userId
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *nidChatDict = [[defaults objectForKey:@"need_chat"] mutableCopy];
    if (userId == nil) { // 不是好友
        if(nidChatDict == nil){
            return;
        }

    }
    if(nid != nil && nid.length == 0){
        nid = nil;
    }
    if(nid != nil){
        [nidChatDict removeObjectForKey:nid];
        
    }
    
    if ((![nid isKindOfClass:[NSString class]]) && (nid != nil) && userId) {
        NSMutableDictionary *friendChatDict = [[defaults objectForKey:@"friend_chat"] mutableCopy];
        if(friendChatDict != nil){
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:userId type:EMConversationTypeChat createIfNotExist:NO];
            [friendChatDict removeObjectForKey:conversation.conversationId];
            [defaults setObject:friendChatDict forKey:@"friend_chat"];
        }
    }


    if(nid != nil && userId != nil){
        [nidChatDict removeObjectForKey:[userId stringByAppendingString:nid]];
    }else if(userId != nil){
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:userId type:EMConversationTypeChat createIfNotExist:NO];
        if(conversation != nil){
            NSMutableDictionary *friendChatDict = [[defaults objectForKey:@"friend_chat"] mutableCopy];
            if(friendChatDict != nil){
                
                [friendChatDict removeObjectForKey:conversation.conversationId];
                [defaults setObject:friendChatDict forKey:@"friend_chat"];
                
                WQTabBarController * tab = (WQTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController ;
                if (! [tab isKindOfClass:[WQTabBarController class]]) {
                    return;
                }
                [tab setupUnreadMessageCount:nil];
            }
        }
    }
    
    [defaults setObject:nidChatDict forKey:@"need_chat"];
    [defaults synchronize];
}

    
//
/**
 返回是否有未读的消息 //所有的未读消息都保存在 userdef 里面,订单相关的在 @"need_chat" 里面,好友的对话保存在了friend_chat里面,当所有参数都不穿的时候默认查询所有的好友的对话

 @param nid     当前需求的 id
 @param userId  当前会话人的 id
 @return        是否有相关的未读消息
 */
+ (BOOL)hasUnreadMessage:(NSString *)nid withChatter:(NSString *)userId {
    
    BOOL hasUnreadMessage = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //当两个参数都没有穿则默认查询好友会话
    if (!(nid.length || userId.length)) {
        
        NSDictionary *friendChatDict = [defaults objectForKey:@"friend_chat"];
        return friendChatDict.count;
    }
    
    
    NSMutableDictionary *nidChatDict = [[defaults objectForKey:@"need_chat"] mutableCopy];
    if(nidChatDict == nil || nidChatDict.count == 0){
        
        return NO;
    }
    if(nid != nil && nid.length == 0){
        
        nid = nil;
    }
    
//    当 nid 和 userid 都存在时查询//订单相关的临时询问//未接单
    if(nid != nil && userId != nil){
        
        return nidChatDict[[nid stringByAppendingString:userId]];
    }else if(nid.length){
//        否则就是订单相关的对话//已接单
        return nidChatDict[nid];
    }
    
    return hasUnreadMessage;
}

#pragma mark - EMGroupManagerDelegate

- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason
{
    NSString *str = @"从群组中离开";
    if (aReason == EMGroupLeaveReasonBeRemoved) {
        str = [NSString stringWithFormat:@"You are kicked out from group: %@ [%@]", aGroup.subject, aGroup.groupId];
    } else if (aReason == EMGroupLeaveReasonDestroyed) {
        str = [NSString stringWithFormat:@"Group: %@ [%@] is destroyed", aGroup.subject, aGroup.groupId];
    }
    
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainVC.navigationController.viewControllers];
    EaseMessageViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[EaseMessageViewController class]] && [aGroup.groupId isEqualToString:[(EaseMessageViewController *)viewController conversation].conversationId])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [_mainVC.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [_mainVC.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
}

- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason
{
    if (!aGroup || !aApplicant) {
        return;
    }
    
    if (!aReason || aReason.length == 0) {
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), aApplicant, aGroup.subject];
    }
    else{
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), aApplicant, aGroup.subject, aReason];
    }
    
    /*NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroup.subject, @"groupId":aGroup.groupId, @"username":aApplicant, @"groupname":aGroup.subject, @"applyMessage":aReason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.mainVC) {
        [self.mainVC setupUntreatedApplyCount];
#if !TARGET_IPHONE_SIMULATOR
        [self.mainVC playSoundAndVibration];
#endif
    }
    
    if (self.contactViewVC) {
        [self.contactViewVC reloadApplyView];
    }*/
}

- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:[NSString stringWithFormat:@"%@ invite you to group: %@ [%@]", aInviter, aGroup.subject, aGroup.groupId] delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason
{
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝群组\"%@\"的入群邀请", aInvitee, aGroup.subject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee
{
    NSString *message = [NSString stringWithFormat:@"%@ 已同意群组\"%@\"的入群邀请", aInvitee, aGroup.subject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason
{
    if (!aReason || aReason.length == 0) {
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), aGroupId];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:aReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), aGroup.subject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage
{
    if (!aGroupId || !aInviter) {
        return;
    }
    
    /*NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"groupId":aGroupId, @"username":aInviter, @"groupname":@"", @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.mainVC) {
        [self.mainVC setupUntreatedApplyCount];
#if !TARGET_IPHONE_SIMULATOR
        [self.mainVC playSoundAndVibration];
#endif
    }
    
    if (self.contactViewVC) {
        [self.contactViewVC reloadApplyView];
    }*/
}

- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
             addedMutedMembers:(NSArray *)aMutedMembers
                    muteExpire:(NSInteger)aMuteExpire
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDetail" object:aGroup];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群组更新" message:@"禁言群成员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
           removedMutedMembers:(NSArray *)aMutedMembers
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDetail" object:aGroup];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群组更新" message:@"解除禁言" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                     addedAdmin:(NSString *)aAdmin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDetail" object:aGroup];
    
    NSString *msg = [NSString stringWithFormat:@"%@ 变为管理员", aAdmin];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"管理员更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                   removedAdmin:(NSString *)aAdmin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDetail" object:aGroup];
    
    NSString *msg = [NSString stringWithFormat:@"%@ 被移出管理员", aAdmin];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"管理员更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)groupOwnerDidUpdate:(EMGroup *)aGroup
                   newOwner:(NSString *)aNewOwner
                   oldOwner:(NSString *)aOldOwner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDetail" object:aGroup];
    
    NSString *msg = [NSString stringWithFormat:@"群主由 %@ 变为 %@", aOldOwner, aNewOwner];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群主更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - EMContactManagerDelegate

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    
    //好友请求接受之后之后应先删除在本地存储的的待处理的好友请求的列表
    
    NSMutableArray *aUsernameArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"aUsername"] mutableCopy];
    
    for (NSString * toDealWithFriendName in aUsernameArray) {
        if ([toDealWithFriendName isEqualToString:aUsername]) {
            [aUsernameArray removeObject:toDealWithFriendName];
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:aUsernameArray forKey:@"aUsername"];
    
    
    
    
    //NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *urlString = @"api/user/getbasicinfo";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * param = @{}.mutableCopy;
        param[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                
        param[@"uid"] = aUsername;
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:param completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            WQUserProfileModel *model = [WQUserProfileModel yy_modelWithJSON:response];
            NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请",model.true_name];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        
    }
                   );
    
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@拒绝了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    /*NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainVC.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [aUsername isEqualToString:[(ChatViewController *)viewController conversation].conversationId])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [_mainVC.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [_mainVC.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
    [_mainVC showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), aUsername]];
    [_contactViewVC reloadDataSource];*/
}

- (void)didReceiveAddedFromUsername:(NSString *)aUsername
{
    //[EMClient sharedClient].contactManager
}

- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    if (!aUsername) {
        return;
    }
    
   /* if (!aMessage) {
        aMessage = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.mainVC) {
        [self.mainVC setupUntreatedApplyCount];
#if !TARGET_IPHONE_SIMULATOR
        [self.mainVC playSoundAndVibration];
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            //发送本地推送
            if (NSClassFromString(@"UNUserNotificationCenter")) {
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.sound = [UNNotificationSound defaultSound];
                content.body =[NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate] * 1000] stringValue] content:content trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
            }
            else {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date]; //触发通知的时间
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
                notification.alertAction = NSLocalizedString(@"open", @"Open");
                notification.timeZone = [NSTimeZone defaultTimeZone];
            }
        }
#endif
    }
    [_contactViewVC reloadApplyView];*/
}

#pragma mark - EMChatroomManagerDelegate

- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason
{
    NSString *roomId = nil;
    if (aReason == EMChatroomBeKickedReasonDestroyed) {
        roomId = aChatroom.chatroomId;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitChat" object:roomId];
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
                addedMutedMembers:(NSArray *)aMutes
                       muteExpire:(NSInteger)aMuteExpire
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChatroomDetail" object:aChatroom];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"聊天室更新" message:@"禁言成员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
              removedMutedMembers:(NSArray *)aMutes
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChatroomDetail" object:aChatroom];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"聊天室更新" message:@"解除禁言" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                        addedAdmin:(NSString *)aAdmin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChatroomDetail" object:aChatroom];
    
    NSString *msg = [NSString stringWithFormat:@"%@ 变为管理员", aAdmin];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"管理员更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                      removedAdmin:(NSString *)aAdmin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChatroomDetail" object:aChatroom];
    
    NSString *msg = [NSString stringWithFormat:@"%@ 被移出管理员", aAdmin];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"管理员更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)chatroomOwnerDidUpdate:(EMChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChatroomDetail" object:aChatroom];
    
    NSString *msg = [NSString stringWithFormat:@"聊天室创建者由 %@ 变为 %@", aOldOwner, aNewOwner];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"聊天室创建者更新" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - public

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (EaseMessageViewController*)_getCurrentChatView
{
    
    
    UINavigationController * nc = (UINavigationController *)_mainVC.selectedViewController;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nc.viewControllers];
    EaseMessageViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[EaseMessageViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

- (void)_clearHelper
{
    self.mainVC = nil;
    self.conversationListVC = nil;
    self.chatVC = nil;
    //self.contactViewVC = nil;
    
    [[EMClient sharedClient] logout:NO];
}

    

    
- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
{
    if (aMessage.chatType != EMChatTypeChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
    if (self.mainVC) {
        [_mainVC setupUnreadMessageCount:aMessage];
    }
}


@end
