//
//  WQTopWIndowManager.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopWIndowManager.h"

@implementation WQTopWIndowManager


+ (instancetype)manager {
    static WQTopWIndowManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (void)dismissWindow {
    self.window.hidden = YES;
    self.window = nil;
}
- (void)showWindowWithViewController:(UIViewController *)vc {
    if (!self.window) {
        self.window = [[WQTopLevelWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

@end
