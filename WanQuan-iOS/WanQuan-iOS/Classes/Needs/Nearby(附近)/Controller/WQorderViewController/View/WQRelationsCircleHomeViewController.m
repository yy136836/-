//
//  WQRelationsCircleHomeViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQRelationsCircleHomeViewController.h"
#import "WQRelationsCircleHomeHeaderView.h"
#import "WQRecommendedTableViewCell.h"
#import "WQGroupRelationsCircleHomeTableViewCell.h"
#import "WQCircleNewsController.h"
#import "WQNewGroupViewController.h"
#import "WQMiriadeViewController.h"
#import "WQGroupModel.h"
#import "WQGroupDynamicViewController.h"
#import "WQaddFriendsController.h"
#import "WQRelationsCircleSearchViewController.h"
#import "WQRelationsCircleSearchNvc.h"
#import "WQRelationsCircleHomeVisitorsLoginHeaderView.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"
#import "WQLogInController.h"
#import "WQGroupInformationViewController.h"
#import "WQGroupDynamicNavView.h"
#import "WQVisitorsToLoginPopupWindowView.h"
#import "WQReegisteredOptionsViewController.h"
#import "WQJoinAlumniPopupWindowView.h"
#import "WQPhoneBookFriendsViewController.h"
#import "WQLoadingView.h"
#import "WQUpdatePopupwindowView.h"

static NSString *identifier = @"identifier";
static NSString *identifierTwo = @"identifierTwo";

@interface WQRelationsCircleHomeViewController () <UITableViewDelegate, UITableViewDataSource,WQRecommendedTableViewCellDelegate,WQLoginPopupWindowDelegate,UIScrollViewDelegate,WQVisitorsToLoginPopupWindowViewDelegate,WQJoinAlumniPopupWindowViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
// 刷新的按钮
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@property (nonatomic, assign) CLLocationCoordinate2D location;
// 头部试图
@property (nonatomic, strong) WQRelationsCircleHomeHeaderView *HeaderView;
@property (nonatomic, strong) WQGroupDynamicNavView *navView;

/**
 引导页
 */
@property (nonatomic, strong) UIImageView *banjiayindao;

/**
 更新弹窗
 */
@property (nonatomic, strong) WQUpdatePopupwindowView *updatePopupwindowView;

@end

@implementation WQRelationsCircleHomeViewController {
    UITableView *ghTableView;
    NSArray *groupList;
    NSArray *recommendedList;
    NSMutableArray *groupDescription;
    NSUserDefaults *ghUserDefaults;
    // gif图
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
    WQLoginPopupWindow *loginPopupWindow;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.navigationItem.title = @"万圈";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wanquanHomesousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    UIBarButtonItem *newGroupBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wanquanHomexinjianqun"] style:UIBarButtonItemStylePlain target:self action:@selector(newGroupBtnClick)];
    self.rightBarItem = newGroupBtn;
    self.navigationItem.rightBarButtonItem = searchBtn;
    self.navigationItem.leftBarButtonItem = newGroupBtn;
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    NSInteger i = ghTableView.contentOffset.y;
    if (i >= 100) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x333333]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName : [UIColor colorWithHex:0x333333] }];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"ceshisousuo copy"]];
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"ceshixinjianqun copy"]];
        //        [self setValue:@(UIStatusBarStyleLightContent) forKey:@"preferredStatusBarStyle"];
    }else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0xffffff]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"wanquanHomesousuo"]];
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"wanquanHomexinjianqun"]];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)tableViewScrollTop
{
    [WQTool scrollToTopRow:ghTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [ghUserDefaults setObject:app_Version forKey:@"app_Version"];
    
    //    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //    [SVProgressHUD showWithStatus:@"加载中…"];
    
    groupDescription = [NSMutableArray array];
    ghUserDefaults = [NSUserDefaults standardUserDefaults];
    [WQDataSource sharedTool].secretkey = [ghUserDefaults objectForKey:@"secretkey"];
    [WQDataSource sharedTool].password = [ghUserDefaults objectForKey:@"password"];
    [WQDataSource sharedTool].cellphone = [ghUserDefaults objectForKey:@"phoneString"];
    // [WQDataSource sharedTool].join_alumnus_group_success = YES;
    
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    NSString *im_namelogin = [ghUserDefaults objectForKey:@"im_namelogin"];
    NSString *im_password = [ghUserDefaults objectForKey:@"im_password"];
    [WQDataSource sharedTool].userIdString = im_namelogin;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self loadList];
    [self pulldownrenovate];
    [self setupNavView];
    [self loadVersionNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQlongitudeuptodateNotifacation:) name:WQlongitudeuptodateNotifacation object:nil];
    
    // 退圈成功  刷新列表数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadList) name:WQdetermineRefundGroupOf object:nil];
    // 加圈成功  刷新列表数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadList) name:WQjoinSuccess object:nil];
    
    [self loadStatus];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)checkversion {
    NSString *dateStr = [ghUserDefaults objectForKey:@"dateStr"];
    // 获得时间对象
    NSDate *date = [NSDate date];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [forMatter stringFromDate:date];
    if ([dateStr isEqualToString:dateString]) {
        // 同一天
        // 需要更新
        self.updatePopupwindowView.hidden = YES;
    }else {
        // 需要更新
        self.updatePopupwindowView.hidden = NO;
    }
}

#pragma mark -- 获取版本号
- (void)loadVersionNumber {
    NSString *urlString = @"api/system/checkversion";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [ghUserDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        self.updatePopupwindowView.contentString = response[@"latest_version_description"];
        self.updatePopupwindowView.versionNumberLabel.text = [@"更新版本: " stringByAppendingString:response[@"latest_version"]];
        self.updatePopupwindowView.hidden = YES;
        NSString *newVersionString = response[@"latest_version"];
        NSString *str = [newVersionString substringToIndex:1];
        NSString *str1 = [newVersionString substringToIndex:3];
        NSString *str2 = [str1 substringFromIndex:2];
        NSString *str3 = [newVersionString substringFromIndex:4];
        NSLog(@"%@",str);
        NSLog(@"%@",str2);
        NSLog(@"%@",str3);
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"-----------%@",newVersionString);
        NSLog(@"-----------%@",app_Version);
        NSString *app_Versionstr = [app_Version substringToIndex:1];
        NSString *app_Version1 = [app_Version substringToIndex:3];
        NSString *app_Version12 = [app_Version1 substringFromIndex:2];
        NSString *app_Version13 = [app_Version substringFromIndex:4];
        NSLog(@"%@",app_Versionstr);
        NSLog(@"%@",app_Version12);
        NSLog(@"%@",app_Version13);
        
        NSLog(@"%@",app_Versionstr);
        NSLog(@"%@",str);
        // 第一位小于
        if (app_Versionstr.intValue < str.intValue) {
            [self checkversion];
            return;
            // 第一位大于
        } else if (app_Versionstr.intValue > str.intValue) {
            return;
            // 第一位等于
        }else {
            // 第二位大于
            if (app_Version12.intValue > str2.intValue) {
                return;
            }else if (app_Version12.intValue < str2.intValue) {
                // 第二位小于
                [self checkversion];
                return;
                // 第二位等于
            }else {
                // 第三位小于
                if (app_Version13.integerValue < str3.integerValue) {
                    [self checkversion];
                    return;
                }else {
                    return;
                }
            }
        }
    }];
}

#pragma mark -- 获取用户状态
- (void)loadStatus {
    NSString *urlString = @"api/user/getbasicinfo";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"secretkey"] = [ghUserDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        NSString *statusString = response[@"idcard_status"];
        [WQDataSource sharedTool].work_experienceArray = response[@"work_experience"];
        [WQDataSource sharedTool].loginStatus = statusString;
        [WQDataSource sharedTool].user_name = response[@"true_name"];
        NSLog(@"%@",statusString);
        [self visitorsToLoginViewStatus:statusString];
    }];
}

#pragma mark -- 初始化游客弹窗
- (void)visitorsToLoginViewStatus:(NSString *)statusString {
    WQVisitorsToLoginPopupWindowView *visitorsToLoginPopupWindowView = [[WQVisitorsToLoginPopupWindowView alloc] init];
    visitorsToLoginPopupWindowView.delegate = self;
    // 未通过实名认证=STATUS_UNVERIFY;待管理员审批实名认证=STATUS_VERIFING;通过实名认证=STATUS_VERIFIED
    visitorsToLoginPopupWindowView.hidden = YES;
    if ([statusString isEqualToString:@"STATUS_UNVERIFY"]) {
        visitorsToLoginPopupWindowView.hidden = NO;
    }
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([WQDataSource sharedTool].isHiddenVisitorsToLoginPopupWindowView || [role_id isEqualToString:@"200"]) {
        visitorsToLoginPopupWindowView.hidden = YES;
    }
    
    //[self.view addSubview:visitorsToLoginPopupWindowView];
    [[UIApplication sharedApplication].keyWindow addSubview:visitorsToLoginPopupWindowView];
    [visitorsToLoginPopupWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@49);
    }];
}

#pragma mark -- WQVisitorsToLoginPopupWindowViewDelegate
- (void)wqLogOutBtnClick:(WQVisitorsToLoginPopupWindowView *)popupWindowView {
    popupWindowView.hidden = YES;
    [WQDataSource sharedTool].isHiddenVisitorsToLoginPopupWindowView = YES;
    NSString *urlString = @"api/user/loginguest";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
        [userDefaults setObject:response[@"im_namelogin"] forKey:@"im_namelogin"];
        [userDefaults setObject:response[@"im_password"] forKey:@"im_password"];
        [userDefaults setObject:response[@"role_id"] forKey:@"role_id"];
    }];
    WQTabBarController *tabBarVc= [[WQTabBarController alloc]init];
    [self presentViewController:tabBarVc animated:NO completion:nil];
    //    if (self.view.window == nil) {
    //        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //        window.rootViewController = tabBarVc;
    //        [window makeKeyAndVisible];
    //    }
}

- (void)wqSupplementaryInformationBtnClick:(WQVisitorsToLoginPopupWindowView *)popupWindowView {
    popupWindowView.hidden = YES;
    WQReegisteredOptionsViewController *vc = [[WQReegisteredOptionsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -- 导航栏渐变
- (void)setupNavView {
    WQGroupDynamicNavView *navview = [[WQGroupDynamicNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navview.alpha = 0;
    self.navView = navview;
    [self.view addSubview:navview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果需要竖着滑动生效.横着不生效
    if (ABS(scrollView.contentOffset.x) > ABS(scrollView.contentOffset.y)) {
        return;
    }
    
    YHValue resValue = YHValueMake(1, 0);
    YHValue conValue = YHValueMake(kScaleX(150), 64);
    self.navView.alpha = [NSObject resultWithConsult:scrollView.contentOffset.y andResultValue:resValue andConsultValue:conValue];
    
    NSInteger i = scrollView.contentOffset.y;
    if (i >= 100) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x333333]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHex:0x333333] }];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"ceshisousuo copy"]];
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"ceshixinjianqun copy"]];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}];
        
    }else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0xffffff]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"wanquanHomesousuo"]];
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"wanquanHomexinjianqun"]];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor colorWithHex:0xffffff]}];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 下拉刷新
- (void)pulldownrenovate {
    ghTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadList];
    }];
    MJRefreshGifHeader *header = ghTableView.mj_header;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    //[header setTitle:@"最后刷新时间" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    NSArray *imageArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"tableview_pull_refresh"],
                           [UIImage imageNamed:@"tableview_pull_refresh"],
                           nil];
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"上拉箭头"],
                              [UIImage imageNamed:@"上拉箭头"],
                              nil];
    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header placeSubviews];
    ghTableView.mj_header = header;
    __weak typeof(self) weakSelf = self;
    // 上拉加载
    MJRefreshAutoNormalFooter *freshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [freshFooter setTitle:@"上拉换一换" forState:MJRefreshStateIdle];
    [freshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [freshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    freshFooter.stateLabel.textColor = HEX(0x999999);
    freshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    freshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
    ghTableView.mj_footer = freshFooter;
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    // 去刷新数据
    [self loadRecommendedList:YES];
}

#pragma mark -- 初始化tableView
- (void)setupTableView {
    ghTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    // 设置tableview的边距
    if (@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ghTableView.backgroundColor = [UIColor whiteColor];
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    // 设置自动行高和预估行高
    ghTableView.rowHeight = UITableViewAutomaticDimension;
    if ([role_id isEqualToString:@"200"]) {
        ghTableView.estimatedRowHeight = 200;
    }else {
        ghTableView.estimatedRowHeight = 150;
    }
    // 取消分割线&滚动条
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghTableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [ghTableView registerClass:[WQGroupRelationsCircleHomeTableViewCell class] forCellReuseIdentifier:identifier];
    [ghTableView registerClass:[WQRecommendedTableViewCell class] forCellReuseIdentifier:identifierTwo];
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(self.view);
        //make.bottom.equalTo(self.view).offset(-49);
        make.bottom.equalTo(self.view);
    }];
    ghTableView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT, 0);
    
    // 设置头部试图
    WQRelationsCircleHomeHeaderView *HeaderView = [[WQRelationsCircleHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, kScaleY(173))];
    self.HeaderView = HeaderView;
    ghTableView.tableHeaderView = HeaderView;
    HeaderView.userInteractionEnabled = YES;
    
    if ([role_id isEqualToString:@"200"]) {
        // 登录的弹窗
        loginPopupWindow = [[WQLoginPopupWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        loginPopupWindow.delegate = self;
        loginPopupWindow.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:loginPopupWindow];
    }
    
    // 未在清华校友会名单的弹窗
    WQJoinAlumniPopupWindowView *joinAlumniPopupWindowView = [[WQJoinAlumniPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    joinAlumniPopupWindowView.delegate = self;
    joinAlumniPopupWindowView.hidden = YES;
    if ([WQDataSource sharedTool].join_alumnus_group_match) {
        if (![WQDataSource sharedTool].join_alumnus_group_success) {
            joinAlumniPopupWindowView.hidden = NO;
            // 没有加入成功的圈id   圈名称   圈头像
            [joinAlumniPopupWindowView.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING([ghUserDefaults objectForKey:@"join_alumnus_recommend_group_pic"])] placeholder:[UIImage imageNamed:@"AppIcon"]];
            
            
            //            [joinAlumniPopupWindowView.fuzzyImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING([ghUserDefaults objectForKey:@"join_alumnus_recommend_group_pic"])] placeholder:[UIImage imageNamed:@"AppIcon"]];
            //
            [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING([ghUserDefaults objectForKey:@"join_alumnus_recommend_group_pic"])] options:YYWebImageOptionProgressive progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                
                if (image) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage * blurImage = [image GPUImageBlur];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            joinAlumniPopupWindowView.fuzzyImageView.image = blurImage;
                        });
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        joinAlumniPopupWindowView.fuzzyImageView.image = [UIImage imageNamed:@"AppIcon"];
                    });
                }
            }];
            
            
            [joinAlumniPopupWindowView.nameLabel setText:[ghUserDefaults objectForKey:@"join_alumnus_recommend_group_name"]];
        }
    }
    if ([role_id isEqualToString:@"200"]) {
        joinAlumniPopupWindowView.hidden = YES;
    }
    // 注册时 以上都不是的时候不显示这个弹窗
    if ([WQDataSource sharedTool].isAreNot) {
        joinAlumniPopupWindowView.hidden = YES;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:joinAlumniPopupWindowView];
    
    // 引导页
    //    UIImageView *banjiayindao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //    self.banjiayindao = banjiayindao;
    //    banjiayindao.hidden = YES;
    //    banjiayindao.userInteractionEnabled = YES;
    //    banjiayindao.image = [UIImage imageNamed:@"banjiayindao"];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(banjiayindaoClick)];
    //    [banjiayindao addGestureRecognizer:tap];
    //    [[UIApplication sharedApplication].keyWindow addSubview:banjiayindao];
    //
    //    // 判断有没有登录
    //    if ([WQSingleton sharedManager].isUserLogin) {
    //        BOOL ischannelOff = [ghUserDefaults objectForKey:@"channelOff"];
    //        // 之前显示过
    //        if (!ischannelOff) {
    //            banjiayindao.hidden = NO;
    //            [ghUserDefaults setObject:@"YES" forKey:@"channelOff"];
    //        }
    //    }else {
    //        [ghUserDefaults setObject:@"YES" forKey:@"channelOff"];
    //        banjiayindao.hidden = YES;
    //    }
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-TAB_HEIGHT);
        make.top.equalTo(self.view).offset(kScaleY(173));
        make.left.right.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf loadList];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-TAB_HEIGHT);
        make.top.equalTo(self.view).offset(kScaleY(173));
        make.left.right.equalTo(self.view);
    }];
    
    WQUpdatePopupwindowView *updatePopupwindowView = [[WQUpdatePopupwindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    updatePopupwindowView.hidden = YES;
    self.updatePopupwindowView = updatePopupwindowView;
    [[UIApplication sharedApplication].keyWindow addSubview:updatePopupwindowView];
}

#pragma mark -- 引导页的响应事件
- (void)banjiayindaoClick {
    self.banjiayindao.hidden = YES;
}

#pragma mark -- 去登录
- (void)tologin {
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- WQJoinAlumniPopupWindowViewDelegate
// 申请加入的响应事件
- (void)wqImmediatelyToJoinBtnClick:(WQJoinAlumniPopupWindowView *)view {
    view.hidden = YES;
    // 加入按钮的响应事件
    WQaddFriendsController *vc = [[WQaddFriendsController alloc] init];
    vc.gid = [ghUserDefaults objectForKey:@"join_alumnus_recommend_group_id"];
    vc.type = @"加入圈";
    [self.navigationController pushViewController:vc animated:YES];
}

// x号的响应事件
- (void)wqDeleteBtnClick:(WQJoinAlumniPopupWindowView *)view {
    view.hidden = YES;
}

#pragma mark - 通知方法
- (void)WQlongitudeuptodateNotifacation:(NSNotification *)notificaton {
    NSDictionary *dict = notificaton.userInfo;
    self.location = [dict[WQuptodateKey] MKCoordinateValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: @(self.location.latitude).description forKey:@"geo_lat"];
    [userDefaults setObject: @(self.location.longitude).description forKey:@"geo_lng"];
}

#pragma mark -- 获取已加入群组数据
- (void)loadList {
    //[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //[SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/group/mygrouplist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [ghTableView.mj_header endRefreshing];
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            groupList = [NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]];
        }
        
        [self loadRecommendedList:NO];
    }];
}

#pragma mark -- 获取推荐群列表
- (void)loadRecommendedList:(BOOL)isRefreshBtnClick {
    NSString *urlString = @"api/group/recommandgroup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:response[@"secretkey"] forKey:@"secretkey"];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"start"] = @(0).description;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [ghTableView.mj_header endRefreshing];
            [ghTableView.mj_footer endRefreshing];
            [loadingView dismiss];
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            recommendedList = [NSArray yy_modelArrayWithClass:[WQGroupModel class] json:response[@"groups"]];
            // 设置代理对象
            ghTableView.delegate = self;
            ghTableView.dataSource = self;
            // 因为后台返回的description字段和系统冲突所以这样取值
            [groupDescription removeAllObjects];
            NSDictionary *dict = response[@"groups"];
            for (id i in dict) {
                [groupDescription addObject:i[@"description"]];
            }
            //            [ghTableView.mj_footer endRefreshingWithNoMoreData];
            if (isRefreshBtnClick) {
                [ghTableView.mj_footer endRefreshing];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.8f];
            }else {
                [ghTableView.mj_header endRefreshing];
                [ghTableView.mj_footer endRefreshing];
                [ghTableView reloadData];
            }
            ghTableView.mj_footer.hidden = recommendedList.count >= 500000;
            [loadingView dismiss];
            [loadingError dismiss];
        }
    }];
}
// 0.5秒后删除动画
- (void)delayMethod {
    // 删除动画
    [self.refreshBtn.layer removeAllAnimations];
    [ghTableView reloadData];
}

#pragma mark -- 搜索
- (void)searchBtnClick {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return ;
    }
    
    WQRelationsCircleSearchViewController *vc = [[WQRelationsCircleSearchViewController alloc] init];
    WQRelationsCircleSearchNvc *nav = [[WQRelationsCircleSearchNvc alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}
#pragma mark -- 新建群
- (void)newGroupBtnClick {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return ;
    }
    
    WQNewGroupViewController *vc = [[WQNewGroupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- WQRecommendedTableViewCellDelegate
- (void)wqJoinBtnClickRecommendedTableViewCell:(WQRecommendedTableViewCell *)cell {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return ;
    }
    if ([cell.model.privacy boolValue]) {
        // 加入按钮的响应事件
        WQaddFriendsController *vc = [[WQaddFriendsController alloc] init];
        vc.gid = cell.model.gid;
        vc.type = @"加入圈";
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSString *urlString = @"api/group/applyjoingroup";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        params[@"gid"] = cell.model.gid;
        params[@"message"] = @"";
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"已成功加入圈子" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        // 加入成功  刷新列表
                        [self loadList];
                    });
                }];
                return ;
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                return ;
            }
        }];
    }
}

// 点击头像
- (void)wqGroupHeadPortraitimageViewTableViewCell:(WQRecommendedTableViewCell *)cell {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return ;
    }
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = cell.model.gid;
    vc.groupModel = cell.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return ;
    }
    if (indexPath.section == 0) {
        WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
        WQGroupModel *model = groupList[indexPath.row];
        vc.gid = model.gid;
        model.unread_count = 0;
        [self.navigationController pushViewController:vc animated:YES];
        [ghTableView reloadData];
    }else {
        WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
        WQGroupModel *model = recommendedList[indexPath.row];
        vc.gid = model.gid;
        vc.groupModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSString *role_id = [ghUserDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        return recommendedList.count;;
    }else {
        if (section == 0) {
            return groupList.count;
        }else {
            return recommendedList.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        WQRecommendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTwo forIndexPath:indexPath];
        cell.delegate = self;
        
        if (recommendedList.count > indexPath.row) {
            cell.model = recommendedList[indexPath.row];
            cell.groupDescription = groupDescription[indexPath.row];
        }
        
        return cell;
    }else {
        if (indexPath.section == 0) {
            WQGroupRelationsCircleHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.model = groupList[indexPath.row];
            
            [cell setGroupHeadPortraitimageViewBlock:^{
                WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
                
                if (groupList.count > indexPath.row) {
                    
                    WQGroupModel *model = groupList[indexPath.row];
                    vc.gid = model.gid;
                    model.unread_count = 0;
                    [ghTableView reloadData];

                }

                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }];
            
            // 最后一个cell取消分隔线
            if (indexPath.row == groupList.count - 1) {
                cell.bottomLine.hidden = YES;
            }else {
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
        }else {
            WQRecommendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTwo forIndexPath:indexPath];
            cell.delegate = self;
            if (recommendedList.count > indexPath.row && groupDescription.count > indexPath.row) {
                cell.model = recommendedList[indexPath.row];
                cell.groupDescription = groupDescription[indexPath.row];
            }
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else {
        return 96;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        return @"";
    }else {
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        return @"";
    }else {
        if (section == 0) {
            return @" ";
        }
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        
        return lineView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        if (section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            view.backgroundColor = [UIColor whiteColor];
            
            // 紫色的条
            UIView *purpleView = [[UIView alloc] init];
            purpleView.backgroundColor = UIColorWithHex16_(0x9872ca);
            [view addSubview:purpleView];
            [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(3, 17));
                make.bottom.equalTo(view.mas_bottom);
                make.left.equalTo(view.mas_left).offset(ghSpacingOfshiwu);
            }];
            
            UILabel *recommendedLabel = [UILabel labelWithText:@"推荐圈子" andTextColor:[UIColor colorWithHex:0x262626] andFontSize:17];
            recommendedLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
            [view addSubview:recommendedLabel];
            [recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(purpleView.mas_centerY);
                make.left.equalTo(purpleView.mas_right).offset(8);
            }];
            // 刷新的按钮
            UIButton *refreshBtn = [[UIButton alloc] init];
            [refreshBtn setTitle:@" 换一换" forState:UIControlStateNormal];
            refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [refreshBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
            self.refreshBtn = refreshBtn;
            [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [refreshBtn setImage:[UIImage imageNamed:@"huanyihuan"] forState:UIControlStateNormal];
            [view addSubview:refreshBtn];
            [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(recommendedLabel.mas_centerY);
                make.right.equalTo(view.mas_right).offset(-15);
            }];
            
            return view;
        }
        return [UIView new];
    }else {
        if (section == 0) {
            if (!groupList.count) {
                return [UIView new];
            }
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            view.backgroundColor = [UIColor whiteColor];
            
            // 紫色的条
            UIView *purpleView = [[UIView alloc] init];
            purpleView.backgroundColor = UIColorWithHex16_(0x9872ca);
            [view addSubview:purpleView];
            [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(3, 17));
                make.bottom.equalTo(view.mas_bottom);
                make.left.equalTo(view.mas_left).offset(ghSpacingOfshiwu);
            }];
            
            UILabel *recommendedLabel = [UILabel labelWithText:@"加入的圈子" andTextColor:[UIColor colorWithHex:0x262626] andFontSize:17];
            recommendedLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
            [view addSubview:recommendedLabel];
            [recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(purpleView.mas_centerY);
                make.left.equalTo(purpleView.mas_right).offset(8);
            }];
            
            return view;
        }
        if (section == 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            view.backgroundColor = [UIColor whiteColor];
            
            // 紫色的条
            UIView *purpleView = [[UIView alloc] init];
            purpleView.backgroundColor = UIColorWithHex16_(0x9872ca);
            [view addSubview:purpleView];
            [purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(3, 17));
                make.bottom.equalTo(view.mas_bottom);
                make.left.equalTo(view.mas_left).offset(ghSpacingOfshiwu);
            }];
            
            UILabel *recommendedLabel = [UILabel labelWithText:@"推荐圈子" andTextColor:[UIColor colorWithHex:0x262626] andFontSize:17];
            recommendedLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
            [view addSubview:recommendedLabel];
            [recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(purpleView.mas_centerY);
                make.left.equalTo(purpleView.mas_right).offset(8);
            }];
            // 刷新的按钮
            UIButton *refreshBtn = [[UIButton alloc] init];
            [refreshBtn setTitle:@" 换一换" forState:UIControlStateNormal];
            refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [refreshBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
            self.refreshBtn = refreshBtn;
            [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [refreshBtn setImage:[UIImage imageNamed:@"huanyihuan"] forState:UIControlStateNormal];
            [view addSubview:refreshBtn];
            [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(recommendedLabel.mas_centerY);
                make.right.equalTo(view.mas_right).offset(-15);
            }];
            
            return view;
        }
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        return 0;
    }else {
        if (section == 0) {
            if (!groupList.count) {
                return 0.01;
            }
            return ghStatusCellMargin;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    if(!groupList.count && !section) {
    //        return CGFLOAT_MIN;
    //    }
    if ([[ghUserDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        return 40;
    }else {
        if (section == 0) {
            if (!groupList.count) {
                return 0;
            }
        }
        return 30;
    }
}

#pragma mark - 侧滑置顶
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        WQGroupModel *model = groupList[indexPath.row];
        NSString *title;
        if ([model.set_top boolValue]) {
            title = @"取消置顶";
        }else {
            title = @"置顶";
        }
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull indexPath) {
            
            NSString *urlString = @"api/group/settopgroup";
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"gid"] = model.gid;
            dict[@"secretkey"] = [WQDataSource sharedTool].secretkey;
            if ([model.set_top boolValue]) {
                dict[@"settop"] = @"false";
            }else {
                dict[@"settop"] = @"true";
            }
            [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:dict completion:^(id response, NSError *error) {
                
                if (error) {
                    NSLog(@"%@",error);
                }
                
                if ([response isKindOfClass:[NSData class]]) {
                    response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                }
                
                NSLog(@"%@",response);
                if ([response[@"success"] boolValue]) {
                    [self loadList];
                }else {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"置顶失败,请重试." preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self presentViewController:alertVC animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                        });
                    }];
                }
            }];
        }];
        action.backgroundColor = [UIColor colorWithHex:0x9767D0];
        
        return @[action];
    }else {
        return [NSArray new];
    }
}

#pragma mark - 换一换的按钮响应事件
- (void)refreshBtnClick:(UIButton *)sender {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    // 如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    animation.repeatCount = 3;
    [sender.imageView.layer addAnimation:animation forKey:nil];
    
    // 去刷新数据
    [self loadRecommendedList:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (ghTableView.contentOffset.y > 100) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)showLogin {
    [self.view bringSubviewToFront:loginPopupWindow];
    loginPopupWindow.hidden = NO;
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(kScaleX(200));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
        self.tabBarController.tabBar.hidden = YES;
    }];
}

- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

