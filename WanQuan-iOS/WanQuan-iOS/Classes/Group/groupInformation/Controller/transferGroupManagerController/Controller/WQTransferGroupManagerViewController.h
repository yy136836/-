//
//  WQTransferGroupManagerViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WQType) {
    // 权限转让
    wqTransfer = 0,
    // 设置管理员
    wqAdministrator,
};

@interface WQTransferGroupManagerViewController : UIViewController

@property (nonatomic, copy) NSString *gid;

@property (nonatomic, assign) WQType type;

/**
 添加管理员成功的回调
 */
@property (nonatomic, copy) void(^addSuccessBlock)();

@end
