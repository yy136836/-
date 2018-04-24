//
//  WQTabBarController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQTabBarController.h"
#import "WQNavigationController.h"
#import "WQNewestViewController.h"
#import "ChatHelper.h"
#import "WQLogInController.h"
#import "WQMessageViewController.h"
#import "UITabBar+badge.h"
#import "WQGreetViewController.h"
#import "WQConversationListViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "WQRelationsCircleHomeViewController.h"
#import "WQNeedsController.h"

#import "WQHomeNearbyViewController.h"
#import "WQdynamicHomeViewController.h"
#import "WQRelationsCircleHomeViewController.h"
#import "WQConversationListViewController.h"


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


@interface WQTabBarController ()

@property (weak,nonatomic) UIButton *getTextNumberButton;
@property (weak,nonatomic) UITextField *phoneNumber;
@property (weak,nonatomic) UITextField *userName;
@property (weak,nonatomic) UITextField *passWord;
@property (weak,nonatomic) UITextField *passWord2;
@property (weak,nonatomic) UITextField *textFild;
@property (weak,nonatomic) UIButton *phoneBTN;
@property (weak,nonatomic) UIButton *phoneBTN2;
@property (strong, nonatomic) NSMutableArray *vcArray;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation WQTabBarController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBar.barStyle = UIBarStyleDefault;
    self.tabBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQAddFriendNotifacation object:nil];
    
    _vcArray = [NSMutableArray array];
    NSMutableArray* vcs = [NSMutableArray array];
//    WQEssenceController
    [vcs addObject:[self loadChildViewControllerWithClassName:@"WQHomeNearbyViewController" andImageName:@"xuqiu" andTitle:@"需求"]];
    // [vcs addObject:[self loadChildViewControllerWithClassName:@"WQEssenceController" andImageName:@"jingxuan" andTitle:@"精选"]];
    
    [vcs addObject:[self loadChildViewControllerWithClassName:@"WQdynamicHomeViewController" andImageName:@"dongtaizi" andTitle:@"动态"]];

    [vcs addObject:[self loadChildViewControllerWithClassName:@"WQRelationsCircleHomeViewController" andImageName:@"wanquan" andTitle:@"万圈"]];
    //[vcs addObject:[self loadChildViewControllerWithClassName:@"WQAddressBookFriendsViewController" andImageName:@"wanquan" andTitle:@"万圈"]];
    [vcs addObject:[self loadChildViewControllerWithClassName:@"WQConversationListViewController" andImageName:@"xiaoxi" andTitle:@"消息"]];
    [vcs addObject:[self loadChildViewControllerWithClassName:@"WQMineViewController" andImageName:@"wode" andTitle:@"我的"]];
    
    self.viewControllers = vcs.copy;
    self.delegate = self;
    self.tabBar.tintColor = [UIColor colorWithHex:0x844dc5];
//    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.5] size:CGSizeMake(kScreenWidth, 49)];
    self.tabBar.barStyle = UIBarStyleDefault;
    [ChatHelper shareHelper].mainVC = self;
    self.selectedViewController = [self.viewControllers objectAtIndex:2];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.tabBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];

    for (UIView * view in self.tabBar.subviews) {
        NSLog(@"%@",view);
        
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            for (UIVisualEffectView * eff in view.subviews) {
                if ([eff isKindOfClass:[UIVisualEffectView class]]) {
                    
                    UIBlurEffect * bEff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
                    
                    [eff setEffect:bEff];
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideOrShowDot:nil];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQAddFriendNotifacation object:nil];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    [self setupUnreadMessageCount:nil];
//    self.tabBar.backgroundColor = [UIColor whiteColor];

    self.tabBar.barStyle = UIBarStyleDefault;
    
   static NSInteger curSelectIndex=10;
    
    NSLog(@"%d-----%d",curSelectIndex,tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == curSelectIndex) {
        WQNavigationController *nav = (WQNavigationController *)viewController;
        NSString *vcName = NSStringFromClass([nav.topViewController class]);
        if ([vcName isEqualToString:@"WQHomeNearbyViewController"]) {
            WQHomeNearbyViewController *nearByVC = (WQHomeNearbyViewController *)nav.topViewController;
            [nearByVC tableViewScrollTop];
        }else if ([vcName isEqualToString:@"WQdynamicHomeViewController"]){
            WQdynamicHomeViewController *dynamicVC = (WQdynamicHomeViewController *)nav.topViewController;
            [dynamicVC tableViewScrollTop];
        }else if ([vcName isEqualToString:@"WQRelationsCircleHomeViewController"]){
            WQRelationsCircleHomeViewController *circleVC = (WQRelationsCircleHomeViewController *)nav.topViewController;
            [circleVC tableViewScrollTop];
        }else if ([vcName isEqualToString:@"WQConversationListViewController"]){
            WQConversationListViewController *conversVC = (WQConversationListViewController *)nav.topViewController;
            [conversVC tableViewScrollTop];
        }

    }

        curSelectIndex = tabBarController.selectedIndex;

}

/**
 *  根据类名/图片名/标题 创建被导航控制器包好的子控制器
 */
- (UIViewController*)loadChildViewControllerWithClassName:(NSString *)className andImageName:(NSString *)imageName andTitle:(NSString *)title {
    // 创建子控制器
    Class Clz = NSClassFromString(className);
    UIViewController *vc = [[Clz alloc] init];
    vc.title = title;
    // 获取image
    UIImage *image = [UIImage imageNamed:imageName];
    // 变成使用原始的图片
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置不选中图片
    vc.tabBarItem.image = image;
    // 获取image
    UIImage *imageSelected = [UIImage imageNamed:[imageName stringByAppendingString:@"_selected"]];
    // 变成使用原始的图片
    imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置不选中图片
    vc.tabBarItem.selectedImage = imageSelected;
    
    
//    if ([vc canPerformAction:@selector(setIsRoot:) withSender:nil]) {
//        [vc performSelector:@selector(setIsRoot:) withObject:@(YES)];
//    }
    
    
    [_vcArray addObject:vc];
    WQNavigationController* nav = [[WQNavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}


- (void)hideOrShowDot:(NSNotification *)noticification {
    
    EMMessage * message = noticification.object;
    
    BOOL have = [WQUnreadMessageCenter haveUnreadFriendMessage];
    
    [WQUnreadMessageCenter haveUnreadFriendMessage]||self.haveMessageInfoToDealWith ? [self.tabBar showBadgeOnItemIndex:3] : [self.tabBar hideBadgeOnItemIndex:3];
    [WQUnreadMessageCenter haveUnreadBidChat]||[WQContactManager haveUnacceptedFriendRequest]||self.haveBidInfoToDealWith ? [self.tabBar showBadgeOnItemIndex:4] : [self.tabBar hideBadgeOnItemIndex:4];

    
}

// 统计未读消息数
-(void)setupUnreadMessageCount:(EMMessage *)message {

}

- (void)setupUntreatedApplyCount
{
    [self.tabBar showBadgeOnItemIndex:4];
}




- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message {
    
//    NSInteger i = [[[NSUserDefaults standardUserDefaults] objectForKey:WQ_APNS_NUM_KEY] integerValue];
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber  =  ++ i ;
//    [[NSUserDefaults standardUserDefaults] setInteger:i forKey:WQ_APNS_NUM_KEY];

    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = @"有人";
//            群聊
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    } else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            } else if (message.chatType == EMChatTypeChatRoom) {
//                聊天室
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
   } else {
//       单聊
        alertBody = @"您收到一条会话消息";
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    if ([message.ext[@"nid"] length]) {
        userInfo[@"nid"] = message.ext[@"nid"];
    }
    
        
    //发送本地推送
    //ios 10 +
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    } else {
        //ios 9-
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        if ([self.navigationController.topViewController isKindOfClass:[EaseMessageViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[EaseMessageViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    EaseMessageViewController *chatViewController = (EaseMessageViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];


                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                EaseMessageViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];

                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
        
    } else {
        [self.navigationController popToViewController:self animated:NO];
    }
}




- (void)showBadgeOnItemIndex:(int)index {
    [self.tabBar showBadgeOnItemIndex:index];
}
- (void)hideBadgeOnItemIndex:(int)index {
    [self.tabBar showBadgeOnItemIndex:index];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
