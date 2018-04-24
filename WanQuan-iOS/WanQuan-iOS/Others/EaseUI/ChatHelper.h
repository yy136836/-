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

#import <Foundation/Foundation.h>

//#import "ConversationListController.h"
//#import "ContactListViewController.h"
//#import "MainViewController.h"
//#import "ChatViewController.h"
#import "WQTabBarController.h"
#import "EaseMessageViewController.h"
#import "EaseConversationListViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

@interface ChatHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

//@property (nonatomic, weak) ContactListViewController *contactViewVC;
//
@property (nonatomic, weak) EaseConversationListViewController *conversationListVC;
//
@property (nonatomic, weak) WQTabBarController *mainVC;
//
@property (nonatomic, weak) EaseMessageViewController *chatVC;

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

+ (BOOL)hasUnreadMessage:(NSString *)nid withChatter:(NSString *)userId;
+ (void)readChat:(NSString *)nid withChatter:(NSString *)userId;
+ (NSInteger)getUnreadCount:(NSString *)conversationId;

@end
