//
//  WQGroupModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQGroupModel : NSObject



/**
  true string 群ID
 */
@property (nonatomic, copy) NSString * gid;

/**
 true string 群名称
 */
@property (nonatomic, copy) NSString * name;

/**
 true string 群内已正式加入的成员总数
 */
@property (nonatomic, copy) NSString * member_count;

/**
 true string 当前用户是否为该群的群主
 */
@property (nonatomic, copy) NSString * isOwner;

/**
 true string 加入该群的时间：yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString * joined_datetime;

/**
 true string 最新的主题的标题
 */
@property (nonatomic, copy) NSString * latest_topic_name;

/**
  true string 群头像
 */
@property (nonatomic, copy) NSString * pic;


/**
 isMember 是否是该群的成员
 */
@property (nonatomic, assign) BOOL isMember;


/**
 latest_topic_user_name true string 最新发布主题的作者姓名
 */
@property (nonatomic, copy) NSString *latest_topic_user_name;

/**
 latest_topic_user_pic true string 最新发布主题的作者头像
 */
@property (nonatomic, copy) NSString *latest_topic_user_pic;

/**
 set_top true string （当前是否已为置顶）
 */
@property (nonatomic, copy) NSString *set_top;

/**
 是否是私密圈
 */
@property (nonatomic, copy) NSString *privacy;


/**
 未读新标题
 */
@property (nonatomic, copy) NSString *unread_count;

/**
    最新发布的内容的标题
 */
@property (nonatomic, copy) NSString *latest_title;
/**
 最新发布的内容的的作者
 */
@property (nonatomic, copy) NSString *latest_user_name;
/**
 最新发布的内容的的头像
 */
@property (nonatomic, copy) NSString *latest_user_pic;




@end
