//
//  WQAreaCodeModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAreaCodeModel.h"
#import "WQAreaCodeListModel.h"

@implementation WQAreaCodeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [WQAreaCodeListModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
