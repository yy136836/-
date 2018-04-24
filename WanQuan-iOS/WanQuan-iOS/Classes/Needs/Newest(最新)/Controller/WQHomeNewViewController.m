//
//  WQHomeNewViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeNewViewController.h"
#import "WQorderViewController.h"
#import "WQHomeMapViewController.h"
#import "WQHomeNearbyTagModel.h"
#import "WQUserProfileController.h"
#import "SDCycleScrollView.h"
#import "WQdetailsConrelooerViewController.h"
#import "WQHomeNewVisitorsLoginView.h"
#import "WQLoginPopupWindow.h"
#import "WQRegisteredViewController.h"
#import "WQLogInController.h"
#import "WQAuthorityManager.h"
#import "WQHomeNearbyTableViewCell.h"
#import  <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString *cellID = @"cellid";

@interface WQHomeNewViewController ()<UITableViewDelegate,UITableViewDataSource, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate,SDCycleScrollViewDelegate,WQLoginPopupWindowDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableDictionary *params;
@property(nonatomic,assign)CLLocationCoordinate2D location;
@property(nonatomic,strong)NSMutableArray *tableViewdetailOrderData;
/** 当前页码*/
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)NSInteger currentPageCount;
@property (nonatomic, strong) WQLoginPopupWindow *loginPopupWindow;
@end

@implementation WQHomeNewViewController {
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _geocodesearch;
    WQHomeNewVisitorsLoginView *visitorsLoginView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    NSString *im_password = [userDefaults objectForKey:@"im_password"];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        
//        [self setupTouristUI];
    } else {
        [self originalLocation];
        [self pulldownrenovate];
        [self loadData];
        self.currentPage = 0;
        self.currentPageCount = 20;
    }
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longitudeNotifacation:) name:WQlongitudeNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQsearchBarSearch:) name:WQsearchBarSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WQorderReceivingsucceedin object:nil];
    [self setupUI];

}



#pragma mark - 初始化游客登录UI
- (void)setupTouristUI {
////    touristView = [[WQTouristView alloc]init];
//    visitorsLoginView = [[WQHomeNewVisitorsLoginView alloc] init];
//    
//    [self.view addSubview:visitorsLoginView];
//    
//    [visitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//    }];
//    
//    WQLoginPopupWindow *loginPopupWindow = [[WQLoginPopupWindow alloc] init];
//    loginPopupWindow.delegate = self;
//    self.loginPopupWindow = loginPopupWindow;
//    loginPopupWindow.hidden = YES;
//    [self.view addSubview:loginPopupWindow];
//    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    // 去登录的点击事件
//    [visitorsLoginView setLoginBtnClickBlock:^{
////        self.tabBarController.tabBar.hidden = YES;
////        loginPopupWindow.hidden = NO;
////        [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.bottom.left.right.equalTo(loginPopupWindow);
////            make.height.offset(280);
////        }];
////        
////        [UIView animateWithDuration:0.25 animations:^{
////            [loginPopupWindow layoutIfNeeded];
////        }];
//        WQLogInController *vc = [[WQLogInController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
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
    WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    vc.isLogin = NO;
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

#pragma mark - 初始定位
- (void)originalLocation {
    _locService = [[BMKLocationService alloc] init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [_locService startUserLocationService];    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.location =  _locService.userLocation.location.coordinate;
    self.params[@"geo_lat"] = @(self.location.latitude).description;
    self.params[@"geo_lng"] = @(self.location.longitude).description;
    NSLog(@"%f     %f", self.location.latitude, self.location.longitude);
    
    // 反向地理编码
    [self onReverseGeocode];
    [WQDataSource sharedTool].location=  userLocation.location.coordinate;
    [_locService stopUserLocationService];
    [[NSNotificationCenter defaultCenter] postNotificationName:WQlongitudeuptodateNotifacation object:nil userInfo:@{WQuptodateKey : [NSValue valueWithMKCoordinate:self.location]}];
}

#pragma mark - 反向地理编码
-(void)onReverseGeocode {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.location;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    }else {
        NSLog(@"反geo检索发送失败");
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        NSLog(@"%@", result.address);
        [WQDataSource sharedTool].location = result.location;
        [WQDataSource sharedTool].orignalCity = result.address;
    }
}

#pragma mark - 下拉刷新
- (void)pulldownrenovate {
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    self.tableview.mj_header = header;
    // [self.tableview.mj_header beginRefreshing];
    // 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    // 设置文字
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.textColor = HEX(0x999999);
    footer.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:16];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *role_id = [userDefaults objectForKey:@"role_id"];
        if ([role_id isEqualToString:@"200"]) {
            //游客登录
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [self.tableview.mj_footer endRefreshing];
            return ;
        }
        [self loadMoreDeals];
    }];
    // 设置footer
    self.tableview.mj_footer = footer;
    // 开始隐藏底部刷新
    self.tableview.mj_footer.hidden = YES;
    
}

#pragma mark 加载新数据
- (void)loadNewDeals {
    self.currentPage = self.tableViewdetailOrderData.count;
    [self loadData];
}

#pragma mark 加载更多数据
- (void)loadMoreDeals {
    self.currentPage += 1;
    [self loadData];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[WQHomeNearbyTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    self.tableview.estimatedRowHeight = 165;
    //取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    self.tableview = tableView;
    //自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-59);
    }];
    
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - 请求数据
- (void)loadData {
    
    [[WQAuthorityManager manger] checkLocation];
    if( ![WQAuthorityManager manger].haveLocateAuthority ) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        _currentPage = 0;
        [_tableViewdetailOrderData removeAllObjects];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        [_tableview reloadData];
        return;
    }
    
    NSString * urlString = @"api/need/queryneednear";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    if (self.currentPage != 0) {
        self.params[@"start_id"] = @(self.tableViewdetailOrderData.count).description;
    }
    self.params[@"count"] = @(self.currentPageCount).description;
    
    CGFloat longti = [WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude;
    CGFloat lati = [WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude;
    
//    NSString * latiD = @(DefaultLati()).description;
//    
//    NSString * lontiD = @(DefaultLonti()).description;
    self.params[@"geo_lat"] = @(lati).description.length || lati == 0 ? @(lati).description : @(LATI_D).description;
    self.params[@"geo_lng"] =  @(longti).description.length || lati == 0 ?@(longti).description : @(LONTI_D).description;
    
    __weak typeof(self) weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
        if (error) {
            NSLog(@"%@",error);
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
//        [self.tableViewdetailOrderData removeAllObjects];
        NSLog(@"%@",response);
        
        _tableview.emptyDataSetDelegate = nil;
        _tableview.emptyDataSetSource = nil;
        if (![response[@"needs"] count]) {
            [_tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
        NSArray * models  = [NSArray yy_modelArrayWithClass:[WQHomeNearbyTagModel class] json:response[@"needs"]];

        [weakSelf.tableViewdetailOrderData addObjectsFromArray:models];
        
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [weakSelf.tableview reloadData];
        weakSelf.tableview.mj_footer.hidden = self.tableViewdetailOrderData.count >= 500000;
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
    }];
}

#pragma mark - 通知方法
- (void)WQsearchBarSearch:(NSNotification *)notificaton {
    NSDictionary *key_word = notificaton.userInfo;
    self.params[@"key_word"] = [key_word valueForKey:@"searchText"];
    NSLog(@"%@",self.params[@"key_word"]);
    [self loadData];
}

#pragma mark - TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WQHomeNearbyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *distance = [NSString stringWithFormat:@"%.0f",cell.homeNearbyTagModel.distance];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.homeNearbyTagModel.user_id isEqualToString:im_namelogin]) {
        WQdetailsConrelooerViewController *vc = [[WQdetailsConrelooerViewController alloc]initWithmId:cell.homeNearbyTagModel.id wqOrderType:WQHomePushToDetailsVc];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //订单信息的控制器
        WQorderViewController *orderVc = [[WQorderViewController alloc]initWithUserId:self.tableViewdetailOrderData[indexPath.row] add:distance];
        //    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.homeNearbyTagModel.id];
        orderVc.user_degree = cell.homeNearbyTagModel.user_degree;
        orderVc.distance = distance;
        orderVc.creditPoints = cell.homeNearbyTagModel.user_creditscore;
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQHomeNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    [cell setHeadBtnClikeBlock:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *role_id = [userDefaults objectForKey:@"role_id"];
        if ([role_id isEqualToString:@"200"]) {
            //游客登录
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        NSString *user_id = weakCell.homeNearbyTagModel.user_id;
        BOOL truename = weakCell.homeNearbyTagModel.truename;
        if (truename == false) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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
                                                                          WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:user_id];
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
        
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:user_id];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    WQHomeNearbyTagModel *model = self.tableViewdetailOrderData[indexPath.row];
    cell.homeNearbyTagModel = model;
    return cell;
}

#pragma mark - 通知方法
- (void)longitudeNotifacation:(NSNotification *)notificaton {
    NSDictionary *dict = notificaton.userInfo;
    self.location = [dict[WQlongitudeKey] MKCoordinateValue];
    self.params[@"geo_lat"] = @(self.location.latitude).description;
    self.params[@"geo_lng"] = @(self.location.longitude).description;
    self.params[@"start_id"] = @(0).description;
    [self.tableViewdetailOrderData removeAllObjects];
    [self loadData];
}

#pragma mark - dealloc
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}



#pragma mark DZNdeleagte


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -40 - 14.5;
}



/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    UIViewController * vc;
    if ([role_id isEqualToString:@"200"]) {
        vc = [[WQLogInController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else  {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}




/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
//    
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:7];
//    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];

    
    
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] initWithString:@"\n\n看看附近有谁在发需求\n\n" attributes:nil];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [str setAttributes:att range:NSMakeRange(0, str.length)];
        
        [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                             NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 2)];
        [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                             NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(str.length - 2, 2)];
    } else {
    str = [[NSMutableAttributedString alloc] initWithString:@"\n还未开启定位信息访问权限\n请在设置-隐私-地理位置中允许万圈访问\n\n" attributes:nil];;
        [str setAttributes:att range:NSMakeRange(0, str.length)];
        
        [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],
                             NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
        [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                             NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(str.length - 2, 2)];

    }
    
    return str;
}

/**
 Asks the data source for the image of the dataset.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIImage * image = [UIImage imageNamed:@"fujin"];
    return image;
    
}

/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//
//}



- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    
    
    
    UIImage * str ;
    //    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x5d2a89),
    //                           NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        str = [UIImage imageNamed:@"立即登录"];
    } else {
        str = [UIImage imageNamed:@"btnBG"];
    }
    
    return  str;
    
}
/**
 Asks the data source for the background color of the dataset. Default is clear color.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return -5;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}



@end
