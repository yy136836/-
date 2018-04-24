//
//  WQPhoneBookFriendsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPhoneBookFriendsModel : NSObject

/**
 id true string 通讯录ID
 */
@property (nonatomic, copy) NSString *id;

/**
 name true string 通讯录姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 phone true string 通讯录电话
 */
@property (nonatomic, copy) NSString *phone;

/**
 friend true boolean 是否已添加为朋友
 */
@property (nonatomic, assign) BOOL friend;

/**
 invited true boolean 是否已邀请加入万圈
 */
@property (nonatomic, assign) BOOL invited;

/**
 user_tag true string 用户标签（对于已入住万圈的通讯录朋友）
 */
@property (nonatomic, strong) NSArray *user_tag;

/**
 user_name true string 用户姓名（对于已入住万圈的通讯录朋友）
 */
@property (nonatomic, copy) NSString *user_name;

/**
 user_pic true string 用户头像（对于已入住万圈的通讯录朋友）
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 是否已经发送邀请
 */
@property (nonatomic, assign) BOOL sent_friend_apply;

/**
 用户的id
 */
@property (nonatomic, copy) NSString *user_id;

@end
