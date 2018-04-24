//
//  WQmyFriendsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 好友的模型
 */
@interface WQmyFriendsModel : NSObject

/**
 好友请求的 ID 只有当该好友请求成为我的好友才有该 ID
 */
@property(nonatomic, copy) NSString * friend_apply_id;



/**
 //信用分
 */
@property(nonatomic,assign)int credit_score;

/**
 // 真名头像
 */
@property(nonatomic,copy)NSString *pic_truename;

/**
 //学历
 */
@property(nonatomic,assign)int degree;

/**
 //工作类型
 */
@property(nonatomic,copy)NSString *work_type;

/**
 //工作职位
 */
@property(nonatomic,copy)NSString *work_title;

/**
 //工作区域
 */
@property(nonatomic,copy)NSString *work_area;

/**
 //工作单位详细位置
 */
@property(nonatomic,copy)NSString *work_addr_name;

/**
 //花名头像
 */
@property(nonatomic,copy)NSString *pic_flowername;

/**
 //花名
 */
@property(nonatomic,copy)NSString *flower_name;

/**
 //工作单位
 */
@property(nonatomic,copy)NSString *work_unit;

/**
 /信用分详情
 */
@property(nonatomic,strong)id credit_detail;

/**
 //用户 id
 */
@property(nonatomic,copy)NSString *user_id;

/**
 //真名
 */
@property(nonatomic,copy)NSString *true_name;

/**
 //共同好友数
 */
@property(nonatomic,assign)int common_friend_count;

/**
 //标签列表
 */
@property(nonatomic,strong)NSArray *tag;

@end
