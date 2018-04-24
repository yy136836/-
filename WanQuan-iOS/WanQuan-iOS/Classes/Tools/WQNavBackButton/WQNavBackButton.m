//
//  WQNavBackButton.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNavBackButton.h"

@implementation WQNavBackButton
- (instancetype)initWithTintColor:(UIColor *)blackOrWhite {
    WQNavBackButton * btn = [[NSBundle mainBundle] loadNibNamed:@"WQNavBackButton" owner:nil options:nil].lastObject;
    if (!blackOrWhite) {
        btn.tintColor = [UIColor blackColor];
    } else {
        btn.tintColor = blackOrWhite;
    }
    return btn;
}
@end
