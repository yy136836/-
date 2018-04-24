//
//  WQfriendsModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQfriendsModel.h"
#import "WQfriend_listModel.h"

@implementation WQfriendsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"friend_list" : [WQfriend_listModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
