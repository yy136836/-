//
//  WQevaluateViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQevaluateViewController;

@protocol WQevaluateViewControllerDelegate <NSObject>

- (void)wqEvaluateViewControllerRefresh:(WQevaluateViewController *)wqEvaluateViewController;

@end

@interface WQevaluateViewController : UIViewController
@property (nonatomic, weak) id<WQevaluateViewControllerDelegate>delegate;

@property (nonatomic, copy) void (^didSelectBlock)(NSInteger);

- (instancetype)initWithneedId:(NSString *)needId;
@end
