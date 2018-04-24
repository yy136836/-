//
//  WQaddWorkViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQaddWorkViewController : UIViewController

@property (nonatomic, assign) BOOL isReleaseNeeds;

@property (nonatomic, copy) void(^addSuccessfulBlock)();

@end
