//
//  WQUserProfileChoiestArticleModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQEssenceDataEntity.h"

@interface WQUserProfileChoiestArticleModel : NSObject <WQEssenceDataEntity>

/**
 //createtime true string
 */
@property (nonatomic, copy) NSString * createtime;

/**
 //createtime_past_second true string
 */
@property (nonatomic, copy) NSString * createtime_past_second;

/**
 //modifytime true string
 */
@property (nonatomic, copy) NSString * modifytime;

/**
 //modifytime_past_second true string
 */
@property (nonatomic, copy) NSString * modifytime_past_second;

/**
 //user_idcard_status true string
 */
@property (nonatomic, copy) NSString * user_idcard_status;

/**
 //favorite_id true string
 */
@property (nonatomic, copy) NSString * favorite_id;

/**
 //favorited true string
 */
@property (nonatomic, assign) BOOL favorited;

/**
 //carousel_pic true string
 */
@property (nonatomic, copy) NSString * carousel_pic;

/**
 //cover_pic true string
 */
@property (nonatomic, copy) NSString * cover_pic;

/**
 //desc true string
 */
@property (nonatomic, copy) NSString * desc;

/**
 //subject true string
 */
@property (nonatomic, copy) NSString * subject;

/**
 //tags true string
 */
@property (nonatomic, copy) NSString * tags;

/**
 //views true string
 */
@property (nonatomic, copy) NSString * views;


@property (nonatomic, assign) NSInteger like_count;

@property (nonatomic, copy) NSString * id;
@end
