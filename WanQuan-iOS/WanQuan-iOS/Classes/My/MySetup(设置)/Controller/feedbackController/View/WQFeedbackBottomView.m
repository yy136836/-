//
//  WQFeedbackBottomView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQFeedbackBottomView.h"

@implementation WQFeedbackBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiangdandibubeijing"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 提交
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.backgroundColor = [UIColor whiteColor];
    submitBtn.layer.borderWidth = 1.0f;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    submitBtn.layer.borderColor = [UIColor colorWithHex:0X9767d0].CGColor;
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithHex:0X9767d0] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(kScaleY(220), kScaleX(ghCellHeight)));
    }];
}

#pragma mark -- 提交的响应事件
- (void)submitBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqSubmitBtnClick:)]) {
        [self.delegate wqSubmitBtnClick:self];
    }
}

@end
