//
//  NSDictionary+WQEqual.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "NSDictionary+WQEqual.h"

@implementation NSDictionary (WQEqual)
- (BOOL)WQ_equalTo:(NSDictionary *)dic {
    if (self.allKeys.count != dic.allKeys.count) {
        return NO;
    }
    
    for (NSString * key in self.allKeys) {
        if (![dic[key] isEqualToString:self[key] ]) {
            return NO;
        }
    }
    return YES;
}

@end
