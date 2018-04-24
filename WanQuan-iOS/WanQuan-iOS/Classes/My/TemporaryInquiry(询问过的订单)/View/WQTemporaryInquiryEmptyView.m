//
//  WQTemporaryInquiryEmptyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTemporaryInquiryEmptyView.h"

@implementation WQTemporaryInquiryEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVisitorsLoginView];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

#pragma mark -- 初始化
- (void)setupVisitorsLoginView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wudingdan"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(64);
    }];
    
    UILabel *tagonc = [UILabel labelWithText:@"暂时没有订单数据" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagonc];
    [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
    UILabel *tagtwo = [UILabel labelWithText:@"去看看是否有感兴趣的需求吧" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagtwo];
    [tagtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tagonc.mas_bottom).offset(5);
    }];
}

@end
