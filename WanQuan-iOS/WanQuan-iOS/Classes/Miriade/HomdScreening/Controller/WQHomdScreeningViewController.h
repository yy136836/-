//
//  WQHomdScreeningViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQHomdScreeningViewController : UIViewController

/**
 是否是我的动态
 */
@property (nonatomic, assign) BOOL isMyDynamic;

@property (nonatomic, copy) void(^deleteSuccessfulBlock)();

@end
