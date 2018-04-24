//
//  WQTopLevelWindow.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopLevelWindow.h"

@implementation WQTopLevelWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = MAXFLOAT;
    }
    return self;
}


@end
