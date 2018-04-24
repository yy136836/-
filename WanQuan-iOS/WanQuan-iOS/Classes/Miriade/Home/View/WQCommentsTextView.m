//
//  WQCommentsTextView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentsTextView.h"

@implementation WQCommentsTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setUpView {
    UITextView *textView = [[UITextView alloc] init];
    [self addSubview:textView];
}

@end
