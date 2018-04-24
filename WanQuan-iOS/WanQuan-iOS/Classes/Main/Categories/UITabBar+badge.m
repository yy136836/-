//
//  UITabBar+badge.m
//  WanQuan-iOS
//
//  Created by Huijie Lin on 22/03/2017.
//  Copyright © 2017 WQ. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    NSInteger TabbarItemNums = [(UITabBarController *)(self.viewController) viewControllers].count;
    CGFloat percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            if (subView.superview) {
                if (subView.superview) {
                    [subView removeFromSuperview];
                }
            }
        }
    }
}

@end
