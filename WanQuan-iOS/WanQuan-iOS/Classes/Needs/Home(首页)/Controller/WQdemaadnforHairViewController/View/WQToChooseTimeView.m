//
//  WQToChooseTimeView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/2/26.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQToChooseTimeView.h"

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface WQToChooseTimeView ()

@property (nonatomic, strong) NSArray *btns;

@end

@implementation WQToChooseTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfClick)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
        [self setupUI];
    }
    return self;
}

- (void)selfClick {
    self.hidden = !self.hidden;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.offset(192);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"选择需求截止时间" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    textLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [backgroundView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(backgroundView.mas_top).offset(17);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [backgroundView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(0.5);
        make.top.equalTo(textLabel.mas_bottom).offset(17);
    }];
    
    // 7天
    UIButton *sevenDaysBtn = [[UIButton alloc] init];
    [sevenDaysBtn setTitle:@"7天" forState:UIControlStateNormal];
    
    // 15天
    UIButton *fifteenDaysBtn = [[UIButton alloc] init];
    [fifteenDaysBtn setTitle:@"15天" forState:UIControlStateNormal];
    
    // 1个月
    UIButton *aMonthBtn = [[UIButton alloc] init];
    [aMonthBtn setTitle:@"1个月" forState:UIControlStateNormal];
    
    // 自定义
    UIButton *customBtn = [[UIButton alloc] init];
    [customBtn setTitle:@"自定义" forState:UIControlStateNormal];
    
    self.btns = @[sevenDaysBtn,fifteenDaysBtn,aMonthBtn,customBtn];
    
    for (int i = 0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
        btn.layer.cornerRadius = 30;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [backgroundView addSubview:btn];
    }
    
    aMonthBtn.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    aMonthBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    [aMonthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 两个控件的间距~~最左边一个距离左边的间距~~最右边一个距离尾部的间距~~
    [self.btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    CGFloat spacing = 0.0f;
    if (iPhone6Plus) {
        spacing = 48.5;
    }else {
        spacing = kScaleX(33);
    }
    [self.btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:spacing leadSpacing:kScaleX(17) tailSpacing:kScaleX(17)];
}

#pragma mark -- 7天的响应事件
- (void)btnClick:(UIButton *)btn {
    for (int i = 0; i < self.btns.count; i++) {
        UIButton *b = self.btns[i];
        if (i == btn.tag) {
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            b.backgroundColor = [UIColor colorWithHex:0x9767d0];
            btn.layer.borderWidth = .0f;
            btn.layer.borderColor = [UIColor colorWithHex:0x9767d0].CGColor;
        }else {
            [b setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
            b.backgroundColor = [UIColor whiteColor];
            btn.layer.borderWidth = 1.0f;
            btn.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
        }
    }
    NSString *str;
    if (btn.tag == 0) {
        str = @"7天";
    }else if (btn.tag == 1) {
        str = @"15天";
    }else if (btn.tag == 2) {
        str = @"1个月";
    }else {
        str = @"自定义";
    }
    
    if (self.toChooseTimeBlock) {
        self.toChooseTimeBlock(str);
    }
}

@end
