//
//  WQUserProfileModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/5.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQUserProfileModel.h"
#import "WQTwoUserProfileModel.h"
#import "WQTwoWorkUserProfileModel.h"

@implementation WQUserProfileModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"education" : [WQTwoUserProfileModel class],
             @"work_experience" :[WQTwoWorkUserProfileModel class],
            };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
