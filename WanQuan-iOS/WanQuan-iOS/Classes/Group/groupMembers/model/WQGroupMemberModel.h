//
//  WQGroupMemberModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQGroupMemberModel : NSObject

/**
  true string 成员姓名
 */
@property (nonatomic, copy) NSString *        user_name;

/**
 true string 成员头像
 */
@property (nonatomic, copy) NSString *        user_pic;

/**
 true string 成员用户ID
 */
@property (nonatomic, copy) NSString *        user_id;

/**
 true string 成员用户idcard_status
 */
@property (nonatomic, copy) NSString *        user_idcard_status;

/**
 是否是管理员
 */
@property (nonatomic, copy) NSString *isAdmin;

/**
 是否是群主
 */
@property (nonatomic, copy) NSString *isOwner;

/**
 该用户是否为已注册,如果仅为校友而没有注册则为 YES 如已经注册则为 NO
 */
@property (nonatomic, assign) BOOL user_virtual;

@end
