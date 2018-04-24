//
//  WQNeedInfoModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQNeedInfoModel : NSObject
@property(nonatomic, copy) NSString * createtime;/** <- true string 创建时间*/
@property(nonatomic, copy) NSString * push_range;/** true string 可见范围：所有人、特定人*/
@property(nonatomic, copy) NSString * range_value;// true string 可见范围内容（特定人）： ja 特定人的用户ID
@property(nonatomic, copy) NSString * user_name;// true string 用户名称
@property(nonatomic, copy) NSString * subject;// true string 内容简介
@property(nonatomic, retain) NSNumber * total_count;// true number 需求总需求人数
@property(nonatomic, retain) NSNumber * money;// true number 需求的单价酬金
@property(nonatomic, retain) NSNumber * addr_geo_lng;// true number 服务者地理经度
@property(nonatomic, retain) NSNumber * addr_geo_lat;// true number 服务者地理纬度
@property(nonatomic, copy) NSString * finished_date;// true string 需求要求的完成截止时间
@property(nonatomic, retain) NSArray * pic; //true array 附图的ID集，ja格式
@property(nonatomic, copy) NSString * content;// true string 内容简介
@property(nonatomic, copy) NSString * user_pic;// true string 用户头像
@property(nonatomic, copy) NSString * user_id;// true string 需求发布者
@property(nonatomic, copy) NSNumber * bidder_count;// true number 需求参与人数
@property(nonatomic, copy) NSNumber * bidded_count;// true number 中标人数
@property(nonatomic, copy) NSString * id;// true string 需求 id
@property(nonatomic, retain) NSArray * tag;// true array 需求tags
@property(nonatomic, copy) NSString * category;// true string 需求类别名称
@property(nonatomic, copy) NSString * addr;// true string 服务者所在地点（即：需求所在地点）名称
@property(nonatomic, copy) NSString * status ;//true string 状态：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）
@property (nonatomic, assign) BOOL success;// true boolean 是否成功
@property (nonatomic, copy) NSString * can_bid;//true string 是否可以投标
@property(nonatomic, copy) NSString * share_count;// true string 已推送（分享）人数
@property(nonatomic, copy) NSString * view_count;// true string 已查看人数
@property(nonatomic, copy) NSString * truename;// true string 是否真名
@property(nonatomic, copy) NSString * feedback_count_to_publisher;// true string 建议数目
@end
