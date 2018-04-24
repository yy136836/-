//
//  WQUserInfoModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 来自接口api/user/getbasicinfo
 */
@interface WQUserInfoModel : NSObject


/**
  true number 用户信用分
 */
@property (nonatomic, retain) NSNumber* credit_score;

/**
  true array[object] 教育经历
 */
@property (nonatomic, retain) NSArray * education;

/**
  true string 工作地区，比如：北京
 */
@property (nonatomic, copy) NSString * work_area;

/**
  true string 工作单位地址
 */
@property (nonatomic, copy) NSString * work_addr_name;

/**
  true string 花名头像ID,32位的头像照片ID
 */
@property (nonatomic, copy) NSString * pic_flowername;

/**
  true string 花名
 */
@property (nonatomic, copy) NSString * flower_name;

/**
 当前用户的认证状态实名认证状态：
 STATUS_UNVERIFY=未实名认证；
 STATUS_VERIFIED=已实名认证；
 STATUS_VERIFING=已提交认证正在等待管理员审批
 */
@property (nonatomic, copy) NSString * idcard_status;

/**
  true array[string] 身份证正反面照片,jsonarray格式，每个元素为一个照片的32位ID
 */
@property (nonatomic, retain) NSArray * idcard_pic;

/**
  true number 帮忙用户教育认证的人数
 */
@property (nonatomic, retain) NSNumber * education_confirm;

/**
  true string 真名
 */
@property (nonatomic, copy) NSString * true_name;

/**
  true string 注册时间
 */
@property (nonatomic, copy) NSString * datetime_reg;

/**
  true string 环信密码
 */
@property (nonatomic, copy) NSString * im_password;

/**
  true string 手机号码
 */
@property (nonatomic, copy) NSString * cellphone;

/**
  true array[string] 用户标签
 */
@property (nonatomic, retain) NSArray * tag;

/**
  true string 环信登录 id
 */
@property (nonatomic, copy) NSString * im_namelogin;

/**
 true array[object] 工作经历
 */
@property (nonatomic, retain) NSArray * work_experience;

/**
  true number 帮忙工作经历认证的人数
 */
@property (nonatomic, retain) NSNumber * work_confirm;

/**
  true string 真名头像ID,32位的头像照片ID
 */
@property (nonatomic, copy) NSString * pic_truename;

/**
  true string 工作方向、行业
 */
@property (nonatomic, copy) NSString * work_type;

/**
  true string 工作职务
 */
@property (nonatomic, copy) NSString * work_title;

/**
  true number 帮忙奖项认证的人数
 */
@property (nonatomic, retain) NSNumber * awards_confirm;

/**
  true string 工作单位
 */
@property (nonatomic, copy) NSString * work_unit;

/**
  true object 信用分详细信息（JSONObject）
 */
@property (nonatomic, retain) NSDictionary * credit_detail;

/**
  true boolean 是否成功
 */
@property (nonatomic, assign) BOOL success;

/**
 true array[object] 奖项资格证书
 */
@property (nonatomic, retain) NSArray * awards;

/**
  true string 身份证
 */
@property (nonatomic, copy) NSString * idcard;

/**
  true number 已接单的需求总数
 */
@property (nonatomic, retain) NSNumber * need_bidded_count;

/**
  true number 发布的需求总数
 */
@property (nonatomic, retain) NSNumber * need_count;

/**
  true boolean 是否是我的账号
 */
@property (nonatomic, assign) BOOL ismyaccount;

/**
  true boolean 登陆用户 与 被查看基本信息的用户 是否好友
 */
@property (nonatomic, assign) BOOL isfriend;

/**
 好友度数
 */
@property (nonatomic, assign) NSInteger user_degree;

/**
 //moments true array[object] 用户发布的动态（后台会自动过滤仅显示当前可以查看到的）
 */
@property (nonatomic, retain) NSArray * moments;

/**
 //needs true array[object] 用户发布的需求（后台会自动过滤仅显示当前可以查看到的）
 */
@property (nonatomic, retain) NSArray * needs;

/**
 //groups true array[object] 用户加入的圈子（后台会自动过滤仅显示当前可以查看到的）
 */
@property (nonatomic, retain) NSArray * groups;

/**
 //pic_bg true string 用户的背景图片ID
 */
@property (nonatomic, copy) NSString * pic_bg;

/**
 是否已关注该用户
 */
@property (nonatomic, assign) BOOL user_followed;


@property (nonatomic, assign) BOOL groups_show_all;

@end
