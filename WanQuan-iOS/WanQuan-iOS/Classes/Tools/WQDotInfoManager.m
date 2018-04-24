//
//  WQDotInfoManager.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDotInfoManager.h"

@interface WQDotInfoManager ()

@property (nonatomic, retain) NSURLSessionDataTask * task;
@property (nonatomic, retain) dispatch_queue_t queue;

@end

@implementation WQDotInfoManager

+ (instancetype)manager {
    
    
    static WQDotInfoManager * manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manger = [[self alloc] init];
        
    });
    return manger;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefreshDotStatus) name:@"" object:nil];
   }
    return self;
}


- (void)startRefreshDotStatus {

    NSString * strURL =  @"api/message/reddot";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
    
    if (_task) {
        
        [_task cancel];
    }
    
    _task = [[WQNetworkTools sharedTools] request:WQHttpMethodPost
                                        urlString:strURL
                                       parameters:param
                                       completion:^(id response, NSError *error) {
                                           
                                       }];
    
}
@end
