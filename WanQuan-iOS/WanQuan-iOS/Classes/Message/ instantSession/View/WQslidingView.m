//
//  WQslidingView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQslidingView.h"

@implementation WQslidingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat w = 35;
    CGFloat h = 4;
    CGFloat x = 0;
    CGFloat y = (rect.size.height - h) * 0.5;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
    [[UIColor whiteColor] set];
    [path fill];
}

@end
