//
//  WQWaitingForAuditModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQWaitingForAuditModel : NSObject
// group_user_id true string guid：成员在该群中的唯一ID
@property (nonatomic, copy) NSString *group_user_id;
// user_name true string 成员姓名
@property (nonatomic, copy) NSString *user_name;
// user_id true string 成员用户ID
@property (nonatomic, copy) NSString *user_id;
// user_pic true string 成员头像
@property (nonatomic, copy) NSString *user_pic;
// user_tag true string 成员Tag
@property (nonatomic, strong) NSArray *user_tag;
// user_idcard_status true string 成员idcard_status
@property (nonatomic, copy) NSString *user_idcard_status;

/**
 请求加群事填的信息
 */
@property (nonatomic, copy) NSString * message;
@end
