//
//  NSURL+WQParse.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "NSURL+WQParse.h"

@implementation NSURL (WQParse)

-(NSDictionary *)parameters {
    
    
    NSMutableDictionary * ret = nil;
    if (self.absoluteString.length) {
        
        NSArray * arr = [self.absoluteString componentsSeparatedByString:@"?"];
        if (arr.count == 1) {
            return ret;
        }
        NSString * paramStr = arr.lastObject;
        if (paramStr.length == 0) {
            
            return ret;
        }
        
        NSArray * paramStrArray = [paramStr componentsSeparatedByString:@"&"];
        
        ret = @{}.mutableCopy;
        for (NSString * p in paramStrArray) {
            
            NSMutableArray *kv = [p componentsSeparatedByString:@"="].mutableCopy;
            
            
            if (kv.count > 1) {
                kv[0] = [kv[0] stringByRemovingPercentEncoding];
                kv[1] = [kv[1] stringByRemovingPercentEncoding];
                
                kv[0] = [kv[0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]][0];
                kv[1] = [kv[1] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]][0];
                
                ret[kv[0]] = kv[1];
            } else {
                
                ret[kv[0]] = [NSNull null];
            }
        }
    }
    return ret;
}

@end
