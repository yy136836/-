//
//  WQmoment_statusModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQmoment_statusModel : NSObject

/**
 万圈状态（moment_status）的ID
 */
@property (nonatomic, copy) NSString *id;

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
 是否已关注
 */
@property (nonatomic, copy) NSString *user_followed;

/**
 图片
 */
@property (nonatomic, strong) NSArray *pic;

/**
 踩数量
 */
@property (nonatomic, assign) int dislike_count;

/**
 赞数量
 */
@property (nonatomic, copy) NSString *like_count;

/**
 评论数量
 */
@property (nonatomic, copy) NSString *comment_count;

/**
 奖励数量
 */
@property (nonatomic, copy) NSString *reward_count;

/**
 奖励总金额
 */
@property (nonatomic, copy) NSString *reward_totalmoney;

/**
 转发数
 */
@property (nonatomic, copy) NSString *fw_count;

/**
 内容
 */
@property (nonatomic, copy) NSString *content;

/**
 外链图片
 */
@property (nonatomic, copy) NSString *link_img;

/**
 外链文字
 */
@property (nonatomic, copy) NSString *link_txt;

/**
 外链url
 */
@property (nonatomic, copy) NSString *link_url;

/**
 发布时间
 */
@property (nonatomic, copy) NSString *post_time;

/**
 距离发布时间已过秒数
 */
@property (nonatomic, strong) NSNumber *past_second;

/**
 可见范围：PUSH_RANGE_DEGREE1=1度好友；PUSH_RANGE_DEGREE2=1、2度好友
 */
@property (nonatomic, copy) NSString *push_range;

/**
 是否可以赞
 */
@property (nonatomic, assign) BOOL can_like;

/**
 是否可以踩
 */
@property (nonatomic, assign) BOOL can_dislike;

@end
