//
//  WQparticularsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQsourceMomentStatusModel,WQcommentListModel,WQrewardListModel,WQzanLike_listModel;

@interface WQparticularsModel : NSObject
// 是否群组转发  //发布的类型，CATE_NORMAL=一般类型（文字、图片）；CATE_GROUP=分享群组；默认为CATE_NORMAL
@property (nonatomic, copy) NSString *cate;
@property(nonatomic,strong)WQsourceMomentStatusModel *source_moment_status;
// 群名片信息
@property (nonatomic, strong) NSMutableDictionary *extras;
//用户名
@property(nonatomic,copy)NSString *user_name;
//是否匿名
@property (nonatomic, assign) BOOL truename;
//标签
@property (nonatomic, strong) NSArray *user_tag;
//头像
@property(nonatomic,copy)NSString *user_pic;
//发布者 id
@property(nonatomic,copy)NSString *user_id;
//状态 id（即 mid）
@property(nonatomic,copy)NSString *id;
//状态中的图片
@property(nonatomic,strong)NSArray *pic;
//状态内容
@property(nonatomic,copy)NSString *content;
//状态类型
@property(nonatomic,copy)NSString *type;
//状态地点
@property(nonatomic,copy)NSString *addr;
//地理位置经度
@property(nonatomic,strong)NSNumber *geo_lng;
//地理位置纬度
@property(nonatomic,strong)NSNumber *geo_lat;
//已经发布过去的时间
@property(nonatomic,assign)NSInteger past_second;
//发布时间
@property(nonatomic,copy)NSString *post_time;
//推送范围
@property(nonatomic,copy)NSString *push_range;
//评论数
@property(nonatomic,assign)int comment_count;
//评论列表
@property(nonatomic,strong)NSArray <WQcommentListModel *>*comment_list;
//是否可以赞
@property(nonatomic,assign)BOOL can_like;
//赞人数
@property(nonatomic,assign)int like_count;
//赞列表
@property(nonatomic,strong)NSArray <WQzanLike_listModel *>*like_list;
//踩人数
@property(nonatomic,assign)int dislike_count;
//是否可以踩
@property(nonatomic,assign)BOOL can_dislike;
//踩列表
@property(nonatomic,strong)NSArray *dislike_list;
//转发人数
@property(nonatomic,assign)int fw_count;
//是否可以打赏
@property(nonatomic,assign)BOOL can_reward;
//打赏人数
@property(nonatomic,assign)int reward_count;
//总打赏金额
@property(nonatomic,strong)NSNumber *reward_totalmoney;
//打赏列表
@property(nonatomic,strong)NSArray <WQrewardListModel *>*reward_list;
//是否成功
@property(nonatomic,assign)BOOL success;

@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *link_txt;
@property (nonatomic, copy) NSString *link_img;

@property (nonatomic, assign) BOOL user_followed;

/**
 是否收藏
 */
@property (nonatomic, assign) BOOL favorited;

/**
 几度好友
 */
@property (nonatomic, copy) NSString *user_degree;

/**
 信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

@end
