//
//  WQHomeMapViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//Privacy - Location When In Use Usage Description

#import <UIKit/UIKit.h>



/**
 百度地图的主要处理逻辑在这里
 */
@interface WQHomeMapViewController : UIViewController
@property(nonatomic,copy)void(^coordinateBlock)(CLLocationCoordinate2D);
@property (nonatomic, copy) void (^geographicalPositionBlock)(NSString *);
@property (nonatomic, assign) BOOL isNearby;
@end
