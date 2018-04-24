//
//  WQUserProfileNeedModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserProfileNeedModel : NSObject


/**
 //createtime true string 需求创建时间
 */
@property (nonatomic, copy) NSString * createtime;

/**
 //user_name true string 发需求人姓名
 */
@property (nonatomic, copy) NSString * user_name;

/**
 //subject true string 需求内容简介
 */
@property (nonatomic, copy) NSString * subject;

/**
 //content true string 需求内容
 */
@property (nonatomic, copy) NSString * content;

/**
 //total_count true number 需求总需人数
 */
@property (nonatomic, retain) NSNumber * total_count;

/**
 //finished_date true string 需求要求的完成截止时间
 */
@property (nonatomic, copy) NSString * finished_date;

/**
 //pic true array 需求所上传的图片集。JsonArray格式，每个元素是一个图片的ID
 */
@property (nonatomic, retain) NSArray * pic;

/**
 //user_pic true string 发需求人图片
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //money true number 需求的单价酬金
 */
@property (nonatomic, retain) NSNumber * money;

/**
 //user_id true string 发需求人id
 */
@property (nonatomic, copy) NSString * user_id;

/**
 //bidded_count true number 已抢单人数
 */
@property (nonatomic, retain) NSNumber * bidded_count;

/**
 //id true string 需求 id
 */
@property (nonatomic, copy) NSString * id;

/**
 //left_secends true number 剩余时间
 */
@property (nonatomic, retain) NSNumber * left_secends;

/**
 //tag true array 需求tags，jsonarray格式
 */
@property (nonatomic, retain) NSArray * tag;

/**
 //bidder_count true number 中标人数
 */
@property (nonatomic, retain) NSNumber * bidder_count;

/**
 //status true string 状态：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）
 */
@property (nonatomic, copy) NSString * status;

/**
 //distance true string 距离
 */
@property (nonatomic, copy) NSString * distance;

/**
 //share_count true string 已推送（分享）人数
 */
@property (nonatomic, copy) NSString * share_count;

/**
 //view_count true string 已查看人数
 */
@property (nonatomic, copy) NSString * view_count;

/**
 //user_degree true string 好友度数：0=自己；1=1度好友；2=2度好友；3=3度好友；4=4度以上好友
 */
@property (nonatomic, copy) NSString * user_degree;

/**
 //content_time true string
 */
@property (nonatomic, copy) NSString * content_time;

/**
 //content_addr true string
 */
@property (nonatomic, copy) NSString * content_addr;

/**
 //content_requirement true string
 */
@property (nonatomic, copy) NSString * content_requirement;

/**
 //category_level_1 true string 需求一级分类
 */
@property (nonatomic, copy) NSString * category_level_1;

/**
 //category_level_2 true string 需求二级分类
 */
@property (nonatomic, copy) NSString * category_level_2;

@end


