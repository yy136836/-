//
//  WQCircleApplyModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCircleApplyModel : NSObject




//"group_id" = 5ab0d899ed304ba4b9353b8812c28955;
//"group_name" = "中国足球";
//"group_user_id" = f59335ec722948f49a982ca01dfd454f;
//message = "";
//"user_degree" = 2;
//"user_id" = 8a84238448ad41b8843eebf2cbbecec8;
//"user_idcard_status" = "STATUS_VERIFIED";
//"user_name" = "郭杭";
//"user_pic" = 11792bbd11a14e089a247fccf7cff973;
//"user_score" = 69;
//"user_tag" =             (
//                          "清华大学社会创新和风险管理中心",
//                          "郑州大学"
//                          );


/**
  true string guid：成员在该群中的唯一ID
 */
@property(nonatomic, copy)NSString * group_user_id;

/**
  true string 成员姓名
 */
@property(nonatomic, copy)NSString * user_name;

/**
 true string 成员用户ID
 */
@property(nonatomic, copy)NSString * user_id;

/**
 true string 成员头像
 */
@property(nonatomic, copy)NSString * user_pic;

/**
 true string 成员Tag
 */
@property(nonatomic, copy)NSString * user_tag ;

/**
  true string 成员idcard_status
 */
@property(nonatomic, copy)NSString * user_idcard_status;

/**
  true string 验证信息
 */
@property(nonatomic, copy)NSString * message;

/**
  true string 群组ID
 */
@property(nonatomic, copy)NSString * group_id;

/**
 true string
 */
@property(nonatomic, copy)NSString * group_name;

/**
 true string 信用分
 */
@property(nonatomic, copy)NSString * user_score;

/**
  true string 好友度数
 */
@property(nonatomic, copy)NSString * user_degree;
@end
