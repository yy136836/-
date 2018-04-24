//
//  WQpublishTwoTextView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQpublishTwoTextView.h"

@implementation WQpublishTwoTextView

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}
#pragma mark -- 初始化UI
- (void)setupUI {
    UITextView *inputBoxTextView = [[UITextView alloc]init];
    self.inputBoxTextView = inputBoxTextView;
    inputBoxTextView.backgroundColor = [UIColor whiteColor];
    inputBoxTextView.font = [UIFont systemFontOfSize:14];
    inputBoxTextView.layer.borderWidth= 1.0f;
    inputBoxTextView.layer.borderColor= [UIColor colorWithHex:0Xe1e1e1].CGColor;
    [self addSubview:inputBoxTextView];
    [inputBoxTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.offset(120);
    }];
}
@end
