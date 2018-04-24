//
//  WQNetworkTools.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, WQHttpMethod) {
    WQHttpMethodGet,
    WQHttpMethodPost
};




typedef void(^CompletionHandler)(id response, NSError *error);


@interface WQNetworkTools : AFHTTPSessionManager


@property (nonatomic, retain) NSURLSessionDataTask * dotTask;

//单例
+ (instancetype)sharedTools;
//请求网络方法
- (NSURLSessionDataTask *)request:(WQHttpMethod)method urlString:(NSString *)urlString parameters:(id)parameters completion:(void(^)(id response, NSError *error))completion;


- (NSURLSessionDataTask *)ImageRequest:(WQHttpMethod)method urlString:(NSString *)urlString completion:(void (^)(id, NSError *))completion;


- (NSURLSessionDataTask *)fetchRedDot;

- (NSURLSessionDataTask *)request:(WQHttpMethod)method whithHudForbidInteractions:(BOOL)forbidInteraction urlString:(NSString *)urlString parameters:(id)parameters completion:(CompletionHandler)handler;

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl;


@end
