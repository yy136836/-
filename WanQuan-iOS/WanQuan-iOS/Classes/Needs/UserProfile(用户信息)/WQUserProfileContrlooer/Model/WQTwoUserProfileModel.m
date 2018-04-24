//
//  WQTwoUserProfileModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/5.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQTwoUserProfileModel.h"
#import "WQconfirmsModel.h"

@implementation WQTwoUserProfileModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"confirms" : [WQconfirmsModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
