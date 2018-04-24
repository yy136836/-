//
//  WQNoneOfTheAboveModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQNoneOfTheAboveModel : NSObject

/**
 用户id
 */
@property (nonatomic, copy) NSString *user_id;

/**
 当前状态
 */
@property (nonatomic, copy) NSString *user_idcard_status;

/**
 姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 头像
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 标签
 */
@property (nonatomic, strong) NSArray *user_tag;
@end
