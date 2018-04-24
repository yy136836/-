//
//  WQHomeNearbyTagModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQHomeNearbyTagModel : NSObject


//+(instancetype)modelWithDict:(NSDictionary *) dict;
// 需求类型
@property (nonatomic, copy) NSString *category_level_1;
//需求信息
@property(nonatomic,strong)NSArray *needs;
//需求创建时间
@property(nonatomic,copy)NSString *createtime;
//发需求人姓名
@property(nonatomic,copy)NSString *user_name;
//需求内容简介
@property(nonatomic,copy)NSString *subject;
// 需求内容
@property (nonatomic, copy) NSString *content;
// 几度好友
@property (nonatomic, copy) NSString *user_degree;
//需求总须人数
@property(nonatomic,strong)NSNumber *total_count;
//需求要求的完成截止时间
@property(nonatomic,copy)NSString *finished_date;
//需求所上传的图片集。JsonArray格式，每个元素是一个图片的ID
@property(nonatomic,strong)NSArray *pic;
//发需求人图片
@property(nonatomic,copy)NSString *user_pic;
//需求的单价酬金
@property(nonatomic,strong)NSNumber *money;
//发需求人id
@property(nonatomic,strong)NSString *user_id;
//已抢单人数
@property(nonatomic,strong)NSNumber *bidded_count;
//需求 id
@property(nonatomic,copy)NSString *id;
//剩余时间
@property(nonatomic,strong)NSNumber *left_secends;
//需求tags，jsonarray格式
@property(nonatomic,strong)NSArray *tag;
@property(nonatomic,strong)NSArray *user_tag;
//需求状态：未完成（STATUS_SHOWING_UNFINISHED），已完成（STATUS_SHOWING_FINISHED），已过期（STATUS_EXPIRED）
@property(nonatomic,copy)NSString *status;
//是否成功
@property(nonatomic,assign)BOOL success;
//距离
@property(nonatomic,assign)CGFloat distance;

@property(nonatomic,strong)NSNumber *bidder_count;
@property(nonatomic,assign)BOOL truename;
@property (nonatomic, copy) NSString *user_creditscore;
// 用户状态
@property (nonatomic, copy) NSString *user_idcard_status;

@property (nonatomic, copy) NSString *comment_count;

@end
