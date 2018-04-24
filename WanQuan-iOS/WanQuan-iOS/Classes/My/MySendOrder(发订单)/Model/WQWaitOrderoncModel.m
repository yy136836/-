//
//  WQWaitOrderoncModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQWaitOrderoncModel.h"
#import "WQWaitOrderModel.h"

@implementation WQWaitOrderoncModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"needs" : [WQWaitOrderModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
