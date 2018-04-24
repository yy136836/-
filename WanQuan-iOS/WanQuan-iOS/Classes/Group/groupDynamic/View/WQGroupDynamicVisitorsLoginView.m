//
//  WQGroupDynamicVisitorsLoginView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupDynamicVisitorsLoginView.h"
#import "WQLogInController.h"

@implementation WQGroupDynamicVisitorsLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVisitorsLoginView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -- 初始化游客登录
- (void)setupVisitorsLoginView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qunzudongtai"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(64);
    }];
    
    UILabel *tagonc = [UILabel labelWithText:@"还没有人发帖子" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagonc];
    [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(25);
    }];
    
    UILabel *tagtwo = [UILabel labelWithText:@"快快抓住机会,做第一个发帖人~" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    [self addSubview:tagtwo];
    [tagtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tagonc.mas_bottom).offset(5);
    }];
}

@end
