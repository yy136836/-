//
//  AppDelegate+WQPushHandler.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "AppDelegate+WQPushHandler.h"
#import "JPUSHService.h"
#import "WQTabBarController.h"
#import "WQMessageViewController.h"
//#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+EaseMob.h"

#import "WQSystemMessageController.h"
#import "WQGroupDynamicViewController.h"
#import "WQCircleApplyListController.h"
#import "WQorderViewController.h"
#import "WQMyReceivinganOrderViewController.h"
#import "WQnewFriendsViewController.h"
#import "WQdetailsConrelooerViewController.h"

#import "WQStartPageViewController.h"

@implementation AppDelegate (WQPushHandler)


- (void)setupJPushWithLauchOptions:(NSDictionary *)launchOptions {
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity
                                             delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"fe54860f6ce9e780a3a79199"
                          channel:@"App Store"
#ifdef DEBUG
                 apsForProduction:0
#else
                 apsForProduction:1
#endif
            advertisingIdentifier:nil];
    
    [self resetAppBadge];
    
    
    
    //    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}
#pragma mark - 环信 + push
- (void)easemobApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK

/**
 成功注册远程推送
 
 @param application  app
 @param deviceToken 返回的 deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [[EMClient sharedClient] bindDeviceToken:deviceToken];
                   });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误

/**
 远程推送注册失败
 
 @param application  app
 @param error 错误的原因
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}




/**
 系统收到远程推送 高于 ios6版本使用该函数处理
 
 @param application app
 @param userInfo userInfo
 @param completionHandler completionHandler
 */
// 接受到推送
#warning 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    NSInteger apnsCount = [[NSUserDefaults standardUserDefaults] objectForKey:WQ_APNS_NUM_KEY]? [[[NSUserDefaults standardUserDefaults] objectForKey:WQ_APNS_NUM_KEY] integerValue] : 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++ apnsCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(apnsCount) forKey:WQ_APNS_NUM_KEY];
    
    [self activateAPP:userInfo];
    
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




/**
 系统收到远程推送仅当 系统低于 ios6 版本使用该函数处理
 
 @param application application
 @param userInfo userInfo
 已弃用
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

/**
 处理本地推送低于 ios10 使用该函数
 
 @param application application description
 @param notification notification description
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([self.window.rootViewController isKindOfClass:[WQTabBarController class]]) {
        [(WQTabBarController *)self.window.rootViewController didReceiveLocalNotification:notification];
    }
}




/**
 * 处理推送的点击，为相应的部分添加红点添加红点
 */
-(void)dealWithNotification:(NSDictionary *)userInfo {
    
    //    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:userInfo.description  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    //    [alert show];
    
    if(userInfo == nil || ![self.window.rootViewController isKindOfClass:[WQTabBarController class]]) return;
    WQTabBarController *mainVC = (WQTabBarController *)self.window.rootViewController;
    //    NSString *operation = [userInfo objectForKey:@"operation"];
    if (![mainVC isKindOfClass:[WQTabBarController class]]) {
        return;
    }
    
    //环信的远程推送
    //    环信 apns 的结构
    //    {
    //        "aps":{
    //            "alert":"自定义信息",
    //            "badge":1,
    //            "sound":"default"
    //        },
    //        "f":"6001",
    //        "t":"6006",
    //        "m":"14aec1e00ef",
    //        "e":"扩展内容"
    //    }
    if (userInfo[@"e"][@"extern"]) {
        //        订单消息
        if ([userInfo[@"e"][@"extern"][@"nid"] length]) {
            
            [self handleBidMessageWithBid:userInfo[@"e"][@"extern"][@"nid"] bidStatus:nil] ;
        }
        //        好友消息
        if (![userInfo[@"e"][@"extern"][@"nid"] length]) {
            
            [self handleFriendChatAPNS];
        }
    }
    NSString * chatter = userInfo[@"ConversationChatter"];
    //    如果有 chatter 字段则是环信本地推送的
    if (chatter) {
        [self handleBidMessageWithBid:nil bidStatus:nil];
        return;
    }
    
    NSString *needId = [userInfo objectForKey:@"nid"];//需求id
    
    //    否则就是来自极光的的推送
    if (!needId) {
        needId = userInfo[@"id"];
    }
    
    {
        
        
        //    "ios": {
        //        "alert": "你发的XX订单已有接单者XX接单了",
        //        "extras": {
        //            "operation": "open_needbid",
        //            "id":"..here is needbid id..."
        //        }
        //    }
    }
    
    
    if (needId) {
        NSString * status = userInfo[@"operation"];
        
        
        [self handleBidMessageWithBid:needId bidStatus:status];
    }
    
    
    
}


- (void)handleFriendChatAPNS {
    if(![self.window.rootViewController isKindOfClass:[WQTabBarController class]]) {
        return;
    }
    WQTabBarController *mainVC = (WQTabBarController *)self.window.rootViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        mainVC.selectedIndex = 3;
        UINavigationController * nc = mainVC.viewControllers[3];
        WQMessageViewController * vc = nc.viewControllers[0];
        //      [vc clickAtMessage];
    });
}

/**
 处理订单推送
 
 @param bid 订单号可为空 为空则是订单的聊天相关的推送否则是单纯地订单推送
 @param status  “open_need”：用户作为发单者，点击后，打开某个需求的发单者操作页面
 “open_needbid”：用户作为接单者，点击后，打开某个需求的接单者操作页面
 */
- (void)handleBidMessageWithBid:(NSString *)bid bidStatus:(NSString * )status {
    if(![self.window.rootViewController isKindOfClass:[WQTabBarController class]]) {
        return;
    }
    
    
    if ((! bid) && (! status)) {
        [self handleFriendChatAPNS];
        return;
    }
    
    
    if (bid && status) {
    }
    
    WQTabBarController *mainVC = (WQTabBarController *)self.window.rootViewController;
    
   // mainVC.selectedIndex = 3;
    
    //    WQMyViewController * my = [(UINavigationController *)(mainVC.viewControllers.lastObject) viewControllers].lastObject;
    
    if (bid) {
        //        “open_need”：用户作为发单者，点击后，打开某个需求的发单者操作页面
        //        “open_needbid”：用户作为接单者，点击后，打开某个需求的接单者操作页面
        
        
        if ([status isEqualToString:@"open_need"]) {
            //            [my tableView:my.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            //            WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc] initWithmId:bid wqOrderType:WQOrderTypeSelected];
            //            [mainVC.selectedViewController pushViewController:vc animated:YES];
            
            
        }
        
        if ([status isEqualToString:@"open_needbid"]) {
            //            [my tableView:my.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            //            WQorderViewController *vc = [[WQorderViewController alloc] initWithNeedsId:bid];
            //            [mainVC.selectedViewController pushViewController:vc animated:YES];
            
        }
    }
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support //
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    
    //    NSInteger apnsCount = [[NSUserDefaults standardUserDefaults] objectForKey:WQ_APNS_NUM_KEY]? 0 :[[[NSUserDefaults standardUserDefaults] objectForKey:WQ_APNS_NUM_KEY] integerValue];
    //
    //    if (apnsCount) {
    //        [UIApplication sharedApplication].applicationIconBadgeNumber = ++ apnsCount;
    //        [[NSUserDefaults standardUserDefaults] setInteger:apnsCount forKey:WQ_APNS_NUM_KEY];
    //
    //        BOOL success = [JPUSHService setBadge:apnsCount];
    //
    //        NSLog(@"%d",success);
    //    }
    //
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    
    [self updateBidStatus];
}

// iOS 10 Support //极光处理透传的点击旗帜的事件//远程是和本地的推送都是这
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    [self updateBidStatus];
    
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self activateAPP:userInfo];
    //    环信远程推送
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //处理收到的推送消息，添加红点
   // [self dealWithNotification:userInfo];
    
    completionHandler();  // 系统要求执行这个方法
}
/*
 
 "ios": {
 "alert": "你发的XX订单已有接单者XX接单了",
 "extras": {
 "operation": "open_needbid",
 "id":"..here is needbid id..."
 }
 }
 
 */


- (void)activateAPP:(NSDictionary *)userInfo
{
        NSString *operation = [NSString stringWithFormat:@"%@",userInfo[@"operation"]];
        NSString *pId = [NSString stringWithFormat:@"%@",userInfo[@"id"]];

        if ([operation rangeOfString:@"open_message"].location != NSNotFound) {//系统消息
            [self judgePush:@"WQSystemMessageController" PushID:nil IsOwn:NO] ;
        }else if ([operation rangeOfString:@"open_group"].location != NSNotFound){//圈主页
           // b73ef50661c84260945d08463fdc8735
            [self judgePush:@"WQGroupDynamicViewController" PushID:pId IsOwn:NO];
        }else if ([operation rangeOfString:@"open_applyJoinGroup"].location != NSNotFound){//入圈申请
            [self judgePush:@"WQCircleApplyListController" PushID:nil IsOwn:NO];
        }else if ([operation rangeOfString:@"open_needbid"].location != NSNotFound){//我接的订单
            //4a9480c7308e405fa8fcee58ea8c2c1b
            [self judgePush:@"WQorderViewController" PushID:pId IsOwn:YES];
        }else if ([operation rangeOfString:@"open_needbidList"].location != NSNotFound){//我接的订单列表
            [self judgePush:@"WQMyReceivinganOrderViewController" PushID:nil IsOwn:NO];
        }else if ([operation rangeOfString:@"open_newFriends"].location != NSNotFound){//新的朋友页面
            [self judgePush:@"WQnewFriendsViewController" PushID:nil IsOwn:NO];
        }else if ([operation rangeOfString:@"open_need"].location != NSNotFound){//发单人需求详情
            //73164976694e4470aa8b8ed263055d76
            [self judgePush:@"WQdetailsConrelooerViewController" PushID:pId IsOwn:NO];
        }
}
#pragma app已经启动
- (void)judgePush:(NSString *)pushName PushID:(NSString *)pId IsOwn:(BOOL)own;
{
    WQTabBarController *mainVC = (WQTabBarController *)self.window.rootViewController;
    
    if ([NSStringFromClass([mainVC class]) isEqualToString:@"WQStartPageViewController"]) {
        return;
    }else{
        UINavigationController *navController = mainVC.selectedViewController;
        UIViewController *cureVC = navController.topViewController;//当前VC
        [self pushNewVC:pushName curreVC:cureVC pishid:pId];
    }
}

- (void)pushNewVC:(NSString *)pushName curreVC:(UIViewController *)cureVC pishid:(NSString *)pId
{
    NSString *cureName = NSStringFromClass([cureVC class]);
    if (![cureName isEqualToString:pushName]) {//当前页面不等于要跳转的页面
        if ([pushName rangeOfString:@"WQGroupDynamicViewController"].location != NSNotFound) {
            WQGroupDynamicViewController *groupInfno  = [[WQGroupDynamicViewController alloc]init];
            groupInfno.gid = pId;
            [cureVC.navigationController pushViewController:groupInfno animated:YES];
        }else if ([pushName rangeOfString:@"WQorderViewController"].location != NSNotFound){
            WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:pId];
            orderVc.isHome = NO;
            [cureVC.navigationController pushViewController:orderVc animated:YES];
        }else if([pushName rangeOfString:@"WQdetailsConrelooerViewController"].location != NSNotFound){
            WQdetailsConrelooerViewController *orderVc = [[WQdetailsConrelooerViewController alloc]initWithmId:pId wqOrderType:WQHomePushToDetailsVc];
            [cureVC.navigationController pushViewController:orderVc animated:YES];
        }else{
            UIViewController *pushVC =  [[NSClassFromString(pushName) alloc]init];
            [cureVC.navigationController pushViewController:pushVC animated:YES];
        }
            //
    }
}



#pragma app被杀掉
- (void)pushOpenAPP:(NSDictionary *)launchOptions
{
    
    if (launchOptions) {
        NSDictionary * remoteNotification = launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            [self activateAPP:remoteNotification];
        }
    }
}








- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
}



- (void)resetAppBadge {
    [JPUSHService resetBadge];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WQ_APNS_NUM_KEY];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end

