//
//  WQSingleton.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/18.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseConversationModel.h"
#import <CoreLocation/CoreLocation.h>

@class WQloginModel;

#pragma mark - 全局数据存储

@interface WQDataSource : NSObject
+ (instancetype)sharedTool;

/**
 当前账户的姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 注册时是不是选择的以上都不是
 */
@property (nonatomic, assign) BOOL isAreNot;

@property (nonatomic, assign) BOOL userIsLogin;

/**
 是否是管理员
 */
@property (nonatomic, assign) BOOL isAdmin;

/**
 注册的密码
 */
@property (nonatomic, copy) NSString *password;

/**
 注册的手机号
 */
@property (nonatomic, copy) NSString *cellphone;

/**
 是否隐藏游客登录弹窗
 */
@property (nonatomic, assign) BOOL isHiddenVisitorsToLoginPopupWindowView;

/**
 校友通：是否成功加入圈子（当传plugin_alumnus_class_id参数时，返回该字段）
 */
@property (nonatomic, assign) BOOL join_alumnus_group_success;

/**
 后台是否进行了匹配
 */
@property (nonatomic, assign) BOOL join_alumnus_group_match;

/**
 secretkey
 */
@property (nonatomic, copy) NSString *secretkey;

/**
 是或否已认证
 */
@property (nonatomic, assign, getter=isVerified) BOOL verified;
/**
 当前账号用户id
 */
@property (nonatomic, copy) NSString *userIdString;

/**
 登录状态
 */
@property (nonatomic, copy) NSString *loginStatus;

/**
 工作经历
 */
@property (nonatomic, strong) NSArray *work_experienceArray;

/**
 初始点位地点
 */
@property(nonatomic,copy) NSString *orignalCity;

/**
 发布选择的城市
 */
@property(nonatomic,copy) NSString *mapSelectedCity;

/**
 初始定位经纬度
 */
@property(nonatomic,assign)CLLocationCoordinate2D location;

@property (nonatomic, copy) NSString *imageid;

@property(nonatomic,strong) NSMutableArray <EaseConversationModel *>* conversationModelArrayM;

@property(nonatomic,strong) NSMutableArray *IMFriendApplyInfoArrayM;

@end

#pragma mark - 登录数据逻辑

@interface WQSingleton : NSObject
    
/**
当前用户的环信 id
*/
@property (nonatomic, copy) NSString * userIMId;


/*
 WQ    分享到万圈
 WQHY  万圈好友
 WXQY_INVITE   邀请码
 
 NORMAL 正常
 */
@property (nonatomic, copy) NSString *platname;

+ (instancetype)sharedManager;

    
    
    
// 环信登录
+ (void)huanxinLoginWithUsername:(NSString *)username password:(NSString *)password;

// 归档
- (void)saveAccount:(WQloginModel *)account;
// 解档
- (WQloginModel *)loadUserAccount;

@property(nonatomic,strong)WQloginModel *loginModel;

/**
 口令是否过期
 */
@property (assign, nonatomic) BOOL isExpires;
/**
 用户是否登录
 */
@property (assign, nonatomic) BOOL isUserLogin;

@property(nonatomic, copy, readonly) NSString *archivePath;



@end
