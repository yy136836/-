//
//  WQFriendsCirclePublishView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFriendsCirclePublishView.h"

@implementation WQFriendsCirclePublishView

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

#pragma mark --初始化view
- (void)setupView {
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.layer.borderWidth= 1.0f;
    contentTextView.layer.borderColor= [UIColor colorWithHex:0Xe1e1e1].CGColor;
    [self addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.offset(kScaleX(120));
    }];
    
    UIButton *addbtn = [[UIButton alloc] init];
    [addbtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
}

@end
