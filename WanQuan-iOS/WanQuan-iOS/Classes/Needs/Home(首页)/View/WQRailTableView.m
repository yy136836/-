//
//  WQRailTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQRailTableView.h"


@implementation WQRailTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat w = 20;
    CGFloat h = 3;
    CGFloat x = 0;
    CGFloat y = (rect.size.height - h) * 0.5;
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
    [[UIColor colorWithHex:0x9767d0] set];
    [path fill];
}

@end
