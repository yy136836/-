//
//  WQdynamicHomeModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved. 
//

#import "WQdynamicHomeModel.h"
#import "WQPeopleWhoAreInterestedInModel.h"

@implementation WQdynamicHomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"moment_users" : [WQPeopleWhoAreInterestedInModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
