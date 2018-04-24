//
//  WQTopWIndowManager.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQTopLevelWindow.h"
@interface WQTopWIndowManager : NSObject
@property (nonatomic, retain)WQTopLevelWindow * window;
+ (instancetype)manager;


- (void)dismissWindow;

- (void)showWindowWithViewController:(UIViewController *)vc;
@end
