//
//  WQPendingNewFriendModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPendingNewFriendModel : NSObject

@property (nonatomic, copy) NSString * friend_apply_id;
@property (nonatomic, copy) NSString * friend_apply_message;

/**
 发起好友申请距现在时间的秒数
 */
@property (nonatomic, copy) NSString * passed_secends;

@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * true_name;
@property (nonatomic, copy) NSString * pic_truename;
@property (nonatomic, copy) NSString * flower_name;
@property (nonatomic, copy) NSString * pic_flowername;
@property (nonatomic, copy) NSString * work_area;
@property (nonatomic, copy) NSString * work_type;
@property (nonatomic, copy) NSString * work_unit;
@property (nonatomic, copy) NSString * work_addr_name;
@property (nonatomic, copy) NSString * work_title;
@property (nonatomic, copy) NSString * tag;
@property (nonatomic, copy) NSString * creditscore;
@property (nonatomic, copy) NSString * degree;
@property (nonatomic, copy) NSString * common_friend_count;
@end
