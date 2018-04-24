//
//  WQGroupDemandForDetailsViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQGroupDemandForDetailsViewController : UIViewController
@property (nonatomic, copy) NSString *needId;
@property (nonatomic, copy) NSString *gnid;

/**
 是不是圈主或者管理员
 */
@property (nonatomic, assign) BOOL isGroupManager;
@property (nonatomic ,assign) BOOL isTop;
@property (nonatomic, copy) void(^settopSuccessBlock)();
@property (nonatomic, copy) void(^needsDeleteSuccessfulBlock)();

@end
