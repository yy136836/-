//
//  WQreplyModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQreplyModel.h"

@implementation WQreplyModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"results" : [WQreplyModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
