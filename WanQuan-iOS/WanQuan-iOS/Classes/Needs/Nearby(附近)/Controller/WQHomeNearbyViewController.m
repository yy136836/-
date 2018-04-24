//
//  WQHomeNearbyViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//



#import "WQHomeNearbyViewController.h"
#import "WQHomeNearbyTableViewCell.h"
#import "WQorderViewController.h"
#import "WQHomeNearby.h"
#import "WQHomeNearbyTagModel.h"
#import "WQUserProfileController.h"
#import "WQnewFriendsModel.h"
#import "WQindividualViewController.h"
#import "SDCycleScrollView.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQLogInController.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"
#import "WQHomeSearchViewController.h"
#import "WQNavigationController.h"
#import "WQAddneedController.h"
#import "WQTopicArticleController.h"

static NSString *cellID = @"cellid";

@interface WQHomeNearbyViewController ()<UITableViewDataSource,UITableViewDelegate,EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,SDCycleScrollViewDelegate,WQLoginPopupWindowDelegate>
@property (nonatomic, strong) WQHomeNearbyTagModel *homemodel;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@property (nonatomic, strong) NSMutableArray<WQHomeNearbyTagModel *> *tableViewdetailOrderData;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *informationParams;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) NSInteger currentPage;           // 当前页码
@property (nonatomic, assign) NSInteger currentPageCount;
@property (nonatomic, assign) BOOL ismyaccount;
@property (nonatomic, copy) void(^informationBlock)();
@end

@implementation WQHomeNearbyViewController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"需求";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shouyesousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    
}

- (void)tableViewScrollTop
{
    [WQTool scrollToTopRow:self.tableView];
}

- (void)searchBtnClick {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
        return ;
    }
    
    WQHomeSearchViewController *homeSearchVc = [[WQHomeSearchViewController alloc] init];
    WQNavigationController *nc = [[WQNavigationController alloc] initWithRootViewController:homeSearchVc];
    [self presentViewController:nc animated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [SVProgressHUD dismissWithDelay:0.5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD showWithStatus:@"正在加载中,请稍候..."];
    
    [self setupIm];
    [self setupUI];
    [self pulldownrenovate];
    [self loadNewDeals];
    //取消键盘第一响应者
    [self resignFirstResponder];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    NSString *im_password = [userDefaults objectForKey:@"im_password"];
    [WQDataSource sharedTool].userIdString = im_namelogin;
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
    }else{
        [WQSingleton huanxinLoginWithUsername:im_namelogin password:im_password];
//        [[EMClient sharedClient] loginWithUsername:im_namelogin password:im_password completion:^(NSString *aUsername, EMError *aError) {
//
//        }];
        
    }
    
    [self.tableViewdetailOrderData removeAllObjects];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQlongitudeuptodateNotifacation:) name:WQlongitudeuptodateNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQsearchBarSearch:) name:WQsearchBarSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQorderReceivingsucceedin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wqSuccessfulReleaseDemand) name:WQSuccessfulReleaseDemand object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark -- WQSuccessfulReleaseDemand
// 发布新需求成功的回调
- (void)wqSuccessfulReleaseDemand {
    [self loadNewDeals];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 初始化环信
- (void)setupIm {
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark - 环信代理方法

- (void)friendshipDidAddByUser:(NSString *)aUsername {
    
}

- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage {
    NSLog(@"%@",aUsername);
    NSLog(@"%@",aMessage);
//    NSMutableArray *aUsernameArray = [NSMutableArray array];
    
    
//    [aUsernameArray addObject:aUsername];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * oldRequests = [[userDefaults objectForKey:@"aUsername"] mutableCopy];
    
    NSMutableArray * newRequests = oldRequests ? oldRequests.mutableCopy : @[].mutableCopy;
    
    for(NSString * requestId in newRequests) {
//        当该人已经请求过之后
        if([aUsername isEqualToString:requestId]) {
            return;
        }
    }
    
    [newRequests addObject:aUsername];
    [userDefaults setObject:newRequests forKey:WQFriendRequestKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WQAddFriendNotifacation object:nil];
    [[WQDataSource sharedTool].IMFriendApplyInfoArrayM addObject:  [WQnewFriendsModel initWUsername:aUsername userMessage:aMessage]];
}

#pragma mark - 通知方法
- (void)WQlongitudeuptodateNotifacation:(NSNotification *)notificaton {
    NSDictionary *dict = notificaton.userInfo;
    self.location = [dict[WQuptodateKey] MKCoordinateValue];
    self.params[@"geo_lat"] = @(self.location.latitude).description;
    self.params[@"geo_lng"] = @(self.location.longitude).description;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: @(self.location.latitude).description forKey:@"geo_lat"];
    [userDefaults setObject: @(self.location.longitude).description forKey:@"geo_lng"];
    [self loadData];
}
- (void)WQsearchBarSearch:(NSNotification *)notificaton {
    NSDictionary *key_word = notificaton.userInfo;
    self.params[@"key_word"] = [key_word valueForKey:@"searchText"];
    NSLog(@"%@",self.params[@"key_word"]);
    [self loadData];
}

- (void)imageViewClick {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = [BASE_URL_STRING stringByAppendingString:@"front/need/noviceGuidanceH5Show"];
    //vc.NavTitle = cell.model.moment_status.link_txt;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 初始化UI
- (void)setupUI {
//    NSArray *imageNames = @[
//                            @"新banner.jpg"
//                            ];
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
//    cycleScrollView.delegate = self;
//    //cycleScrollView.autoScrollTimeInterval = 0;
//    cycleScrollView.autoScroll = NO;
//    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    //[self.view addSubview:cycleScrollView];
//    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 750 300
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScaleX(150))];
    imageView.image = [UIImage imageNamed:@"需求首页banner"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 0;
    imageView.userInteractionEnabled = YES;
    imageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
    [imageView addGestureRecognizer:tap];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView registerClass:[WQHomeNearbyTableViewCell class] forCellReuseIdentifier:cellID];
    tableView.tableHeaderView = imageView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, TAB_HEIGHT + 10, 0);
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.estimatedRowHeight = 165;
    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    self.loginPopupWindow = loginPopupWindow;
    loginPopupWindow.hidden = YES;
    [self.view addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-TAB_HEIGHT);
//        make.top.equalTo(self.view).offset(kScaleX(150));
//        make.left.right.equalTo(self.view);
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf loadNewDeals];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *plusBtn = [[UIButton alloc]init];
    [plusBtn setImage:[UIImage imageNamed:@"fabuanniulanxuqiu"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.offset(106);
        make.bottom.equalTo(self.view).offset(-55);
        make.right.equalTo(self.view).offset(-20);
    }];
}

#pragma mark -- WQLoginPopupWindowDelegate
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
    //WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    //vc.isLogin = NO;
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

#pragma mark - 下拉刷新
- (void)pulldownrenovate {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewDeals];
    }];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
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
    /*NSArray *refreshingImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"上拉箭头"],
                                 [UIImage imageNamed:@"上拉箭头"],
                                 nil];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];*/
    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header placeSubviews];
    //header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    //[self.tableView.mj_header beginRefreshing];
    // 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多内容" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = HEX(0x999999);
    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:16];

//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//    }];
    // 设置footer
    self.tableView.mj_footer = footer;
    // 开始隐藏底部刷新
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark 加载新数据
- (void)loadNewDeals {
//    self.currentPage = 0;
//    self.currentPageCount = 20;
    
    [_tableViewdetailOrderData removeAllObjects];
    [self loadData];
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    //self.currentPage += 1;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        // 游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        [self.tableView.mj_footer endRefreshing];
        return ;
    }
//    self.currentPageCount += 20;
    [self loadData];
}

/**
 发布新的需求
 */
- (void)plusBtnClike {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        self.tabBarController.tabBar.hidden = YES;
        self.loginPopupWindow.hidden = NO;
        [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.loginPopupWindow);
            make.height.offset(kScaleX(200));
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.loginPopupWindow layoutIfNeeded];
        }];
    }else{
        WQAddneedController *demaadnforHairVc = [[WQAddneedController alloc] init];;
        demaadnforHairVc.type = NeedControllerTypeNeeds;
        [self.navigationController pushViewController:demaadnforHairVc animated:YES];
    }
}

#pragma mark - 请求数据
- (void)loadData {
    NSString *urlString = @"api/need/queryneedlatest";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"start_id"] = @(_tableViewdetailOrderData.count).description;
    self.params[@"count"] = @(20).description;
    
    CGFloat longti = [WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude;
    CGFloat lati = [WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude;
    
    //    NSString * latiD = @(DefaultLati()).description;
    //
    //    NSString * lontiD = @(DefaultLonti()).description;
    self.params[@"geo_lat"] = @(lati).description.length?@(lati).description:@(LATI_D).description;
    self.params[@"geo_lng"] =  @(longti).description.length?@(longti).description:@(LONTI_D).description;
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {

        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
            [loadingError show];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.currentPageCount != 20) {
                weakSelf.currentPageCount -= 20;
            }
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if (weakSelf.currentPageCount == 20) {
            [weakSelf.tableViewdetailOrderData removeAllObjects];
        }
        
        
        NSArray * newData = response[@"needs"];
        [weakSelf.tableViewdetailOrderData addObjectsFromArray:[NSMutableArray yy_modelArrayWithClass:[WQHomeNearbyTagModel class] json:newData]];
        [loadingView dismiss];
        [loadingError dismiss];
        if (newData.count) {
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.mj_footer.hidden = weakSelf.tableViewdetailOrderData.count >= 500000;
    }];
    
}

- (void)information {
    NSString *urlString = @"api/user/getbasicinfo";
    self.informationParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_informationParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        self.ismyaccount = [response[@"ismyaccount"]boolValue];
        if (self.informationBlock) {
            self.informationBlock();
        }
    }];
}

#pragma mark - tableView数据源方法
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //return 10;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row >= _tableViewdetailOrderData.count  ) {
        return 0;
    }
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    if (model.truename) {
        return 165;
    }else {
        return 145;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *distance = [NSString stringWithFormat:@"%.0f",cell.homeNearbyTagModel.distance];
    // 解决bug
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    
    //if ([model.user_id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@""]]) {
      //  [SVProgressHUD showErrorWithStatus:@"不允许参与自己发布的需求"];
        //[SVProgressHUD dismissWithDelay:1.5];
    //}
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.homeNearbyTagModel.user_id isEqualToString:im_namelogin]) {
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:cell.homeNearbyTagModel.id wqOrderType:WQHomePushToDetailsVc];
        vc.FromHome = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WQorderViewController *orderVc = [[WQorderViewController alloc]initWithUserId:model add:cell.addr.text];
        //    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.homeNearbyTagModel.id];
        orderVc.user_degree = cell.homeNearbyTagModel.user_degree;
        orderVc.distance = cell.addr.text;
        orderVc.creditPoints = cell.homeNearbyTagModel.user_creditscore;
        orderVc.FromHome = YES;
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= _tableViewdetailOrderData.count) {
        return [UITableViewCell new];
    }
    
    WQHomeNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setHeadBtnClikeBlock:^{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *role_id = [userDefaults objectForKey:@"role_id"];
        if ([role_id isEqualToString:@"200"]) {
            //游客登录
//            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
//            
//            [self presentViewController:alertVC animated:YES completion:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                });
//            }];
            self.tabBarController.tabBar.hidden = YES;
            self.loginPopupWindow.hidden = NO;
            [self.loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.loginPopupWindow);
                make.height.offset(kScaleX(200));
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.loginPopupWindow layoutIfNeeded];
            }];
            return ;
        }
        
        WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *user_id = cell.homeNearbyTagModel.user_id;
        weakSelf.informationParams[@"uid"] = user_id;
        BOOL truename = cell.homeNearbyTagModel.truename;
        if (truename == false) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [weakSelf presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }];
            return ;
        }
        
        if (![WQDataSource sharedTool].verified) {
                // 快速注册的用户
                UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                         message:@"实名认证后可查看用户信息"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         NSLog(@"取消");
                                                                     }];
                UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                            style:UIAlertActionStyleDestructive
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                             
                                                                              [self.navigationController pushViewController:vc animated:YES];
                                                                          }];
                [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                
                [alertController addAction:cancelButton];
                [alertController addAction:destructiveButton];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
        }
        
        if ([WQDataSource sharedTool].verified && ![cell.homeNearbyTagModel.user_idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
            //游客登录
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"非实名认证用户" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        //        [weakSelf information];
        //        [weakSelf setInformationBlock:^{
        
        _ismyaccount = [weakSelf.tableViewdetailOrderData[indexPath.row].user_id
                        isEqualToString:[EMClient sharedClient].currentUsername];;
        if (_ismyaccount) {
            
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.tableViewdetailOrderData[indexPath.row].user_id];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.tableViewdetailOrderData[indexPath.row].user_id];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
//    TODO
    BOOL shouldShowRed = NO;
//    发需求人的 id
    NSString * uid = cell.homeNearbyTagModel.user_id;
//    需求的 id
    NSString * billId = cell.homeNearbyTagModel.id;
//    我的 id
//    NSString * myId =
    
    
    if (_tableViewdetailOrderData.count - 1 < indexPath.row) {
        return cell;
    }
    
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    cell.homeNearbyTagModel = model;

    return cell;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc] init];
    }
    return _tableViewdetailOrderData;
}
- (NSMutableDictionary *)informationParams {
    if (!_informationParams) {
        _informationParams = [[NSMutableDictionary alloc] init];
    }
    return _informationParams;
}

@end
