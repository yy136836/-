//
//  WQReplyModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>




typedef NS_ENUM(NSUInteger, WQReplyType) {
    WQReplyTypeFrom,
    WQReplyTypeTo
};
@interface WQGroupReplyModel : NSObject

/**
 该二级评论的 id
 */
@property (nonatomic, copy) NSString * id;


/**
 该回复是否可以被删除
 */
@property (nonatomic, assign) BOOL canDelete;

/**
 //user_id true string 二级评论的用户ID

 */
@property (nonatomic, copy) NSString * user_id;

/**
 //user_name true string 二级评论的用户姓名

 */
@property (nonatomic, copy) NSString * user_name;

/**
 //user_tag true string 二级评论的用户Tag

 */
@property (nonatomic, copy) NSString * user_tag;

/**
 //user_pic true string 二级评论的用户头像

 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //user_idcard_status true string 二级评论的idcard_status

 */
@property (nonatomic, copy) NSString * user_idcard_status;

/**
 //createtime true string 二级评论的发布时间：yyyy-MM-dd HH:mm:ss

 */
@property (nonatomic, copy) NSString * createtime;

/**
 //content true string 二级评论的内容

 */
@property (nonatomic, copy) NSString * content;

/**
 //reply true boolean 该二级评论是否指定回复其他二级评论

 */
@property (nonatomic, assign) BOOL reply;

/**
 //reply_user_id false string 被回复二级评论发布者的用户ID（当reply=true时返回该参数）

 */
@property (nonatomic, copy) NSString * reply_user_id;

/**
 //reply_user_name false string 被回复二级评论发布者的用户姓名（当reply=true时返回该参数）

 */
@property (nonatomic, copy) NSString * reply_user_name;

/**
 //reply_user_tag false string 被回复二级评论发布者的用户Tag（当reply=true时返回该参数）

 */
@property (nonatomic, copy) NSString * reply_user_tag;

/**
 //reply_user_pic false string 被回复二级评论发布者的用户头像（当reply=true时返回该参数）

 */
@property (nonatomic, copy) NSString * reply_user_pic;

/**
 //reply_user_idcard_status true string 被回复二级评论发布者的用户idcard_status（当reply=true时返回该参数）
 */
@property (nonatomic, copy) NSString * reply_user_idcard_status;

/**
 已发布了多久
 */
@property (nonatomic, retain) NSNumber * past_second;

@end
