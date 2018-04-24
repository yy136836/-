//
//  WQIndividualTrendSecondaryCommentModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQIndividualTrendSecondaryCommentModel : NSObject
/**
 //past_second true number
 */
@property (nonatomic, retain) NSNumber * past_second;

/**
 //user_pic true string
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //user_tag true array[string]
 */
@property (nonatomic, retain) NSArray<NSString *> * user_tag;

/**
 //user_id true string
 */
@property (nonatomic, copy) NSString * user_id;

/**
 //user_name true string
 */
@property (nonatomic, copy) NSString * user_name;

/**
 //can_delete true boolean
 */
@property (nonatomic, assign) BOOL can_delete;

/**
 //user_creditscore true number
 */
@property (nonatomic, retain) NSNumber * user_creditscore;

/**
 //id true string
 */
@property (nonatomic, copy) NSString * id;

/**
 //user_degree true number
 */
@property (nonatomic, retain) NSNumber * user_degree;

/**
 //content true string
 */
@property (nonatomic, copy) NSString * content;

/**
 //post_time true string
 */
@property (nonatomic, copy) NSString * post_time;


/**
 //reply_user（boolean，是否是回复某个用户）、
 */
@property (nonatomic, assign) BOOL reply_user;

/**
 reply_user_name、
 */
@property (nonatomic, copy) NSString * reply_user_name;

/**
 reply_user_degree、
 */
@property (nonatomic, retain) NSNumber * reply_user_degree;

/**
 reply_user_pic、
 */
@property (nonatomic, copy) NSString * reply_user_pic;

/**
 reply_user_id
 */
@property (nonatomic, copy) NSString * reply_user_id;



@end
