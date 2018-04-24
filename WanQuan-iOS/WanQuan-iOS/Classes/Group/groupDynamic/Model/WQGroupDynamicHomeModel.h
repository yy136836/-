//
//  WQGroupDynamicHomeModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQGroupDynamicHomeModel : NSObject

/**
 活动地点
 */
@property (nonatomic, copy) NSString *addr;

/**
 活动时间
 */
@property (nonatomic, copy) NSString *time;

/**
 封面图高度
 */
@property (nonatomic, copy) NSString *cover_pic_height;

/**
 封面图宽度
 */
@property (nonatomic, copy) NSString *cover_pic_width;

/**
 封面图ID
 */
@property (nonatomic, copy) NSString *cover_pic_id;

/**
 活动标题
 */
@property (nonatomic, copy) NSString *title;

/**
 活动ID
 */
@property (nonatomic, copy) NSString *gaid;
// 二级需求类型
@property (nonatomic, copy) NSString *need_category_level_2;
// 需求类型
@property (nonatomic, copy) NSString *need_category_level_1;
// 是否匿名
@property (nonatomic, assign) BOOL need_truename;
// 需求Id
@property (nonatomic, copy) NSString *need_id;
// type true string 动态类型：主题=TYPE_TOPIC；需求=TYPE_NEED
@property (nonatomic, copy) NSString *type;
// id true string [主题]：主题ID
@property (nonatomic, copy) NSString *id;
// user_id true string [主题、需求]：发布者ID
@property (nonatomic, copy) NSString *user_id;
// user_name true string [主题、需求]：发布者姓名
@property (nonatomic, copy) NSString *user_name;
// user_tag true array[string] [主题、需求]：发布者tag
@property (nonatomic, strong) NSArray *user_tag;
// user_pic true string [主题、需求]：发布者头像
@property (nonatomic, copy) NSString *user_pic;
// user_idcard_status true string 主题、需求：发布者实名认证状态
@property (nonatomic, copy) NSString *user_idcard_status;
// user_creditscore true string 主题、需求：发布者信用分
@property (nonatomic, copy) NSString *user_creditscore;
// user_degree true string [主题、需求]：发布者与当前用户的好友度数
@property (nonatomic, copy) NSString *user_degree;
// createtime true string [主题、需求]：发布时间yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString *createtime;
// post_count true number [主题、需求]：回复数量
@property (nonatomic, copy) NSString *post_count;
// subject true string [主题]：主题名称
@property (nonatomic, copy) NSString *subject;
// content true string [主题]：主题内容
@property (nonatomic, copy) NSString *content;
// pic true string [主题]：主题配图，jsonarray格式
@property (nonatomic, strong) NSArray *pic;
// id true string [需求]：群内需求 ID(gnid)
 @property (nonatomic, copy) NSString *gnid;
// isFw true boolean [需求]：是否转发的需求
@property (nonatomic, assign) BOOL isFw;
// fw_content true number [需求]：转发内容
@property (nonatomic, copy) NSString *fw_content;
// need_subject true string [需求]：需求标题
@property (nonatomic, copy) NSString *need_subject;
// need_content true string [需求]：需求内容
@property (nonatomic, copy) NSString *need_content;
// need_finished_date true string [需求]：需求截止时间yyyy-MM-dd HH:mm:
@property (nonatomic, copy) NSString *need_finished_date;
// need_money true string [需求]：需求金额
@property (nonatomic, copy) NSString *need_money;
// need_distance true string [需求]：需求距离（米）
@property (nonatomic, copy) NSString *need_distance;
// need_status true string [需求]：需求状态
@property (nonatomic, copy) NSString *need_status;
// need_user_id true string [需求]：需求发布人的ID
@property (nonatomic, copy) NSString *need_user_id;
// need_user_name true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_name;
// need_user_tag true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_tag;
// need_user_pic true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_pic;
// need_user_idcard_status true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_idcard_status;
// need_user_creditscore true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_creditscore;
// need_user_degree true string [需求]：需求发布人的**
@property (nonatomic, copy) NSString *need_user_degree;

@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *link_txt;
@property (nonatomic, copy) NSString *link_img;

/**
 剩余时间   毫秒
 */
@property (nonatomic, copy) NSString *left_second;


/**
 转发的需求剩余时间 毫秒
 */
@property (nonatomic, copy) NSString *past_second;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL isTop;
@end
