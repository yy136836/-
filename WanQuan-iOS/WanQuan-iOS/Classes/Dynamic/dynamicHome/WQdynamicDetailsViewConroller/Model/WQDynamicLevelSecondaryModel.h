//
//  WQDynamicLevelSecondaryModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQDynamicLevelSecondaryModel : NSObject

/**
 姓名
 */
@property (nonatomic, copy) NSString *reply_user_name;

/**
 是否赞过
 */
@property (nonatomic, assign) BOOL isLiked;

/**
 赞的数量
 */
@property (nonatomic, assign) int like_count;

/**
 标签数组
 */
@property (nonatomic, strong) NSArray *user_tag;

/**
 姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 评论内容
 */
@property (nonatomic, copy) NSString *content;

/**
 发布时间
 */
@property (nonatomic, copy) NSString *post_time;

/**
 距离发布时间已过秒数
 */
@property (nonatomic, copy) NSString *past_second;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 user_id
 */
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) BOOL can_delete;

/**
 发布人的信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

@property (nonatomic, copy) NSString *id;

/**
 发布人与当前浏览人的好友度数
 */
@property (nonatomic, copy) NSString *user_degree;

@end
