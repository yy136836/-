//
//  WQNavigationController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNavigationController.h"

@interface WQNavigationController ()

@end

@implementation WQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置nav所有的tintColor
    //[self.navigationBar setTintColor:[UIColor colorWithHex:0Xa550d6]];
    //self.navigationBar.barTintColor = [UIColor colorWithHex:0Xa550d6];
    
    //[self.navigationBar setShadowImage:[[UIImage alloc] init]];
    //[self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 设置nav所有的tintColor默认为白色
    //[self.navigationBar setTintColor:[UIColor whiteColor]];
    // 默认nav是白色的
    //[self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}


@end
