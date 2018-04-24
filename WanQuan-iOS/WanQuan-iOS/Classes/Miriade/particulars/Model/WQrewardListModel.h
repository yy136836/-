//
//  WQrewardListModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQrewardListModel : NSObject
//已过时间
@property(nonatomic,strong)NSNumber *past_second;
//打赏金额
@property(nonatomic,strong)NSString *money;
//打赏者头像
@property(nonatomic,copy)NSString *user_pic;
//打赏者 id
@property(nonatomic,copy)NSString *user_id;
//打赏者姓名
@property(nonatomic,copy)NSString *user_name;
// 打赏 id
@property(nonatomic,copy)NSString *id;
//发布时间
@property(nonatomic,copy)NSString *post_time;
@end
