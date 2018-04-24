//
//  WQHasJoinedWanQuanWorkModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQHasJoinedWanQuanWorkModel : NSObject

/**
 "work_end_time" = "至今"; 截止时间
 */
@property (nonatomic, copy) NSString *work_end_time;

/**
 "work_enterprise" = "清华大学经济管理学院";
 */
@property (nonatomic, copy) NSString *work_enterprise;

/**
 "work_position" = "校友发展和企业合作总监";
 */
@property (nonatomic, copy) NSString *work_position;

/**
 "work_start_time" = "2003-08";
 */
@property (nonatomic, copy) NSString *work_start_time;
@end
