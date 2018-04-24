//
//  WQHasJoinedWanQuanModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQHasJoinedWanQuanWorkModel,WQHasJoinedWanQuanEducationModel;

@interface WQHasJoinedWanQuanModel : NSObject

/**
 user_name true string 成员姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 user_id true string 成员ID
 */
@property (nonatomic, copy) NSString *user_id;

/**
 user_pic true string 成员头像
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 user_idcard_status true string 成员身份认证状态
 */
@property (nonatomic, copy) NSString *user_idcard_status;

/**
 user_tag true array[string] 成员标签
 */
@property (nonatomic, strong) NSArray *user_tag;

/**
 user_work_experience true array[object] 成员工作经历
 */

@property (nonatomic, strong) NSMutableArray <WQHasJoinedWanQuanWorkModel *>*user_work_experience;

/**
 user_education_experience true array[object] 成员学习经历
 */
@property (nonatomic, strong) NSMutableArray <WQHasJoinedWanQuanEducationModel *>* user_education_experience;

@end

