//
//  WQDetailsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeSelected = 0,   // 待订单
    OrderTypeEnsure,         // 订单进行中
    OrderTypeFinish,         // 完成订单
};

@interface WQDetailsViewController : UIViewController

- (instancetype)initWithid:(NSString *)needid wqOrderType:(OrderType)orderType;

@end
