//
//  WQMiriadeaModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/15.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQretransmissionModel,WQlike_listModel;

@interface WQMiriadeaModel : NSObject
// 是否群组转发  //发布的类型，CATE_NORMAL=一般类型（文字、图片）；CATE_GROUP=分享群组；默认为CATE_NORMAL
@property (nonatomic, copy) NSString *cate;
//标签
@property(nonatomic,strong)NSArray *user_tag;
//转发
@property(nonatomic,strong)WQretransmissionModel *source_moment_status;
//赞列表
@property(nonatomic,strong)NSArray<WQlike_listModel *>*like_list;
//图片
@property(nonatomic,strong)NSArray *pic;
//原状态转发状态
@property(nonatomic,copy)NSString *type;
//状态内容
@property(nonatomic,copy)NSString *content;
//发布时间
@property(nonatomic,copy)NSString *post_time;
//可见范围：PUSH_RANGE_DEGREE1=1度好友；PUSH_RANGE_DEGREE2=1、2度好友
@property(nonatomic,copy)NSString *push_range;
//距离发布时间已过秒数
@property(nonatomic,strong)NSNumber *past_second;
//踩列表
@property(nonatomic,strong)NSArray *dislike_list;
//用户头像
@property(nonatomic,copy)NSString *user_pic;
//用户id
@property(nonatomic,copy)NSString *user_id;
//是否可以赞
@property(nonatomic,assign)BOOL can_like;
//评论列表
@property(nonatomic,strong)NSArray *comment_list;
//状态 id
@property(nonatomic,copy)NSString *id;
//这条moment类型为：状态。（以后可扩展为话题、主题等）
@property(nonatomic,copy)NSString *category;
//踩数
//@property(nonatomic,strong)NSNumber *dislike_count;
@property(nonatomic,assign)int dislike_count;
//评论数
//@property(nonatomic,strong)NSNumber *comment_count;
@property(nonatomic,assign)int comment_count;
//转发数
@property(nonatomic,strong)NSNumber *fw_count;
//赞数
//@property(nonatomic,strong)NSNumber *like_count;
@property(nonatomic,assign)int like_count;
//发表用户名称
@property(nonatomic,copy)NSString *user_name;
//是否可以踩
@property(nonatomic,assign)BOOL can_dislike;

@property (nonatomic,assign) BOOL truename;

@property (nonatomic, copy) NSString *user_creditscore;
// 群名片信息
@property (nonatomic, strong) NSMutableDictionary *extras;

@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *link_txt;
@property (nonatomic, copy) NSString *link_img;

@end
