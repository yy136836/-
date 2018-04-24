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
//创建时间
@property(nonatomic,copy)NSString *createtime;
//可见范围：所有人、特定人
@property(nonatomic,copy)NSString *push_range;
//可见范围内容（特定人）： ja 特定人的用户ID
@property(nonatomic,copy)NSString *range_value;
//用户名称
@property(nonatomic,copy)NSString *user_name;
//内容简介
@property(nonatomic,copy)NSString *subject;
//需求总需求人数
@property(nonatomic,strong)NSNumber *total_count;
//需求的单价酬金
@property(nonatomic,copy)NSNumber *money;
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
@property(nonatomic,copy)NSNumber *bidder_count;
//中标人数
@property(nonatomic,copy)NSNumber *bidded_count;
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
//是否可以投标
@property(nonatomic,copy)NSString *can_bid;
// 返回的图片数组
@property(nonatomic,strong)NSMutableArray *imageArray;
// 图片加载完成的block
@property(nonatomic,copy)void(^imagesBlock)();
@end
