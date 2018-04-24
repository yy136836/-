//
//  WQSelectViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSelectViewController;

@protocol WQSelectViewControllerDelegate <NSObject>

- (void)wqSelectViewControllerWithvc:(WQSelectViewController *)vc index:(NSIndexPath *)index;

@end

@interface WQSelectViewController : UIViewController

@property(nonatomic ,weak) id<WQSelectViewControllerDelegate>delegate;

@end
