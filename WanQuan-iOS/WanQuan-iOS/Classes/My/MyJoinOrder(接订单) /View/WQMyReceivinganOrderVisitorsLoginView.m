//
//  WQMyReceivinganOrderVisitorsLoginView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMyReceivinganOrderVisitorsLoginView.h"

@implementation WQMyReceivinganOrderVisitorsLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self setupVisitorsLoginView];
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

//#pragma mark -- 初始化
//- (void)setupVisitorsLoginView {
//    
//}

- (void)setIsSendOrder:(BOOL)isSendOrder {
    if (isSendOrder) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wudingdan"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(64);
        }];
        
        UILabel *tagonc = [UILabel labelWithText:@"看看附近有谁在发需求" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
        [self addSubview:tagonc];
        [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(imageView.mas_bottom).offset(25);
        }];
        UILabel *tagtwo = [UILabel labelWithText:@"去发个单试试吧" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
        [self addSubview:tagtwo];
        [tagtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(tagonc.mas_bottom).offset(5);
        }];
    }else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wudingdan"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(60);
        }];
        
        UILabel *tagonc = [UILabel labelWithText:@"看看附近有谁在发需求" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
        [self addSubview:tagonc];
        [tagonc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(imageView.mas_bottom).offset(25);
        }];
        UILabel *tagtwo = [UILabel labelWithText:@"去抢单试试吧" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
        [self addSubview:tagtwo];
        [tagtwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(tagonc.mas_bottom).offset(5);
        }];
    }
}

@end
