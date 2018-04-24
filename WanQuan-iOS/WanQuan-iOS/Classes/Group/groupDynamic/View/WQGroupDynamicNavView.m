//
//  WQGroupDynamicNavView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/12.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDynamicNavView.h"

@implementation WQGroupDynamicNavView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 画白色
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor colorWithHex:0xf7f7f7] set];
    [path fill];
    
    // 画黑色的线
    CGFloat onePx = 0.5 / [UIScreen mainScreen].scale;
    // 计算Y
    CGFloat lineY = self.bounds.size.height - onePx;
    UIBezierPath* line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(0, lineY)];
    [line addLineToPoint:CGPointMake(self.bounds.size.width, lineY)];
    [[UIColor colorWithHex:0xeeeeee] set];
    [line stroke];
    
    
    
}

@end
