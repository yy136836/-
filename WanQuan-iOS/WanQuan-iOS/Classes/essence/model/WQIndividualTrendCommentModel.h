//
//  WQEssenceCommentModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/10.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQIndividualTrendSecondaryCommentModel.h"

@interface WQIndividualTrendCommentModel : NSObject

/**
 //ike_count true number
 */
@property (nonatomic ,retain) NSNumber * ike_count;

/**
 //user_tag true array[string]
 */
@property (nonatomic, retain) NSArray * user_tag;

/**
 //user_name true string
 */
@property (nonatomic, copy) NSString * user_name;

/**
 //comment_children true array
 */
@property (nonatomic, retain) NSArray<WQIndividualTrendSecondaryCommentModel *> * comment_children;

/**
 //content true string
 */
@property (nonatomic, copy) NSString * content;

/**
 //post_time true string
 */
@property (nonatomic, copy) NSString * post_time;

/**
 //past_second true number
 */
@property (nonatomic, retain) NSNumber * past_second;

/**
 //user_pic true string
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //user_id true string
 */
@property (nonatomic, copy) NSString * user_id;

/**
 //can_delete true boolean
 */
@property (nonatomic, assign) BOOL can_delete;

/**
 //comment_children_count true number
 */
@property (nonatomic, retain) NSNumber * comment_children_count;

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
@end
