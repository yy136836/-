//
//  WQUserProfileMomentModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserProfileMomentModel : NSObject

/**
 //id true string
 */
@property (nonatomic, copy) NSString * id;

/**
 //user_name true string
 */
@property (nonatomic, copy) NSString * user_name;

/**
 //user_pic true string
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //user_degree true string
 */
@property (nonatomic, retain) NSNumber * user_degree;

/**
 //user_creditscore true string
 */
@property (nonatomic, retain) NSNumber * user_creditscore;

/**
 //user_id true string
 */
@property (nonatomic, copy) NSString * user_id;

/**
 //user_tag true string
 */
@property (nonatomic, retain) NSArray * user_tag;

/**
 //user_followed true string
 */
@property (nonatomic, assign) BOOL user_followed;

/**
 //pic true string
 */
@property (nonatomic, retain) NSArray * pic;

/**
 //dislike_count true string
 */
@property (nonatomic, retain) NSNumber * dislike_count;

/**
 //like_count true string
 */
@property (nonatomic, retain) NSNumber * like_count;

/**
 //comment_count true string
 */
@property (nonatomic, retain) NSNumber * comment_count;

/**
 //reward_count true string
 */
@property (nonatomic, retain) NSNumber * reward_count;

/**
 //reward_totalmoney true string
 */
@property (nonatomic, retain) NSNumber * reward_totalmoney;

/**
 //fw_count true string
 */
@property (nonatomic, retain) NSNumber * fw_count;

/**
 //content true string
 */
@property (nonatomic, copy) NSString * content;

/**
 //link_img true string
 */
@property (nonatomic, copy) NSString * link_img;

/**
 //link_txt true string
 */
@property (nonatomic, copy) NSString * link_txt;

/**
 //link_url true string
 */
@property (nonatomic, copy) NSString * link_url;

/**
 //addr true string
 */
@property (nonatomic, copy) NSString * addr;

/**
 //geo_lat true string
 */
@property (nonatomic, copy)NSString * geo_lat;

/**
 //geo_lng true string
 */
@property (nonatomic, copy) NSString * geo_lng;

/**
 //cate true string
 */
@property (nonatomic, copy) NSString * cate;

/**
 //extras true string
 */
@property (nonatomic, retain) NSArray * extras;

/**
 //post_time true string
 */
@property (nonatomic, copy) NSString * post_time;

/**
 //past_second true string
 */
@property (nonatomic, retain) NSNumber * past_second;

/**
 //push_range true string
 */
@property (nonatomic, copy) NSString * push_range;

/**
 //can_like true string
 */
@property (nonatomic, assign) BOOL can_like;

/**
 //can_dislike true string
 */
@property (nonatomic, assign) BOOL can_dislike;

/**
 //can_reward true string
 */
@property (nonatomic, assign) BOOL can_reward;

/**
 //type true string
 */
@property (nonatomic, copy) NSString * type;



@end
