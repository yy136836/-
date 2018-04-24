//
//  WQUserEducationExperienceModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserEducationExperienceModel : NSObject


/**
 不知道是什么卵东西
 */
@property (nonatomic, copy) NSString * type;

/**
 开始时间
 */
@property (nonatomic, copy) NSString * education_start_time;

/**
 毕业学校
 */
@property (nonatomic, copy) NSString * education_school;

/**
 学位
 */
@property (nonatomic, copy) NSString * education_major;

/**
 毕业时间
 */
@property (nonatomic, copy) NSString * education_end_time;

/**
 education_degree
 */
@property (nonatomic, retain) NSNumber * education_degree;

/**
 认证者的列表
 */
@property (nonatomic, retain) NSArray * confirms;

/**
 认证人数
 */
@property (nonatomic, retain) NSNumber * confirmcount;

/**
 是否还可以认证
 */
@property (nonatomic, assign) BOOL can_confirm;
@end
