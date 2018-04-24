//
//  WQWaitOrderModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQWaitOrderModel : NSObject
+(instancetype)modelWithDict:(NSDictionary *) dict;
//需求总需人数
@property (nonatomic, strong) NSNumber *total_count;
// 需求类型
@property (nonatomic, copy) NSString *category_level_1;
//需求所上传的图片集。JsonArray格式，每个元素是一个图片的ID
@property (nonatomic, strong) NSArray *pic;
//需求的单价酬金
@property (nonatomic, strong) NSNumber *money;
//需求参与人数
@property (nonatomic, strong) NSNumber *bidded_count;
//发单者id
@property (nonatomic, strong) NSString *user_id;
//发单者姓名
@property (nonatomic, strong) NSString *user_name;
//发单者头像
@property (nonatomic, strong) NSString *user_pic;
//接单者姓名
@property (nonatomic, strong) NSString *bid_user_name;
//接单者头像
@property (nonatomic, strong) NSString *bid_user_pic;
//剩余时间
@property (nonatomic, strong) NSNumber *left_secends;
//tag
@property (nonatomic, strong) NSArray *tag;
//中标人数
@property (nonatomic, strong) NSNumber *bidder_count;
//发单者是否为匿名
@property (nonatomic, assign) BOOL truename;
//接单者是否为匿名
@property (nonatomic, assign) BOOL bid_truename;
@property (nonatomic, assign) BOOL isfeedbacked;
//需求状态
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *nbid;
@property (nonatomic, copy) NSString *workstatus;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *view_count;
//需求创建时间
@property (nonatomic, copy) NSString *createtime;
//需求内容简介
@property (nonatomic, copy) NSString *subject;
//需求 id
@property (nonatomic, copy) NSString *id;
//可见范围：所有人、特定人
@property (nonatomic, copy) NSString *push_range;
//需求要求的完成截止时间
@property (nonatomic, copy) NSString *finished_date;
@property (nonatomic, assign) BOOL can_feedback;

@property (nonatomic, assign) BOOL reddot;
@property (nonatomic, retain) NSString * can_bid;
@end
