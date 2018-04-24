//
//  WQzanLike_listModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQzanLike_listModel : NSObject
//距离赞时间已过秒数
@property(nonatomic,assign)int past_second;
//用户头像
@property(nonatomic,copy)NSString *user_pic;
//用户id
@property(nonatomic,copy)NSString *user_id;
//用户姓名
@property(nonatomic,copy)NSString *user_name;
//赞id
@property(nonatomic,copy)NSString *id;
//发布时间
@property(nonatomic,copy)NSString *post_time;
@end
