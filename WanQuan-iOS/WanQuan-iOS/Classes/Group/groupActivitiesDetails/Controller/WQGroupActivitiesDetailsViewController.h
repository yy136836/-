//
//  WQGroupActivitiesDetailsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/20.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQGroupActivitiesDetailsViewController : UIViewController

/**
 删除成功
 */
@property (nonatomic, copy) void(^deleteSuccessBlock)();

/**
 置顶成功 | 取消置顶成功
 */
@property (nonatomic, copy) void(^settopSuccessBlock)();

@property (nonatomic, copy) NSString *urlString;


@property (nonatomic,copy)NSString *shareUrl;


/**
 活动时间
 */
@property (nonatomic, copy) NSString *time;

/**
 活动地点
 */
@property (nonatomic, copy) NSString *addr;

/**
 活动图片
 */
@property (nonatomic, copy) NSString *pic;

/**
 活动title
 */
@property (nonatomic, copy) NSString *title;

/**
 活动Id
 */
@property (nonatomic, copy) NSString *gaid;

/**
 是否是管理员
 */
@property (nonatomic, assign) BOOL isAdmin;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL isTop;

@end
