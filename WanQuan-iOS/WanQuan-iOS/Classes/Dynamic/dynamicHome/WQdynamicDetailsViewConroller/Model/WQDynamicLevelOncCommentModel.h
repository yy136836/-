//
//  WQDynamicLevelOncCommentModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQDynamicLevelSecondaryModel;

@interface WQDynamicLevelOncCommentModel : NSObject

/**
 是否热门
 */
@property (nonatomic, assign) BOOL hot;

/**
 谁谁谁回复的
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
 二级评论
 */
@property (nonatomic, strong) NSArray <WQDynamicLevelSecondaryModel *>*comment_children;

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
@property (nonatomic, strong) NSString *past_second;

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
 二级评论数量
 */
@property (nonatomic, assign) int comment_children_count;

/**
 发布人的信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

@property (nonatomic, copy) NSString *id;

/**
 发布人与当前浏览人的好友度数
 */
@property (nonatomic, copy) NSString *user_degree;


/**
 精选才有所属精选 id
 */
@property (nonatomic, copy) NSString * aid;

/**
 动态才有,动态 id
 */
@property (nonatomic, copy) NSString * mid;

- (void)WQSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues;

@end
