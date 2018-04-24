//
//  WQContactManager.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

typedef void(^addFriendComplete)(NSError * error, id response);

#import <Foundation/Foundation.h>

/**
 该类主要用于环信联系人的管理新类需要继续充实该类
 */
@interface WQContactManager : NSObject
+ (BOOL)haveUnacceptedFriendRequest;
+ (void)recieveNewFriendRequest:(NSString *)userId;
+ (void)addNewFriend:(NSString *)userId completetionHandler:(addFriendComplete)complete;
@end
