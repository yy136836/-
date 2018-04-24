//
//  WQnewFriendsModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQnewFriendsModel : NSObject

@property (nonatomic, copy) NSString *aUsername;
@property (nonatomic, copy) NSString *aUserMessage;

+ (instancetype)initWUsername:(NSString *)username userMessage:(NSString *)message;

@end
