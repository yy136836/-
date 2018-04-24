//
//  WQEaseMobTools.h
//  WanQuan-iOS
//
//  Created by linhuijie on 2017/1/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileModel.h"

@interface WQEaseMobTools : NSObject

+(void)fetchNickNameAndAvatar:(NSString *)uid isTrueName:(BOOL)isTrueName completion:(void (^)(WQUserProfileModel *userModel, BOOL isTrueName, NSString *imageUrl))completion;

@end

