//
//  WQparticularsModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQparticularsModel.h"
#import "WQcommentListModel.h"
#import "WQrewardListModel.h"
#import "WQzanLike_listModel.h"

@implementation WQparticularsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comment_list" : [WQcommentListModel class],
             @"reward_list" : [WQrewardListModel class],
             @"like_list" : [WQzanLike_listModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
