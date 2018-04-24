//
//  WQcommentListModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQcommentListModel : NSObject
//距离评论已过时间
@property(nonatomic,copy)NSString *past_second;
//评论者图片
@property(nonatomic,copy)NSString *user_pic;
//评论
@property(nonatomic,copy)NSString *id;
//评论者
@property(nonatomic,copy)NSString *user_id;
//评论者姓名
@property(nonatomic,copy)NSString *user_name;
//是否可以删除
@property(nonatomic,assign)BOOL can_delete;
//评论内容
@property(nonatomic,copy)NSString *content;
//发布时间
@property(nonatomic,copy)NSString *post_time;


/**
 truename true boolean 是否匿名
 */
@property (nonatomic, assign) BOOL truename;

/**
 reply_user true boolean 当前评论是否指定具体的被回复人
 */
@property (nonatomic, assign) BOOL reply_user;

/**
 reply_user_truename false boolean 被回复人是否是真名显示（一度好友）
 */
@property (nonatomic, assign) BOOL reply_user_truename;

/**
 reply_user_name false string 被回复人姓名
 */
@property (nonatomic, copy) NSString * reply_user_name;

/**
 reply_user_pic false string 被回复人头像
 */
@property (nonatomic, copy) NSString * reply_user_pic;

/**
 reply_user_id false string 被回复人ID
 */
@property (nonatomic, copy) NSString * reply_user_id;

/**
 评论者的信用分
 */
@property (nonatomic, retain) NSNumber * user_creditscore;




@end
