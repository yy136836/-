//
//  AppDelegate+WQPushHandler.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (WQPushHandler)
- (void)setupJPushWithLauchOptions:(NSDictionary *)launchOptions;
- (void)resetAppBadge;
- (void)pushOpenAPP:(NSDictionary *)launchOptions;
@end
