//
//  WQPeopleListModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQPeopleListModel;

@interface WQPeopleListModelArray : NSObject
@property(nonatomic,strong)NSArray <WQPeopleListModel *>*bids;
@end

@interface WQPeopleListModel : NSObject
//发布时间
@property(nonatomic,copy)NSString *posttime;
//用户头像
@property(nonatomic,copy)NSString *user_pic;
//用户id
@property(nonatomic,copy)NSString *user_id;
//用户名称
@property(nonatomic,copy)NSString *user_name;
//用户手机
@property(nonatomic,copy)NSString *user_phone;
//需求投标
@property(nonatomic,copy)NSString *id;
//投标文字
@property(nonatomic,copy)NSString *text;
//状态
@property(nonatomic,copy)NSString *status;
//接单者工作状态
@property(nonatomic,copy)NSString *work_status;
//已接单时间
@property(nonatomic,copy)NSString *work_status_time;
@property(nonatomic,assign)BOOL truename;
@property (nonatomic, assign) BOOL isfeedbacked;
@property (nonatomic, copy) NSString *can_feedback;
@property (nonatomic, copy) NSString *user_degree;
@property (nonatomic, copy) NSString *user_creditscore;
// 接单者用户的状态
@property (nonatomic, copy) NSString *user_idcard_stauts;
@end
