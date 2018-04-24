//
//  WQMapViewSearchController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMapViewSearchController.h"
#import "WQTabBarController.h"
#import "MBProgressHUD.h"
#import "WQMapSearchViewTableViewCell.h"
#import "WQMapViewSearchModel.h"
#import "WQRegionSelectViewController.h"

static NSString *cellid = @"cellid";

@interface WQMapViewSearchController ()<BMKMapViewDelegate, BMKPoiSearchDelegate,UISearchBarDelegate, BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource> {
    BMKMapView* _mapView;
    UITextField* _cityText;
    UITextField* _keyText;
    UIButton* _nextPageButton;
    BMKPoiSearch* _poisearch;
    int curPage;
    BMKLocationService *_locService;
}
@property(nonatomic,strong)UISearchBar *searchBar;
//店名
@property(nonatomic,strong)NSMutableArray *nameMutableArray;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,weak)UITableView *tableview;
@property(nonatomic,weak)UIButton *locationBtn;
@property(nonatomic,weak)UIView *navView;
@property(nonatomic,copy)NSString *searchCity;

@end

@implementation WQMapViewSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"检索" style:UIBarButtonItemStylePlain target:self action:@selector(onClickOk)];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    //适配ios7
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview: _mapView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChangeNotifacation:) name:WQCityDidChangeNotifacation object:nil];
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    _locService = [[BMKLocationService alloc]init];
    [self startLocation];
    
    
    UIView *sunshadeView = [[UIView alloc]init];
    sunshadeView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:sunshadeView];
    [sunshadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *navView = [UIView new];
    self.navView = navView;
    navView.backgroundColor = [UIColor colorWithHex:0Xa550d6];
    [sunshadeView addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(sunshadeView);
        make.height.offset(64);
    }];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingbulan"]];
    [navView addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(navView);
    }];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn = locationBtn;
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [locationBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    [locationBtn setTitle:[WQDataSource sharedTool].mapSelectedCity ?: @"北京" forState:UIControlStateNormal];
    [navView addSubview:locationBtn];
    [locationBtn sizeToFit];
    [locationBtn addTarget:self action:@selector(locationBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).offset(15);
        make.bottom.equalTo(navView.mas_bottom).offset(-5);
        make.width.offset(70);
    }];
    
    UISearchBar *searchBar = [UISearchBar new];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = [UIColor whiteColor];
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    toolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)]];
    textField.inputAccessoryView = toolbar;
    textField.textColor = [UIColor colorWithHex:0x000000];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [navView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationBtn.mas_right).offset(15);
        make.centerY.equalTo(locationBtn.mas_centerY);
        make.right.equalTo(navView.mas_right).offset(-15);
    }];
    [searchBar becomeFirstResponder];
    
    UITableView *tableview  = [[UITableView alloc]init];
    tableview.bounces = NO;
    self.tableview = tableview;
    tableview.backgroundColor = [UIColor whiteColor];
    [tableview registerNib:[UINib nibWithNibName:@"WQMapSearchViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [sunshadeView addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sunshadeView.mas_right);
        make.left.equalTo(sunshadeView.mas_left);
        make.top.equalTo(navView.mas_bottom);
        make.height.offset(kScreenHeight);
    }];
    tableview.dataSource = self;
    tableview.delegate= self;
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _poisearch = [[BMKPoiSearch alloc]init];
    [_mapView setZoomLevel:13];
    _mapView.isSelectedAnnotationViewFront = YES;
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self onClickOk];
    //});

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [searchBar.subviews[0] subviews]) {
        
        if([cc isKindOfClass:[UIButton class]]) {
            
            UIButton *cancelButton = (UIButton *)cc;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
            // 修改文字颜色
            [cancelButton setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateHighlighted];
        }
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    NSString *mapArea = [WQDataSource sharedTool].mapSelectedCity;
    citySearchOption.city = mapArea? : @"北京";
    
    if (self.isNearby && self.searchCity != nil) {
        citySearchOption.city = self.searchCity;
    }
    //citySearchOption.keyword = @"餐馆";
    citySearchOption.keyword = self.searchBar.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
}

- (void)locationBtnClike
{
    WQRegionSelectViewController *regionSelectVc = [[WQRegionSelectViewController alloc]init];
    [self.navigationController pushViewController:regionSelectVc animated:YES];
}

#pragma mark - NOtification
- (void)cityDidChangeNotifacation:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *userData = notification.userInfo;
    self.searchCity = userData[WQCityNameKey];
    NSLog(@"%@", userData[WQCityNameKey]);
    [self.locationBtn setTitle:userData[WQCityNameKey] forState:0];
    [self onClickOk];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _poisearch.delegate = self;
    
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (! [tabBarVC isKindOfClass:[WQTabBarController class]]) {
        return;
    }
//    /tabBarVC.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _poisearch.delegate = nil;
    
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (! [tabBarVC isKindOfClass:[WQTabBarController class]]) {
        return;
    }
//    tabBarVC.tabBar.hidden = NO;
}

-(void)onClickOk
{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    NSString *mapArea = [WQDataSource sharedTool].mapSelectedCity;
    citySearchOption.city = mapArea? : @"北京";
    
    if (self.isNearby && self.searchCity != nil) {
        citySearchOption.city = self.searchCity;
    }
    //citySearchOption.keyword = @"餐馆";
    citySearchOption.keyword = self.searchBar.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}
//普通态
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param view 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    [self.modelArray removeAllObjects];
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            
            item.coordinate = poi.pt;
            //            item.title = poi.name;
            item.title = [NSString stringWithFormat:@" 店名: %@ \n 地址: %@ \n 联系电话: %@", poi.name, poi.address, poi.phone];
            [annotations addObject:item];
            NSLog(@"{\n 店名: %@ \n 地址: %@ \n 联系电话: %@\n}", poi.name, poi.address, poi.phone);
            
            WQMapViewSearchModel *model = [[WQMapViewSearchModel alloc]init];
            model.mapViewStoreName = poi.name;
            model.mapViewLocation = poi.address;
            model.coordinate = poi.pt;
            [self.modelArray addObject:model];

            [self.nameMutableArray addObject:poi.name];
        }
        [self.tableview reloadData];
        
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    [self onClickOk];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - tabelViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQMapSearchViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    WQMapViewSearchModel *model = [WQMapViewSearchModel new];
    model = self.modelArray[indexPath.row];
    cell.mapViewSearchModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQMapSearchViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.coordinateBlock) {
        [self.view removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.coordinateBlock(cell.mapViewSearchModel);
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)nameMutableArray
{
    if (!_nameMutableArray) {
        _nameMutableArray = [[NSMutableArray alloc] init];
    }
    return _nameMutableArray;
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}
- (void)done {
    [self.view endEditing:YES];
}
@end

