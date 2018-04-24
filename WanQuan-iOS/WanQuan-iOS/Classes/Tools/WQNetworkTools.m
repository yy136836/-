//
//  WQNetworkTools.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNetworkTools.h"
#import "WQNavigationController.h"
#import "WQLogInController.h"
#import "WQDatataskAlertView.h"


@interface WQNetworkTools()<UIAlertViewDelegate>
//@property (nonatomic, retain) NSMutableArray * timeOutTasks;

@end

@implementation WQNetworkTools

+ (instancetype)sharedTools {
    static dispatch_once_t onceToken;
    static WQNetworkTools *instabce;
    dispatch_once(&onceToken, ^{
        instabce = [[self alloc]init];
        // NSURL *url = [NSURL URLWithString:@"http://139.224.210.73:8181/"];

//#ifdef DEBUG
//        NSURL *url = [NSURL URLWithString:@"http://120.55.164.81:8181/"];
//
//#else
//        NSURL *url = [NSURL URLWithString:@"https://wanquan.belightinnovation.com/"];
//
//#endif
//        instabce = [[WQNetworkTools alloc] initWithBaseURL:url];
        instabce = [[WQNetworkTools alloc] initWithBaseURL:BASE_URL];
//        instabce.requestSerializer = [[AFJSONRequestSerializer alloc]init];
        instabce.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/xml", @"text/plain",nil];
        instabce.responseSerializer = [AFHTTPResponseSerializer serializer];
        instabce.requestSerializer.timeoutInterval = 15.f;
    });
    
    
    // instabce.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/xml", @"text/plain",nil];
    instabce.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return instabce;
}

- (NSURLSessionDataTask *)request:(WQHttpMethod)method urlString:(NSString *)urlString parameters:(id)parameters completion:(void (^)(id, NSError *))completion{
    // 请求成功的block
    void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        
        completion(responseObject, nil);

        if ([responseObject[@"ecode"] integerValue] == -2) {
            ROOT(root);
            
            UINavigationController * rootSelectedNC = root.selectedViewController;
            
            UIViewController * showingVC = rootSelectedNC.viewControllers.lastObject;
            
            BOOL loginVCShowing = [root.presentingViewController isKindOfClass:[WQLogInController class]] || [showingVC isKindOfClass:[WQLogInController class]];
            
            if (loginVCShowing) {
                return;
            }
            if (root) {
                
                WQLogInController * vc = [[WQLogInController alloc] initWithTouristLoginStatus:TouristLoginStatusNoHide];
                [root presentViewController:vc animated:YES completion:nil];
            }
        }
    };
    // 请求失败的block
    void(^failureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        

        // 请求失败
        // MARK: 请求超时
        if (error.code == 1001 && ![task.currentRequest.URL.absoluteString hasSuffix:@"api/message/reddot"]) {
            WQDatataskAlertView * alert = [[WQDatataskAlertView alloc] initWithTitle:@"" message:@"加载失败.." delegate:self cancelButtonTitle:@"重新加载" otherButtonTitles:nil];
//            [_timeOutTasks addObject:task];
            alert.dataTask = task;
            [alert show];
            return;
            
        }
        
        completion(nil, error);
    };
    if (method == WQHttpMethodGet) {
        //GET        
       return [self GET:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }else{
        //POST
       return [self POST:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
}



- (NSURLSessionDataTask *)fetchRedDot {
    
    if (_dotTask) {
        [_dotTask cancel];
        _dotTask = nil;
    }
    NSString * strURL = @"api/message/reddot";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return nil;
    }
    NSDictionary * param = @{@"secretkey":secreteKey};
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    NSURLSessionDataTask * task =  [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        
        
//        ecode = 0;
//        好友申请
//        "friendapply_count" = 0;
//        消息
//        message = 0;
//        入群申请
//        "message_applyjoingroup" = 0;
//        评论
//        "message_comment" = 0;
//        赞
//        "message_like" = 0;
//        系统消息
//        "message_sys" = 0;
//        "my_bidded_need_bidded_doing_count" = 0;
//        "my_bidded_need_bidded_finished_count" = 1;
//        "my_bidded_need_bidding_count" = 0;
//        "my_bidded_need_total_count" = 1;
//        "my_count" = 1;
//        "my_created_need_bidded_count" = 0;
//        "my_created_need_bidding_count" = 0;
//        "my_created_need_finished_count" = 0;
//        "my_created_need_total_count" = 0;
//        success = 1;

        
        
        
        
        ROOT(root);
        
        if (root) {
            if ([response[@"my_bidded_need_bidded_doing_count"] boolValue]||
                [response[@"my_bidded_need_bidding_count"] boolValue]||
                [response[@"my_created_need_bidded_count"] boolValue]||
                [response[@"my_created_need_bidding_count"] boolValue]) {
                root.haveBidInfoToDealWith = YES;
            } else {
                root.haveBidInfoToDealWith = NO;
            }
            
            
            
            root.haveFriendapply = [response[@"friendapply_count"] boolValue];
            
            root.haveSystemInfoToDealWith = [response[@"message_sys"] boolValue];
            
            root.haveGroupApply  = [response[@"message_applyjoingroup"] boolValue];
            
            root.haveCommentInfoToDealWith = [response[@"message_comment"] boolValue];
            
            root.haveMessageInfoToDealWith = [response[@"message"] boolValue];
            
            root.haveLikeTodealWith = [response[@"message_like"] boolValue];
            
            root.haveCircleEvent = [response[@"message_applyjoingroup"]boolValue]||[response[@"message_comment"]boolValue]||[response[@"message_like"]boolValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:nil];
        }
    }];
    _dotTask = task;
    return task;
}



- (NSURLSessionDataTask *)request:(WQHttpMethod)method whithHudForbidInteractions:(BOOL)forbidInteraction urlString:(NSString *)urlString parameters:(id)parameters completion:(CompletionHandler)handler {
    return nil;
}


#pragma mark - alertView
- (void)alertViewCancel:(UIAlertView *)alertView {
    if ([alertView isKindOfClass:[WQDatataskAlertView class]]) {
        WQDatataskAlertView * alert = alertView;
        [alert resumeTask];
     }
}


- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [WQAlert showAlertWithTitle:nil message:@"保存失败" duration:1];
    }else{
        [WQAlert showAlertWithTitle:nil message:@"保存成功" duration:1];
    }
}


@end
