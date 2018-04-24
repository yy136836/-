//
//  WQMiriadeaModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/15.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMiriadeaModel.h"
#import "WQretransmissionModel.h"
#import "WQlike_listModel.h"

@implementation WQMiriadeaModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"like_list" : [WQlike_listModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
