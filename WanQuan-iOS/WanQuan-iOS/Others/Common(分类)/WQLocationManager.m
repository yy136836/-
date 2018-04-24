//
//  WQLocationManager.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQLocationManager.h"

@interface WQLocationManager ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, retain) BMKLocationService *  service;
@property (nonatomic, retain) BMKGeoCodeSearch * geoCodeSearch;
@property (nonatomic, assign) BOOL haveHud;
@end


@implementation WQLocationManager

+ (instancetype)defaultLocationManager {
    static WQLocationManager * manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            
            manager = [[WQLocationManager alloc] init];
            manager.service = [[BMKLocationService alloc] init];
            manager.service.delegate = manager;
            
            manager.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
            manager.geoCodeSearch.delegate = manager;
//            116.407143,39.915378
            
            manager.defaultLocation = [[CLLocation alloc] initWithLatitude:116.407143 longitude:39.915378];
            manager.defaultCity = @"北京市";
            
        }
    });
    return manager;
}


- (void)startLocateWithHud:(BOOL)haveHud {
    
    if (haveHud) {
        _haveHud = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showWithStatus:@"正在定位…"];
        });

    }
    
    [_service startUserLocationService];
}

- (void)stopLocate {
    if (_haveHud) {
        [SVProgressHUD dismiss];
    }
    
    [_service stopUserLocationService];
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
//    if (_haveHud) {
//        [SVProgressHUD showWithStatus:@"定位成功"];
//        [SVProgressHUD dismissWithDelay:0.5];
//    }
    
    _currentLocation = userLocation.location;
    
    [self reverseGeoCode:_currentLocation withHud:_haveHud];
    [self stopLocate];

}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    

    if (error) {
        [SVProgressHUD dismiss];

    } else {
//
//        TODO
        
        _usingLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        [self stopLocate];

        if (_haveHud) {
            _haveHud = NO;
            [SVProgressHUD showWithStatus:@"定位成功"];
            [SVProgressHUD dismissWithDelay:0.5];
        }
    }
    NSError * aerror = [NSError errorWithDomain:@"出错啦" code:error userInfo:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGEOFinished: withError:)]) {
        [self.delegate onGEOFinished:self withError:aerror];
    }
    
}

- (void)geocodeWithCityName:(NSString *)cityName withHud:(BOOL)haveHud{
    
    if (haveHud) {
        _haveHud = haveHud;
        [SVProgressHUD showWithStatus:@"正在定位…"];
    }
    
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


- (void)reverseGeoCode:(CLLocation *)location withHud:(BOOL)haveHud{
    
    if (haveHud) {
        _haveHud = haveHud;
        [SVProgressHUD showWithStatus:@"正在定位…"];
    }
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = location.coordinate;
    
    
    [self.geoCodeSearch reverseGeoCode:option];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error) {
        
        if (_haveHud) {
            [SVProgressHUD dismiss];

        }
//        NSString* titleStr = @"提示";
//        NSString* showmeg = @"当前网络不稳定!";
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
    } else {
        
        if (_haveHud) {
            [SVProgressHUD showWithStatus:@"定位成功"];
            [SVProgressHUD dismissWithDelay:0.5];
        }
        
        BMKAddressComponent * component = result.addressDetail;
        _usingCity = component.city;
        
        if ((result.location.latitude - self.currentLocation.coordinate.latitude  < 0.0001) && (result.location.longitude - self.currentLocation.coordinate.longitude < 0.0001)) {
            _currentCity = component.city;
        }
        NSError * aerror = [NSError errorWithDomain:@"出错啦" code:error userInfo:nil];
        
        if ( self.delegate && [self.delegate respondsToSelector:@selector(onReverseGEOFinished:withError:)]) {
            [self.delegate onReverseGEOFinished:self withError:aerror];
        }
        
    }
}

@end
