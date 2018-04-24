//
//  WQMapViewSearchController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQMapViewSearchModel;
@interface WQMapViewSearchController : UIViewController
@property(nonatomic,copy)void(^coordinateBlock)(WQMapViewSearchModel *);
@property(nonatomic,assign)BOOL isNearby;
@end
