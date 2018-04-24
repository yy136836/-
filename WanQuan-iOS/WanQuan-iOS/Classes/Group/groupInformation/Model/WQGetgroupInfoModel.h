//
//  WQGetgroupInfoModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQGetgroupInfoModel : NSObject
// gid true string 群组ID
@property (nonatomic, copy) NSString *gid;
// name true string 群组名称
@property (nonatomic, copy) NSString *name;
// createtime true string 群组创建日期（yyyy-MM-dd）
@property (nonatomic, copy) NSString *createtime;
// description true string 群组描述
@property (nonatomic, copy) NSString *description;
// fee true string 入群需要的会员费
@property (nonatomic, copy) NSString *fee;
// member_count true string 群内正式加入的成员总数
@property (nonatomic, copy) NSString *member_count;
// isOwner true string 当前会用是否为该群的群主
@property (nonatomic, assign) BOOL isOwner;
// 当前账户是否是群内成员
@property (nonatomic, assign) BOOL isMember;
// pic true string 群组的头像ID
@property (nonatomic, copy) NSString *pic;
// pic_width true string 群组的头像的像素宽度
@property (nonatomic, copy) NSString *pic_width;
// pic_height true string 群组的头像的像素高度
@property (nonatomic, copy) NSString *pic_height;
// new_member_count true string 群组的新加入（待群组批准）成员总数
 @property (nonatomic, copy) NSString *fresh_member_count;
// owner_id true string 群主的用户ID
@property (nonatomic, copy) NSString *owner_id;
// owner_name true string 群主的姓名
@property (nonatomic, copy) NSString *owner_name;
// owner_pic true string 群主的头像
@property (nonatomic, copy) NSString *owner_pic;
// owner_tag true string 群主的Tag
@property (nonatomic, copy) NSString *owner_tag;
// owner_idcard_status true string 群主的idcard_status（STATUS_UNVERIFY=未通过实名认证；STATUS_VERIFING=待管理员审批实名认证；STATUS_VERIFIED=通过实名认证）
@property (nonatomic, copy) NSString *owner_idcard_status;

/**
 是否是私密圈
 */
@property (nonatomic, copy) NSString *privacy;

/**
 是否是管理员
 */
@property (nonatomic, assign) BOOL isAdmin;
@end
