//
//  WQloginModel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/18.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQloginModel : NSObject
@property (nonatomic, strong) NSDate *expiredtime;         // 口令是否过期
@property (nonatomic, copy) NSString *access_token;        // 返回的口令
@property (nonatomic, assign) NSTimeInterval expires_in;   // 过期时间
@property (nonatomic, strong) NSDate *expiresDate;         // 过期的具体时间
@property (readonly ,copy, nonatomic)NSString *gain_token; // 获取口令

@end
