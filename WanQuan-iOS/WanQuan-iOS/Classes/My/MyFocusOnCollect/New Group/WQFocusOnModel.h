//
//  WQFocusOnModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQFocusOnModel : NSObject

/**
 是否相互关注
 */
@property (nonatomic, assign) BOOL both_follow;

/**
 用户id
 */
@property (nonatomic, copy) NSString *user_id;

/**
 姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *user_pic;

/**
 好友度数
 */
@property (nonatomic, copy) NSString *user_degree;

/**
 用户信用分
 */
@property (nonatomic, copy) NSString *user_creditscore;

/**
 标签数组
 */
@property (nonatomic, strong) NSArray *user_tag;

/**
 关注信息id
 */
@property (nonatomic, copy) NSString *id;

/**
 关注时间
 */
@property (nonatomic, copy) NSString *datetime;

@end
