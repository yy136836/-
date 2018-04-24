//
//  WQHasJoinedWanQuanModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHasJoinedWanQuanModel.h"
#import "WQHasJoinedWanQuanWorkModel.h"
#import "WQHasJoinedWanQuanEducationModel.h"

@implementation WQHasJoinedWanQuanModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"user_work_experience" : [WQHasJoinedWanQuanWorkModel class],
             @"user_education_experience" : [WQHasJoinedWanQuanEducationModel class]
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
