//
//  WQTopicModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQTopicModel : NSObject

/**
 //        tid true string 主题ID
 */
@property (nonatomic, copy) NSString * tid;

/**
 //        isOwner true string 当前用户是否为群主
 */
@property (nonatomic, assign) BOOL isOwner;


/**
 isAdmin true BOOL 当前用户是否为管理员或者群主,群主或者管理员有权限置顶或者删除帖子和评论
 */
@property (nonatomic, assign) BOOL isAdmin;


/**
 isTop true BOOL 当前帖子是否已经置顶
 */
@property (nonatomic, assign) BOOL isTop;

/**
 //        user_name true string 主题发布人的姓名
 */
@property (nonatomic, copy) NSString * user_name;


/**
 //        user_pic true string 主题发布人的头像
 */
@property (nonatomic, copy) NSString * user_pic;

/**
 //        user_id true string 主题发布人的用户ID
 */
@property (nonatomic, copy) NSString * user_id;

/**
 //        user_tag true string 主题发布人的Tag
 */
@property (nonatomic, copy) NSString * user_tag;

/**
 //        user_idcard_status true string 主题发布人的idcard_status
 */
@property (nonatomic, copy) NSString * user_idcard_status;


/**
 //        createtime true string 主题发布时间：yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString * createtime;

/**
 //        subject true string 主题的题目
 */
@property (nonatomic, copy) NSString * subject;

/**
 //        content true string 主题的正文
 */
@property (nonatomic, copy) NSString * content;

/**
 //        pic true string 主题的配图（JSONArray格式）
 */
@property (nonatomic, copy) NSArray * pic;

/**
 //        pic_with_width_height true string  主题的配图（图片数据和pic参数一样，但是多了每张图的高宽像素）
 */
@property (nonatomic, copy) NSArray * pic_with_width_height;

/**
 //        post_count true string 主题的一级回复总数
 */
@property (nonatomic, copy) NSString * post_count;

/**
 //        view_count true string 主题的阅读总数
 */
@property (nonatomic, copy) NSString * view_count;


/**
 用户的信用分
 */
@property (nonatomic, retain) NSNumber * user_creditscore;


/**
 好友度数
 二度内,三度,四度外
 */
@property (nonatomic, retain) NSNumber * user_degree;
@end
