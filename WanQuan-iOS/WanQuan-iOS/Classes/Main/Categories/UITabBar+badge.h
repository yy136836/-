//
//  UITabBar+badge.h
//  WanQuan-iOS
//
//  Created by Huijie Lin on 22/03/2017.
//  Copyright © 2017 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点


@end
