//
//  WQdetailsConrelooerViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WQOrderType) {
    WQOrderTypeSelected = 0,   // 选中订单
    WQOrderTypeEnsure,         // 确认订单
    WQOrderTypeFinish,         // 完成订单
    WQDefaultTasks,            // 默认滚动
    WQinarchstay,              // 我接的订单"待接单"
    WQHomePushToDetailsVc,     // 从首页push过来的
};

@interface WQdetailsConrelooerViewController : UIViewController

@property (nonatomic, copy) NSString *midString;
- (instancetype)initWithmId:(NSString *)mid wqOrderType:(WQOrderType)orderType;
- (instancetype)initWithindex:(WQOrderType )index;
- (instancetype)initWithmId:(NSString *)mid index:(WQOrderType )index;


@property (nonatomic, assign) BOOL FromHome;  //yes 首页

@end
