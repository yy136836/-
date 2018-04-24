//
//  WQDynamicChannelOffPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQDynamicChannelOffPopupWindowView.h"

@implementation WQDynamicChannelOffPopupWindowView {
    NSUserDefaults *ghUserDefaults;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        ghUserDefaults = [NSUserDefaults standardUserDefaults];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:.3];
        UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapClick)];
        [self addGestureRecognizer:selfTap];
    }
    return self;
}

- (void)selfTapClick {
    self.hidden = !self.hidden;
    [ghUserDefaults setObject:@"YES" forKey:@"dynamicChannelOff"];
}


#pragma mark - 初始化View
- (void)setupView {
    // 背景框
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dongtaitanchuang"]];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(116);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    // 去看看的按钮
    UIButton *goAndSeeBtn = [[UIButton alloc] init];
    goAndSeeBtn.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:0];
    goAndSeeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    goAndSeeBtn.layer.cornerRadius = 5;
    goAndSeeBtn.layer.masksToBounds = YES;
    goAndSeeBtn.layer.borderWidth = 1.0f;
    goAndSeeBtn.layer.borderColor = [UIColor colorWithHex:0x9767d0].CGColor;
    [goAndSeeBtn addTarget:self action:@selector(goAndSeeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goAndSeeBtn setTitle:@"好的,这就去看看" forState:UIControlStateNormal];
    [goAndSeeBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [self addSubview:goAndSeeBtn];
    [goAndSeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(imageView.mas_left).offset(ghSpacingOfshiwu);
        make.right.equalTo(imageView.mas_right).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(imageView.mas_bottom).offset(-ghSpacingOfshiwu);
        make.height.offset(ghCellHeight);
    }];
    
    UIButton *xBtn = [[UIButton alloc] init];
    
    [xBtn addClickAction:^(UIButton * _Nullable sender) {
        self.hidden = !self.hidden;
        [ghUserDefaults setObject:@"YES" forKey:@"dynamicChannelOff"];
    }];
    
    [self addSubview:xBtn];
    [xBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark -- 去看看的响应事件
- (void)goAndSeeBtnClick {
    self.hidden = !self.hidden;
    [ghUserDefaults setObject:@"YES" forKey:@"dynamicChannelOff"];
}

@end
