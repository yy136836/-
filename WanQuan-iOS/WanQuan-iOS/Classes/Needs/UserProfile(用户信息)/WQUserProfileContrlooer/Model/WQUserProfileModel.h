//
//  WQUserProfileModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/5.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeNearbyTagModel.h"

@class WQTwoUserProfileModel,WQcertificationModel;

@interface WQUserProfileModel : NSObject
//工作经历
@property (nonatomic, strong) NSArray<WQTwoUserProfileModel *> *work_experience;
//教育经历
@property (nonatomic, strong) NSArray<WQTwoUserProfileModel *> *education;
//信用分详细信息
@property (nonatomic, strong) id credit_detail;
//奖项资格证书
@property (nonatomic, strong) NSArray *awards;
//标签
@property (nonatomic, strong) NSArray *tag;
//真名
@property (nonatomic, copy) NSString *true_name;
//花名
@property (nonatomic, copy) NSString *flower_name;
//花名头像
@property (nonatomic, copy) NSString *pic_flowername;
//环信id
@property (nonatomic, copy) NSString *im_namelogin;
//真名头像
@property (nonatomic, copy) NSString *pic_truename;
//身份证号
@property (nonatomic, copy) NSString *idcard;
//发布的需求总数
@property (nonatomic, assign) int need_count;
//已接单的需求总数
@property (nonatomic, assign) int need_bidded_count;
//用户信用分
@property (nonatomic, assign) CGFloat credit_score;

@property (nonatomic, copy) NSString * can_confirm;

@property (nonatomic, copy)NSString * cellphone;

/**
 当前用户的认证状态实名认证状态：
 STATUS_UNVERIFY=未实名认证；
 STATUS_VERIFIED=已实名认证；
 STATUS_VERIFING=已提交认证正在等待管理员审批
 */
@property (nonatomic, copy) NSString * idcard_status;


/**
 仅在新的好友页面表示用户的 id
 */
@property (nonatomic, retain) NSString * user_id;

/**
 当是要接受好友请求时才是 yes
 */
@property (nonatomic, assign) BOOL * isAdd;


//friendCounttruenumber好友数量
@property (nonatomic, assign) int friendCount;
//balance钱包余额
@property (nonatomic, copy) NSString *balance;
@end
