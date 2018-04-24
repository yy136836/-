//
//  WQPeopleWhoAreInterestedInModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/26.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPeopleWhoAreInterestedInModel : NSObject

/**
 信用分
 */
@property (nonatomic, copy) NSString *creditscore;

/**
 几度好友
 */
@property (nonatomic, copy) NSString *degree;

/**
 是否关注
 */
@property (nonatomic, assign) BOOL followed;

/**
 头像
 */
@property (nonatomic, copy) NSString *pic_truename;

/**
 标签数组
 */
@property (nonatomic, strong) NSArray *tag;

/**
 姓名
 */
@property (nonatomic, copy) NSString *true_name;

/**
 用户id
 */
@property (nonatomic, copy) NSString *user_id;

@end
