//
//  WQLocationManager.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WQLocationManager;
@protocol WQLocationManagerDelegate <NSObject>

@optional

- (void)WQLocationManagerDelegateOnLocateFinished:(WQLocationManager *)manger withError:(NSError *)error;
- (void)onReverseGEOFinished:(WQLocationManager *)manger withError:(NSError *)error;
- (void)onGEOFinished:(WQLocationManager *)manger withError:(NSError *)error;

@end



@interface WQLocationManager : NSObject





@property (nonatomic, assign, getter=isLocating) BOOL locating;


/**
 默认城市,北京市
 */
@property (nonatomic, copy) NSString * defaultCity;
/**
 默认的坐标,当定位权限未打开时使用
 */
@property (nonatomic, retain) CLLocation * defaultLocation;


/**
 使用定位则定位到当前位置//使用前无需定位
 */
@property (nonatomic ,retain) CLLocation * currentLocation;


/**
 使用定位定位出当前城市//使用前无需定位
 */
@property (nonatomic, retain) NSString * currentCity;


/**
 手动选择城市取得的坐标
 */
@property (nonatomic, retain) CLLocation * usingLocation;


/**
 使用坐标定位出的城市
 */
@property (nonatomic, retain) NSString * usingCity;
@property (nonatomic, weak)id<WQLocationManagerDelegate> delegate;

+ (instancetype)defaultLocationManager;
- (void)startLocateWithHud:(BOOL)haveHud;
- (void)stopLocate;

- (void)geocodeWithCityName:(NSString *)cityName withHud:(BOOL)haveHud;
- (void)reverseGeoCode:(CLLocation *)location withHud:(BOOL)haveHud;
@end
