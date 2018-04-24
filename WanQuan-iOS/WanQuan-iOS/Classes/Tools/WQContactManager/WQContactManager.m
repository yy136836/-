//
//  WQContactManager.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQContactManager.h"

@implementation WQContactManager
+ (BOOL)haveUnacceptedFriendRequest {
    
    ROOT(root);
    BOOL have = NO;
    if (root) {
        have = root.haveFriendapply;
    }
    
    return have;
}


+ (void)recieveNewFriendRequest:(NSString *)userId {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * oldRequests = [[userDefaults objectForKey:@"aUsername"] mutableCopy];
    NSMutableArray * newRequests = oldRequests ? oldRequests.mutableCopy : @[].mutableCopy;
    
    for(NSString * requestId in newRequests) {
        //        当该人已经请求过之后
        if([userId isEqualToString:requestId]) {
            return;
        }
    }
    
    [newRequests addObject:userId];
    [userDefaults setObject:newRequests forKey:WQFriendRequestKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WQRecieveFriendRequestNotifacation object:nil];
}

+ (void)addNewFriend:(NSString *)userId completetionHandler:(addFriendComplete)complete {
    
    
    NSMutableDictionary * params = @{}.mutableCopy;
    
    NSString *urlString = @"api/friend/add";
    
    
    NSArray * aList = @[userId];
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:aList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *labelTagString = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"friends"] = labelTagString;
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {

        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        
        if ([response[@"success"] boolValue]) {
            NSArray * old = [[NSUserDefaults standardUserDefaults] valueForKey:WQFriendRequestKey];
            NSMutableArray * new = old.mutableCopy;
            for (NSString * id in old) {
                if ([id isEqualToString:userId]) {
                    [new removeObject:id];
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:new forKey:WQFriendRequestKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:WQAddFriendNotifacation object:nil];
        }
        

        complete(error,response);
    }];
    
}
@end
