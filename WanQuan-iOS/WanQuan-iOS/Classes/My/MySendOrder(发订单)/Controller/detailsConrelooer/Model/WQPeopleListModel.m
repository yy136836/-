//
//  WQPeopleListModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQPeopleListModel.h"

@implementation WQPeopleListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"like_list" : [WQPeopleListModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
