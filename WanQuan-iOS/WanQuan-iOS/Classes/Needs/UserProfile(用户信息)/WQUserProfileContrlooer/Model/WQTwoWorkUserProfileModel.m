//
//  WQTwoWorkUserProfileModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTwoWorkUserProfileModel.h"
#import "WQTwoWorkconfirmsModel.h"

@implementation WQTwoWorkUserProfileModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"confirms" : [WQTwoWorkconfirmsModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
