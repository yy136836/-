//
//  WQreplyModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQreplyModel : NSObject
//提醒类型：状态、话题、主题
@property (copy, nonatomic) NSString *notice_cate;
//万圈 id
@property (copy, nonatomic) NSString *moment_id;
//用户图像
@property (copy, nonatomic) NSString *user_pic;
//用户 id
@property (copy, nonatomic) NSString *user_id;
//用户名
@property (copy, nonatomic) NSString *user_name;
//状态、话题、主题
@property (copy, nonatomic) NSString *moment_type;
//发布时间
@property (copy, nonatomic) NSString *post_time;
@property (copy, nonatomic) NSString *content;
//已经经过的时间
@property(assign, nonatomic) NSInteger past_second;
@end
