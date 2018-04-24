//
//  WQmoment_choicest_articleModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQEssenceDataEntity.h"

@interface WQmoment_choicest_articleModel : NSObject<WQEssenceDataEntity>

/**
 精选id
 */
@property (nonatomic, copy) NSString *id;

/**
 是否已关注
 */
@property (nonatomic, assign) BOOL user_followed;

/**
 发布人的姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 发布人的头像
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 发布人与当前浏览人的好友度数
 */
@property (nonatomic, copy) NSString *user_degree;

/**
 发布人的信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

/**
 发布人的ID
 */
@property (nonatomic, copy) NSString *user_id;

/**
 发布人的标签
 */
@property (nonatomic, strong) NSArray *user_tag;
/**
 创建时间
 */
@property (nonatomic, copy) NSString *createtime;

/**
 modifytime_past_second true number 创建时间距离当前时间的秒数
 */
@property (nonatomic, retain) NSNumber *createtime_past_second;

/**
 modifytime true string 修改时间
 */
@property (nonatomic, copy) NSString *modifytime;

/**
 modifytime_past_second true number 修改时间距离当前时间的秒数
 */
@property (nonatomic, retain) NSNumber *modifytime_past_second;

/**
 user_idcard_status true string 作者身份状态
 */
@property (nonatomic, copy) NSString *user_idcard_status;

/**
 不知道有啥用
 */
@property (nonatomic, copy) NSString *favorite_id;

/**
 是否收藏
 */
@property (nonatomic, assign)BOOL  favorited;

/**
 图片
 */
@property (nonatomic, copy) NSString *cover_pic;

@property (nonatomic, copy) NSString *carousel_pic;

/**
 描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 标题
 */
@property (nonatomic, copy) NSString *subject;

/**
 标签数组
 */
@property (nonatomic, strong) NSArray *tags;

/**
 目前文档没描述有什么用
 */
@property (nonatomic, copy) NSString *views;

/**
 赞
 */
@property (nonatomic, copy) NSString *like_count;

/**
 评论数
 */
@property (nonatomic, assign) int comment_count;

/**
 是否可以赞
 */
@property (nonatomic, assign) BOOL can_like;

/**
 是否可以踩
 */
@property (nonatomic, assign) BOOL can_dislike;

/**
 是否可以鼓励
 */
@property (nonatomic, assign) BOOL can_reward;

/**
 精选是否来自圈子
 */
@property (nonatomic, assign) BOOL article_from_group;

/**
 来自圈子ID
 */
@property (nonatomic, copy) NSString *article_group_id;

/**
 来自圈子名称
 */
@property (nonatomic, copy) NSString *article_group_name;

@end
