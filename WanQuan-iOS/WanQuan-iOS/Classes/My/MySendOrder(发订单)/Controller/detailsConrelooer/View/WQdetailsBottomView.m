//
//  WQdetailsBottomView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdetailsBottomView.h"

@implementation WQdetailsBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiangdandibubeijing"]];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *askBtn = [[UIButton alloc] init];
    askBtn.layer.cornerRadius = 5;
    askBtn.layer.masksToBounds = YES;
    askBtn.backgroundColor = [UIColor whiteColor];
    askBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    askBtn.layer.borderWidth = 1.0f;
    askBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
    [askBtn setTitle:@" 回答未接单者的询问" forState:UIControlStateNormal];
    [askBtn setImage:[UIImage imageNamed:@"dingdanlianxifadanren2"] forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:askBtn];
    [askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.offset(ghCellHeight);
        make.width.offset(220);
        make.top.equalTo(self.mas_top).offset(ghSpacingOfshiwu);
    }];
    
    UIView *redView = [[UIView alloc] init];
    self.redView = redView;
    self.redView.hidden = YES;
    redView.backgroundColor = [UIColor redColor];
    [askBtn addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(askBtn).offset(5);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    redView.layer.cornerRadius = 4;
    redView.layer.masksToBounds = YES;
}

- (void)askBtnClick {
    if ([self.delegate respondsToSelector:@selector(askBtnClick:)]) {
        [self.delegate askBtnClick:self];
    }
}

@end
