//
//  WQSingleton.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/18.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQSingleton.h"
#import "WQloginModel.h"

@implementation WQDataSource
+ (instancetype)sharedTool {
    static WQDataSource *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setImageid:(NSString *)imageid {
    _imageid = imageid;
    [[NSNotificationCenter defaultCenter] postNotificationName:WQPicIdSuccessful object:self];
}

- (NSMutableArray<EaseConversationModel *> *)conversationModelArrayM {
    if (!_conversationModelArrayM) {
        _conversationModelArrayM = [NSMutableArray array];
    }
    return _conversationModelArrayM;
}

- (NSMutableArray *)IMFriendApplyInfoArrayM {
    if (!_IMFriendApplyInfoArrayM) {
        _IMFriendApplyInfoArrayM = [NSMutableArray array];
    }
    return _IMFriendApplyInfoArrayM;
}

- (BOOL)isVerified {
    return [[WQDataSource sharedTool].loginStatus isEqualToString:@"STATUS_VERIFIED"];
}

@end

@implementation WQSingleton
+ (instancetype)sharedManager {
    static WQSingleton *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginModel = [self loadUserAccount];
    }
    return self;
}

- (BOOL)isUserLogin {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"] && self.isExpires == NO) {
        return true;
    }
    return false;
}

- (BOOL)isExpires {
    if ([self.loginModel.expiredtime compare:[NSDate date]] == NSOrderedDescending) {
        return false;
    }
    return true;
}
- (NSString *)access_token {
    return self.loginModel.access_token;
}
// 归档
- (void)saveAccount:(WQloginModel *)account {
//    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:@"userAccount.archive"];
//    NSLog(@"%@",file);
    BOOL flag = NO;
    while (!flag) {
        flag = [NSKeyedArchiver archiveRootObject:account toFile:self.archivePath];
    }
}

// 解档
- (WQloginModel *)loadUserAccount {
    WQloginModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath];
    return account;
}

// 归档路径
- (NSString *)archivePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:@"userAccount.archive"];
}

+ (void)huanxinLoginWithUsername:(NSString *)username password:(NSString *)password {
    //在调用登录方法前，应该先判断是否设置了自动登录，如果设置了，则不需要您再调用。
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        if(!error){
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            NSLog(@"登录成功！");
        }else{
            NSLog(@"登录失败！%@", error.errorDescription);
        }
    }
}




@end
