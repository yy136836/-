//
//  AppDelegate.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 郭杭. All rights reserved.
//  环信保存的聊天记录
//[self.conversation loadMessagesStartFromId:nil count:(int)count searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {

#import <UMSocialCore/UMSocialCore.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/Bugly.h>
#import "AppDelegate.h"
#import "ChatHelper.h"
#import "AppDelegate+EaseMob.h"
#import "EMSDK.h"
#import "EaseSDKHelper.h"
#import "WQTabBarController.h"
#import "WQChaViewController.h"
#import "WQMySetupViewController.h"
#import "UMMobClick/MobClick.h"
#import "WQLogInController.h"
#import "WQSingleton.h"

#import "WQdetailsConrelooerViewController.h"
#import "WQorderViewController.h"
#import "WQGreetViewController.h"
#import "WQMessageViewController.h"
#import "WQMyViewController.h"
#import "AppDelegate+WQLocate.h"
#import "AppDelegate+WQPushHandler.h"

#import "WQTopWIndowManager.h"
#import "WQShowNotiController.h"

#import "WQHeadImageView.h"

#import "WQDotInfoManager.h"

// 引入JPush功能所需头文件
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "WQStartPageViewController.h"


@interface AppDelegate ()
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL hasShownAlert;
@property (nonatomic ,retain) WQTopWIndowManager * windomManager;
@property (nonatomic, strong) WQStartPageViewController *vc;
@end

@implementation AppDelegate

+ (void)load {
    NSString *urlString = @"api/startupGraph/getStartupGraph";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            NSString *picid = response[@"startGraphPic"];
            [WQDataSource sharedTool].imageid = picid;
            NSLog(@"%@",[WQDataSource sharedTool].imageid);
        }
    }];
}

- (void)setimageid {
    [self.vc.imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAppendingString:[WQDataSource sharedTool].imageid]] placeholderImage:[UIImage imageNamed:@""]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [WQAlert showAlertWithTitle:[NSString stringWithFormat:@"123"] message:nil duration:8];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setimageid) name:WQPicIdSuccessful object:nil];

    WQStartPageViewController *vc = [[WQStartPageViewController alloc] init];
    self.vc = vc;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = vc;


    
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeADView:) userInfo:launchOptions repeats:NO];
    
#ifdef DEBUG
    Class overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#else
#endif
    return YES;
}

-(void)getLaunchImageWithOptions:(NSDictionary *)launchOptions {
//    WQStartPageViewController
    
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor redColor];
//    UIView *launchView = viewController.view;
//    self.launchView = launchView;
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = [[WQStartPageViewController alloc] init];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
    
    self.launchOptions = launchOptions;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeADView:) userInfo:launchOptions repeats:NO];
}

-(void)removeADView:(NSTimer *)launch {
//    [self.launchView removeFromSuperview];
    if (self.shouldShowGreet) {
        
        NSInteger time = [[NSDate date] timeIntervalSince1970];
        
        //        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",time ] forKey:WQ_LAST_SHOW_TIME_KEY];
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:WQ_STORAGE_FILE_PATH];
        NSMutableDictionary * newDateInfo = dic.mutableCopy;
        newDateInfo[WQ_LAST_SHOW_TIME_KEY] = [NSString stringWithFormat:@"%zd",time ];
        
        
        self.isFirst = YES;
        self.window.rootViewController = [WQGreetViewController new];
        
//        if (!_windomManager && _isFirst) {
//            _windomManager = [WQTopWIndowManager manager];
//
//            WQShowNotiController * vc = [[WQShowNotiController alloc] initWithNibName:@"WQShowNotiController" bundle:[NSBundle mainBundle]];
//            vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//            [_windomManager showWindowWithViewController:vc];
//            [_window makeKeyAndVisible];
//            vc.dissmiss = ^{
                [self startRegitstWithLaunchingWithOptions:self.launchOptions];
//                [_windomManager dismissWindow];
//            };
//        }
        
    } else {
        self.window.rootViewController = [WQSingleton sharedManager].isUserLogin? [[WQTabBarController alloc]init] : [[WQLogInController alloc] init];
        ROOT(root);
        
        if (root){
            [self fetchVerifyStatus];
        }
        
        [self pushOpenAPP:launch.userInfo];
        [self startRegitstWithLaunchingWithOptions:self.launchOptions];
    }
    
    [self.window makeKeyAndVisible];
}


- (void)startRegitstWithLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma 友盟统计
    UMConfigInstance.appKey = @"58214370734be4162700191b";
    UMConfigInstance.channelId = @"App Store";
    //配置以上参数后调用此方法初始化SDK！
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.belight-wanquan"];
    [MobClick setAppVersion:version];
    
#pragma 百度地图
    [self baiduMap];
    
#if defined(DEBUG) || defined(_DEBUG)
#pragma 蒲公英SDK
    //[self dandelionSDK];
#endif
    // 微信注册
    [WXApi registerApp:@"wx06cbcb9e5e04f1ea"];
#pragma 极光
    [self setupJPushWithLauchOptions:launchOptions];
#pragma 友盟第三方分享
    [self setupUMShareWithOption:launchOptions];
    // 没有用
    [self setupappearance];

    // [self app_Version];
    [self startLocate];
    [self updateBidStatus];
//    [self setupNetworkMonitor];
#pragma mark - keyboardmanager
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
#pragma mark - bugly
    [Bugly startWithAppId:@"6ac66f75f8"];
    [WQDataSource sharedTool].join_alumnus_group_success = YES;

}


#pragma mark -- 检查版本更
- (void)app_Version {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",app_Version);
    if (![app_Version isEqualToString:@"1.5.1"]) {
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"更新提示"
                                            message:@"您不是最新版万圈软件,建议您更新获得更好的使用体验。\n1.5.1版本增加了一些新功能并优化了用户体验。其中新增的群聊功能允许您加入私密的圈子与信赖的人一起话题讨论。\n使用老版本会遇到一些使用上的不便,比如与新版本之间不能及时收到好友申请。"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton =
        [UIAlertAction actionWithTitle:@"取消"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
                                   NSLog(@"取消");
                               }];
        UIAlertAction *destructiveButton =
        [UIAlertAction actionWithTitle:@"确定"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   NSString *myAppID = @"1195908226";
                                   NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", myAppID];
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                               }];
        
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)setupappearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                forState:UIControlStateNormal];
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setBarTintColor:HEX(0xfafafa)];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HEX(0xfafafa) size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:WQ_SHADOW_IMAGE];
    [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [[SVProgressHUD appearance] setOffsetFromCenter:UIOffsetMake(0, 10)];
    [[YYImageCache sharedCache].diskCache setAgeLimit: 60l * 60 * 24 * 7];
}

-(void)userAccountDidLoginFromOtherDevice {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"您的账号已在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
    
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            WQLogInController *vc = [WQLogInController new];
            
            NSString* appDomain = [[NSBundle mainBundle]bundleIdentifier];
            [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
            
            NSFileManager *fileManager = [NSFileManager  defaultManager];
            if ([fileManager removeItemAtPath:[WQSingleton sharedManager].archivePath error:nil]) {
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            }
        });
    }];
}

- (void)updateBidStatus {
    [[WQNetworkTools sharedTools] fetchRedDot];
}

#pragma 百度地图
- (void)baiduMap {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"QItpc1G01Z66Wkg0rtnrTskT6UPeTbZX"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma 蒲公英SDK
- (void)dandelionSDK {
    /*
     //自定义必须在调用 [[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"] 前设置。
     // 设置用户反馈界面激活方式为三指拖动
     [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
     // 设置用户反馈界面激活方式为摇一摇
     [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
     //启动基本SDK
     [[PgyManager sharedPgyManager] startManagerWithAppId:@"db01247311dee730585fb6dda35aebcf"];
     //启动更新检查SDK
     [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"db01247311dee730585fb6dda35aebcf"];
     //关闭用户反馈功能(默认开启)
     //[[PgyManager sharedPgyManager] setEnableFeedback:NO];
     
     //自定义用户界面风格
     //[[PgyManager sharedPgyManager] setThemeColor:[UIColor blackColor]];
     
     //自定义摇一摇的灵敏度，默认为2.3，数值越小灵敏度越高。
     [[PgyManager sharedPgyManager] setShakingThreshold:3.0];*/
}



#pragma mark - 友盟

- (void)setupUMShareWithOption:(NSDictionary *)launchOptions {
    //打开调试日志
    UMSocialLogInfo(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey58214370734be4162700191b
    //[[UMSocialManager defaultManager] setUmSocialAppkey:@"2219010381"];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58214370734be4162700191b"];
    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3401457534"  appSecret:@"391223cfcb2ede235c638d6af7666b92" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置分享到QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105741337"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到微信的Appkey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx06cbcb9e5e04f1ea" appSecret:@"109c353b30ae8a5a65ec6f919d40857e" redirectURL:@"http://mobile.umeng.com/social"];
    // 如果不想显示平台下的某些类型，可用以下接口设置
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Qzone)]];
#pragma 继承环信文档
    //环信
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    [self easemobApplication:[UIApplication sharedApplication]
didFinishLaunchingWithOptions:launchOptions
                      appkey:@"1128161125115385#wanquan"
#ifdef DEBUG
                apnsCertName:@"kaifazhengshu"
#else
                apnsCertName:@"zhengshu"
#endif
                 otherConfig:nil];
    [[EMClient sharedClient] addDelegate:self];
    NSLog(@"打印iOS环信SDK版本号：%@",[[EMClient sharedClient] version]);
    
    [[EMClient sharedClient].chatManager addDelegate: [ChatHelper shareHelper]];
    [[EMClient sharedClient].groupManager addDelegate:[ChatHelper shareHelper] ];
    [[EMClient sharedClient].contactManager addDelegate:[ChatHelper shareHelper]];
    [[EMClient sharedClient].roomManager addDelegate:[ChatHelper shareHelper]];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    //App进入后台
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [self resetAppBadge];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //App从后台返回
    [SVProgressHUD dismiss];

    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [self resetAppBadge];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma 设置友盟系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result) {
        // 其他如支付等SDK的回调
        WQTabBarController * vc = [WQTabBarController new];
        self.window.rootViewController = vc;
        return result;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        return YES;
//    }
//    return [WXApi handleOpenURL:url delegate:self];
    return [self handelPaymentWithOpenURL:url];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        return YES;
//    }
//    return [WXApi handleOpenURL:url delegate:self];
   return [self handelPaymentWithOpenURL:url];
}

- (BOOL)handelPaymentWithOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:WQaliPayForSuccess object:self];
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}



/**
 微信支付的回调
 @param resp 微信终端返回给第三方的关于支付结果的结构体
 微信终端返回给第三方的关于支付结果的结构体
 财付通返回给商家的信息
 @property (nonatomic, retain) NSString *returnKey;

 */
-(void)onResp:(BaseReq *)resp {
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    if ([resp isKindOfClass:NSClassFromString(@"SendMessageToWXResp")]) {
        return;
    }
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    [[NSNotificationCenter defaultCenter] postNotificationName:WQWXApiPayForSuccess object:self];
    if ([aresp isKindOfClass:NSClassFromString(@"PayResp")]) {
        return;
    }
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        NSDictionary *dic = @{@"code":code};
        [[NSNotificationCenter defaultCenter] postNotificationName:WQWeChatSuccess object:self userInfo:dic];
    }
}

- (void)setupNetworkMonitor {
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];

    [manager startMonitoring];
    //    AFNetworkReachabilityStatusUnknown          = -1,
    //    AFNetworkReachabilityStatusNotReachable     = 0,
    //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
    
    
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                
                [WQAlert showAlertWithTitle:@"提示" message:@"请检查网络连接" duration:1];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                [WQAlert showAlertWithTitle:@"提示" message:@"请检查网络连接" duration:1];
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                
                break;
            }
                
                
            default:
                break;
        }
    }];
}

- (BOOL)shouldShowGreet {

    BOOL haveFile = [[NSFileManager defaultManager] fileExistsAtPath:WQ_STORAGE_FILE_PATH];
    _isFirst = !haveFile;
    NSMutableDictionary * plistDic = @{}.mutableCopy;

//    如果没有则刚安装
    if (!haveFile) {
        [[NSFileManager defaultManager] createFileAtPath:WQ_STORAGE_FILE_PATH contents:nil attributes:nil];
        plistDic = @{WQ_APP_VERSION_KEY:WQ_APP_VERSION}.mutableCopy;
        [plistDic writeToFile:WQ_STORAGE_FILE_PATH atomically:YES];
        return YES;
    }
    

    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:WQ_STORAGE_FILE_PATH];  //读取数据
//如果没数据说明异常写入版本信息
    if (!dic) {
         plistDic = @{WQ_APP_VERSION_KEY:WQ_APP_VERSION}.mutableCopy;
        [plistDic writeToFile:WQ_STORAGE_FILE_PATH atomically:YES];
        return YES;
    } else {
        
        
//        有数据就先检查版本号
        if ([[dic valueForKey:WQ_APP_VERSION_KEY] length] && [[dic valueForKey:WQ_APP_VERSION_KEY] isEqualToString:WQ_APP_VERSION]) {
//             版本号一致检查时间
            NSString * lastShowTime = dic[WQ_LAST_SHOW_TIME_KEY];
            if (lastShowTime.length) {
                NSInteger time = [[NSDate date] timeIntervalSince1970];
                
                NSInteger lastShow = lastShowTime.integerValue;
                
                NSTimeInterval interval = time - lastShow;
                
                NSInteger day = interval / 60 / 60 / 24;
                
                if (day > 7) {
                    return YES;
                }
                
            } else {
                return NO;
            }

            return NO;
        } else {
//            写入版本号
            plistDic = dic.mutableCopy;
            plistDic[WQ_APP_VERSION_KEY] = WQ_APP_VERSION;
            [plistDic writeToFile:WQ_STORAGE_FILE_PATH atomically:YES];
            return YES;
        }

    }
}

- (void)fetchVerifyStatus {
    [WQDataSource sharedTool].secretkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    NSString *urlString = @"api/user/getbasicinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSString * str = [EMClient sharedClient].currentUsername;
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [WQDataSource sharedTool].loginStatus = response[@"idcard_status"];
            
            if (![EMClient sharedClient].isLoggedIn) {
                [[EaseSDKHelper shareHelper] loginFroced:YES];
            }
        }
    }];
    
}

//- (void)tryLogin:(EMError **)e {
//    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_namelogin"];
//    NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_password"];
//    *e = [[EMClient sharedClient] loginWithUsername:userName
//                                           password:passWord];
//    if (!*e) {
//        [EMClient sharedClient].options.isAutoLogin = YES;
//    }
//}
//
//- (void)checkLoginStatusAndLogin {
//        EMError * e = [[EMError alloc] init];
//        while (e) {
//            [self tryLogin:&e];
//        }
//}



@end
