//
//  WQHomeMapViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQHomeMapViewController.h"
#import "WQMapViewSearchController.h"
#import "WQRegionSelectViewController.h"
#import "WQMapViewSearchModel.h"

BMKMapView* mapView;

@interface WQHomeMapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate,WQLocationManagerDelegate>{
    IBOutlet BMKMapView* _mapView;
    NSString *geographicalPosition;
    BMKLocationService* _locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    
}

@property(nonatomic,strong)BMKMapView *mapView;
@property (nonatomic, retain)UIButton *regionBtn;
@property (nonatomic, copy) NSString * selectedCity;
@end

@implementation WQHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChangeNotifacation:) name:WQCityDidChangeNotifacation object:nil];
    
    self.navigationItem.title = @"选择位置";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(accomplishBtnClike)];
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    //uitextattributetextcolor替代方法
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
//    UIBarButtonItem *apperance = [UIBarButtonItem appearance];
    //uitextattributetextcolor替代方法
//    [apperance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupMap];
    [WQLocationManager defaultLocationManager].delegate = self;
    [[WQLocationManager defaultLocationManager] startLocateWithHud:YES];

    
    UIView *retrView = [[UIView alloc]init];
    [self.view addSubview:retrView];
    retrView.backgroundColor = [UIColor whiteColor];
    [retrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.height.mas_offset(44);
    }];
    
    UIButton *retrievalBtn = [[UIButton alloc]init];
    [retrView addSubview:retrievalBtn];
    [retrievalBtn setImage:[UIImage imageNamed:@"sarch_location-1"] forState:0];
    [retrievalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(retrView).mas_offset(-8);
        make.top.mas_equalTo(retrView).mas_offset(8);
    }];
    [retrievalBtn addTarget:self action:@selector(retrievalBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *regionBtn = [[UIButton alloc]init];

    _regionBtn = regionBtn;
    [regionBtn setTitleColor:[UIColor colorWithHex:0x585858] forState:UIControlStateNormal];
    [regionBtn setTitle:[WQLocationManager defaultLocationManager].currentCity forState:UIControlStateNormal];
    regionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [retrView addSubview:regionBtn];
    [regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(retrView.mas_left).mas_offset(24);
        make.bottom.mas_equalTo(retrView.mas_bottom).mas_offset(-8);
        make.right.equalTo(retrievalBtn.mas_left).offset(-3);
    }];
    [regionBtn addTarget:self action:@selector(regionBtnClike) forControlEvents:UIControlEventTouchUpInside];
    
    geographicalPosition = @"当前位置";
}

- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 完成
 */
- (void)accomplishBtnClike
{
    if(_mapView.centerCoordinate.longitude && _mapView.centerCoordinate.latitude) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WQlongitudeNotifacation object:nil userInfo:@{WQlongitudeKey : [NSValue valueWithMKCoordinate:_mapView.centerCoordinate]}];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.geographicalPositionBlock) {
            self.geographicalPositionBlock(geographicalPosition);
            if (_selectedCity.length) {
                [WQDataSource sharedTool].mapSelectedCity = _selectedCity;
            }
        }
        
        
        if (self.coordinateBlock) {
            self.coordinateBlock(CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude));
            
        }
    }
}

- (void)regionBtnClike {
    WQRegionSelectViewController *vc = [WQRegionSelectViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)retrievalBtnClike {
    
    __weak typeof(self) weakself = self;
    WQMapViewSearchController *vc = [WQMapViewSearchController new];
    vc.isNearby = self.isNearby;
    [vc setCoordinateBlock:^(WQMapViewSearchModel *searchModel) {
        
        [_mapView removeAnnotations:_mapView.annotations];
        WQMapViewSearchModel *mapviewsearchModel =[WQMapViewSearchModel new];
        mapviewsearchModel = searchModel;
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = searchModel.coordinate;
        annotation.title = [NSString stringWithFormat:@"地点: %@", searchModel.mapViewStoreName];
        annotation.subtitle = [NSString stringWithFormat:@"地址: %@", searchModel.mapViewLocation];
        [weakself.mapView addAnnotation:annotation];
        [weakself.mapView showAnnotations:@[annotation] animated:YES];

        geographicalPosition = searchModel.mapViewStoreName;
        [weakself.regionBtn setTitle:searchModel.mapViewStoreName forState:UIControlStateNormal];
        _selectedCity = searchModel.mapViewStoreName;
        
    }];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [self.view addSubview:vc.view];
}

- (void)setupMap
{
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = mapView;
    self.mapView = mapView;
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    [SVProgressHUD dismissWithDelay:0];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        newAnnotationView.image = [UIImage imageNamed:@"pin"];
        return newAnnotationView;
    }

    return nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}
/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"%@",error);
    }
    NSLog(@"location error");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_geoCodeSearch) {
        _geoCodeSearch = nil;
    }
    
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - 地理编码

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        [SVProgressHUD showWithStatus:@"定位成功"];
        [SVProgressHUD dismissWithDelay:1];
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        if (self.coordinateBlock) {
            self.coordinateBlock(result.location);
        }
        
        [_regionBtn setTitle:item.title forState:UIControlStateNormal];
        
    }else {
        [SVProgressHUD showWithStatus:@"定位失败请重新选择"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

- (void)geocodeWithCityName:(NSString *)cityName {
    [SVProgressHUD showWithStatus:@"正在定位…"];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeSearchOption.city = cityName;
    geoCodeSearchOption.address = cityName;
    BOOL flag = [_geoCodeSearch geoCode:geoCodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }else {
        NSLog(@"geo检索失败");
    }
}

#pragma mark - NOtification
- (void)cityDidChangeNotifacation:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *userData = notification.userInfo;
    NSLog(@"%@", userData[WQCityNameKey]);
    geographicalPosition = userData[WQCityNameKey];
    [self geocodeWithCityName:userData[WQCityNameKey]];
}

- (void)onReverseGEOFinished:(WQLocationManager *)manger withError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _regionBtn.titleLabel.text = manger.currentCity;

    });
}

@end
