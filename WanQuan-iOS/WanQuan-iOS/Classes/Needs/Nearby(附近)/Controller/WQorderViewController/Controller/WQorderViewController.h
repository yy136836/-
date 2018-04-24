//
//  WQorderViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQHomeNearbyTagModel;



/**
 root->首页->订单详情
 */
@interface WQorderViewController : UIViewController

- (instancetype)initWithUserId:(WQHomeNearbyTagModel *)homeNearbyTagModel add:(NSString *)distance;
- (instancetype)initWithNeedsId:(NSString *)needsId;

@property (nonatomic, strong)WQHomeNearbyTagModel *homeNearbyTagModel;
@property (nonatomic, copy) NSString *creditPoints;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *user_degree;
@property (nonatomic, assign) BOOL isIPickUpTheOrder;

/**
 是否来自临时询问
 */
@property (nonatomic, assign) BOOL fromTemp;

/**
 是否从首页订单过来
 */
@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, assign) BOOL FromHome;  //yes 首页



@end
