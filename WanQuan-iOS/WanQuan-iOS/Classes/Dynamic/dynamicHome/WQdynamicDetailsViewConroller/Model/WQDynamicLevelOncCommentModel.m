

//
//  WQDynamicLevelOncCommentModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQDynamicLevelOncCommentModel.h"
#import "WQDynamicLevelSecondaryModel.h"

@implementation WQDynamicLevelOncCommentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"comment_children" : [WQDynamicLevelSecondaryModel class],
             };
}

- (NSString *)description {
    return [self yy_modelDescription];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)WQSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [self setValuesForKeysWithDictionary:keyedValues];
    if (!_id.length) {
        _id = keyedValues[@"cid"];
    }
}

@end
