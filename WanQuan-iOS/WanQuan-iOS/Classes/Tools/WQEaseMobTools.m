//
//  WQEaseMobTools.m
//  WanQuan-iOS
//
//  Created by linhuijie on 2017/1/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQEaseMobTools.h"

@implementation WQEaseMobTools

/**
 *用环信id从服务器端获取用户昵称、头像等信息,isTrueName表示是否需要匿名
 */
+(void)fetchNickNameAndAvatar:(NSString *)uid isTrueName:(BOOL)isTrueName completion:(void (^)(WQUserProfileModel *userModel, BOOL isTrueName, NSString *imageUrl))completion {
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *secretKey = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:@{@"secretkey":secretKey, @"uid":uid} completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        WQUserProfileModel* userModel = [WQUserProfileModel yy_modelWithJSON:response];
        NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",userModel.pic_truename]];
        
        completion(userModel, isTrueName, imageUrl);
    }];
}

@end
