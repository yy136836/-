//
//  AppDelegate.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 郭杭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMClientDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "WXApi.h"
#import "JPUSHService.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, EMClientDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,WXApiDelegate> {
    BMKMapManager* _mapManager;
}
@property (nonatomic, strong) NSDictionary *launchOptions;
@property (strong, nonatomic) UIWindow *window;

/**
 当程序启动或者受到推送后看是否需要改变订单状态
 */
- (void)updateBidStatus;

@end

