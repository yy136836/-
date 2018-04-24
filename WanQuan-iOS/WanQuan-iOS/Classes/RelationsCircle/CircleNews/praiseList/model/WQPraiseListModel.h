//
//  WQPraiseListModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPraiseListModel : NSObject

@property  (nonatomic, copy) NSString * user_id;

/**
  true string 消息内容
 */
@property (nonatomic, copy) NSString *  content;

/**
 true string 对应消息 id
 */
@property (nonatomic, copy) NSString * targetid;

/**
 true string targetid的类型：TARGET_TYPE_MOMENT_STATUS=万圈状态；TARGET_TYPE_NEED=需求； TARGET_TYPE_GROUP=圈子； TARGET_TYPE_GROUP_TOPIC=圈子主题; TARGET_TYPE_CHOICEST_ARTICLE = 精选文章；
 */
@property (nonatomic, copy) NSString * targettype;

/**
  true string 消息标题
 */
@property (nonatomic, copy) NSString * title;

/**
  true string 消息类型：TYPE_SYSTEM（系统消息）、TYPE_LIKE（点赞消息）、TYPE_COMMENT（评论消息）
 */
@property (nonatomic, copy) NSString * type;

/**
 true string 消息发布者
 */
@property (nonatomic, copy) NSString * subject;

/**
  true string 发布时间
 */
@property (nonatomic, copy) NSString * posttime;

/**
  true string 发布时间距离现在的秒数
 */
@property (nonatomic, copy) NSString * posttime_pastseconds;

/**
  true string 作者是否实名显示（在评论消息、点赞消息有效）
 */
@property (nonatomic, copy) NSString * user_truename;

/**
  true string 作者的头像（在评论消息、点赞消息有效）
 */
@property (nonatomic, copy) NSString * user_pic;

/**
  true string 作者的姓名（在评论消息、点赞消息有效）
 */
@property (nonatomic, copy) NSString * user_name;
@end
