//
//  WQDataEmptyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/28.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQDataEmptyView.h"

@implementation WQDataEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UILabel *textLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
    self.textLabel = textLabel;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines=2;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

@end
