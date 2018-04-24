//
//  WQTheArbitrationViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQTheArbitrationViewController;
@protocol WQTheArbitrationViewControllerDelegate <NSObject>

- (void)wqSubmittedToArbitrationForSuccess:(WQTheArbitrationViewController *)theArbitrationVC;

@end

@interface WQTheArbitrationViewController : UIViewController
@property (nonatomic, weak) id <WQTheArbitrationViewControllerDelegate>delegate;
- (instancetype)initWithNbid:(NSString *)nbid;
@end
