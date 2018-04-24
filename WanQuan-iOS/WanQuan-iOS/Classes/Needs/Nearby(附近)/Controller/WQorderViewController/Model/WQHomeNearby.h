//
//  WQHomeNearby.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQHomeNearbyTagModel.h"

@interface WQHomeNearby : NSObject
// 是否领取
//@property (nonatomic, assign) BOOL can_bid;
// 查看人数
@property (nonatomic, copy) NSString *view_count;
// title
@property (nonatomic, copy) NSString *category_level_1;
//创建时间
@property(nonatomic,copy)NSString *createtime;
//可见范围：所有人、特定人
@property(nonatomic,copy)NSString *push_range;
//可见范围内容（特定人）： ja 特定人的用户ID
@property(nonatomic,copy)NSString *range_value;
//用户名称
@property(nonatomic,copy)NSString *user_name;
// 是否匿名
@property(nonatomic,assign)BOOL truename;
//内容简介
@property(nonatomic,copy)NSString *subject;
//需求总需求人数
@property(nonatomic,copy)NSString *total_count;
//需求的单价酬金
@property(nonatomic,copy)NSString *money;
//服务者地理经度
@property(nonatomic,copy)NSNumber *addr_geo_lng;
//服务者地理纬度
@property(nonatomic,copy)NSNumber *addr_geo_lat;
//需求要求的完成截止时间
@property(nonatomic,copy)NSString *finished_date;
//附图的ID集，ja格式
@property(nonatomic,strong)NSArray *pic;
//内容简介
@property(nonatomic,copy)NSString *content;
//用户头像
@property(nonatomic,copy)NSString *user_pic;
//需求发布者
@property(nonatomic,copy)NSString *user_id;
//需求参与人数
@property(nonatomic,copy)NSString *bidder_count;
//中标人数
@property(nonatomic,copy)NSString *bidded_count;
//需求 id
@property(nonatomic,copy)NSString *id;
//需求tags
@property(nonatomic,strong)NSArray <WQHomeNearbyTagModel *>*tag;
//需求类别名称
@property(nonatomic,copy)NSString *category;
//服务者所在地点（即：需求所在地点）名称
@property(nonatomic,copy)NSString *addr;
//需求状态：有效招标期、完成、过期
@property(nonatomic,copy)NSString *status;
//是否成功
@property(nonatomic,assign)BOOL success;
//标签
@property(nonatomic,strong)NSArray *user_tag;
//是否可以投标
@property(nonatomic,copy)NSString *can_bid;
// 返回的图片数组
@property(nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic, copy) NSString *content_addr;
@property (nonatomic, copy) NSString *content_time;
@property (nonatomic, copy) NSString *content_requirement;


/**
 时间
 */
@property (nonatomic, copy) NSString *left_secends;

/**
 是否已领取
 */
@property (nonatomic, copy) NSString *has_bid;
// 图片加载完成的block
@property(nonatomic,copy)void(^imagesBlock)();
@end
