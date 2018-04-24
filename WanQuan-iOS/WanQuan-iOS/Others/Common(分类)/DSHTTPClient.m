//
//  DSHTTPClient.m
//  gh_load
//
//  Created by gh_load on 15/8/3.
//  Copyright (c) 2015年 gh_load. All rights reserved.
//

#import "DSHTTPClient.h"


@implementation DSHTTPClient

+ (instancetype)shareInstance{
    
    static DSHTTPClient *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[DSHTTPClient alloc]initWithBaseURL:nil];
        client.requestSerializer = [[AFJSONRequestSerializer alloc]init];
    
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];    }); 
    
    return client;
    
}

+ (void)getUrlString:(NSString *)url
           withParam:(NSDictionary *)param
    withSuccessBlock:(successBlock)success
     withFailedBlock:(failedBlock)failed
      withErrorBlock:(errorBlock)error{
    

    [[self shareInstance] GET:url parameters:param  success:^(NSURLSessionDataTask *task, NSDictionary  *responseObject) {
        
        
       success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failed(error);
        
    }];
    

}

+ (void)postUrlString:(NSString *)url
            withParam:(NSDictionary *)param
     withSuccessBlock:(successBlock)success
      withFailedBlock:(failedBlock)failed
       withErrorBlock:(errorBlock)error{
    
    [[self shareInstance] POST:url parameters:param success:^(NSURLSessionDataTask *task, NSDictionary  *dic) {
        
       int result = [dic[@"code"] intValue];
        if (success) {
            if (result == 0 ) {
                success(dic[@"data"]);
            }else if (result == 1 ){
                NSString *message = [dic objectForKey:@"msg"];
                error(message);
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failed(error);
        
    }];

}


@end
