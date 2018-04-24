//
//  WQMapViewSearchModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQMapViewSearchModel : NSObject
@property(nonatomic,copy)NSString *mapViewStoreName;
@property(nonatomic,copy)NSString *mapViewLocation;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
