//
//  AppDelegate+WQLocate.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/31.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "AppDelegate+WQLocate.h"

@implementation AppDelegate (WQLocate)
- (void)startLocate {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        //定位功能可用
        [[WQLocationManager defaultLocationManager] startLocateWithHud:NO];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        [WQAlert showAlertWithTitle:@"提示" message:@"您未开启定位服务，将为您显示北京的需求信息!" duration:1.3];
    }
}
@end
