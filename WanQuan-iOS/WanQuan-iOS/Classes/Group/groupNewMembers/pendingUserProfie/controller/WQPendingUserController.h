//
//  WQPendingUserController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 群组使用的个人页面
 */
@interface WQPendingUserController : UIViewController
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * gid;
@property (nonatomic, copy) NSString * requestInfo;

@property (nonatomic, copy) void(^loadDataBlock)();

@end
