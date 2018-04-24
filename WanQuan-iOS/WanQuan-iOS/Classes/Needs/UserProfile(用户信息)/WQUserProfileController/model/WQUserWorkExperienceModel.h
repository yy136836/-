//
//  WQUserWorkExperienceModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserWorkExperienceModel : NSObject

/**
 工作开始时间
 */
@property (nonatomic, copy) NSString * work_start_time;

/**
 职位
 */
@property (nonatomic, copy) NSString * work_position;
//"iOS开发工程师"

/**
 工作单位
 */
@property (nonatomic, copy) NSString * work_enterprise;
//"清华大学创意创业创新教育平台"

/**
 工作结束时间
 */
@property (nonatomic, copy) NSString * work_end_time;
//"至今"

/**
 不知道是啥
 */
@property (nonatomic, copy) NSString * type;
//"74e7871a2cac4a30a72eefbe41d58080"

/**
 认证人信息
 */
@property (nonatomic, retain) NSArray * confirms;
//...

/**
 认证人数
 */
@property (nonatomic, retain) NSNumber * confirmcount;
//2

/**
 是否可认证
 */
@property (nonatomic, assign) BOOL can_confirm;
@end
