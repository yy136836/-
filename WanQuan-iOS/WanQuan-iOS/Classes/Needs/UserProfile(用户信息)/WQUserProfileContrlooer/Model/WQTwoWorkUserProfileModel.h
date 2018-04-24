//
//  WQTwoWorkUserProfileModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQTwoWorkconfirmsModel;

@interface WQTwoWorkUserProfileModel : NSObject
@property (nonatomic, strong) NSArray<WQTwoWorkconfirmsModel *> *confirms;
//公司名称
@property (nonatomic, copy) NSString *work_enterprise;
//工作开始时间
@property (nonatomic, copy) NSString *work_start_time;
//工作结束时间
@property (nonatomic, copy) NSString *work_end_time;
//工作职位
@property (nonatomic, copy) NSString *work_position;
//工作具体描述
@property (nonatomic, copy) NSString  *work_detail;
//工作ID
@property (nonatomic, copy) NSString *type;
//学校名称
@property (nonatomic, copy) NSString *education_school;
//教育经历开始时间
@property (nonatomic, copy) NSString *education_start_time;
//教育经历结束时间
@property (nonatomic, copy) NSString *education_end_time;
//专业
@property (nonatomic, copy) NSString  *education_major;

/**
 是否可以认证
 */
@property (nonatomic, copy) NSString * can_confirm;
//学位（1：小学 2：中学 3：本科，4：硕士，5：博士）
@property (nonatomic, assign) int education_degree;
@end
