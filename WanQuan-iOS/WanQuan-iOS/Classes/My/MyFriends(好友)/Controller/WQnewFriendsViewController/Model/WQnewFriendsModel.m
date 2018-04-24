//
//  WQnewFriendsModel.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQnewFriendsModel.h"

@implementation WQnewFriendsModel

+ (instancetype)initWUsername:(NSString *)username userMessage:(NSString *)message {
    WQnewFriendsModel *model = [[self alloc] init];
    model.aUsername = username;
    model.aUserMessage = message;
    return model;
}

@end
