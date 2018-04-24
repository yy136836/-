//
//  WQPopupWindowEncourageView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/31.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPopupWindowEncourageView.h"
#import "WQLineView.h"

@implementation WQPopupWindowEncourageView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPopupWindow];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.3];
    }
    return self;
}

#pragma mark - 初始化PopupWindow
- (void)setupPopupWindow {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kScreenHeight / 8 + 90);
        make.size.mas_equalTo(CGSizeMake(kScaleY(280), kScaleX(152)));
    }];
    
    // 鼓励金额的标签
    UILabel *tagLabel = [UILabel labelWithText:@"鼓励金额 (元)" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
    [self addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(backgroundView).offset(kScaleY(ghDistanceershi));
    }];
    
    // 人民币符号
    UILabel *renminbifuhaoLabel = [UILabel labelWithText:@"¥" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:48];
    [self addSubview:renminbifuhaoLabel];
    [renminbifuhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLabel.mas_bottom);
        make.left.equalTo(tagLabel);
        make.width.offset(26);
    }];
    
    // 输入金额
    UITextField *moneyTextField = [[UITextField alloc] init];
    self.moneyTextField = moneyTextField;
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    //phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:moneyTextField];
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(renminbifuhaoLabel.mas_centerY);
        make.height.offset(kScaleX(30));
        make.right.equalTo(backgroundView).offset(kScaleY(-ghSpacingOfshiwu));
        make.left.equalTo(renminbifuhaoLabel.mas_right).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 分割线
    WQLineView *lineView = [[WQLineView alloc] init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.right.left.equalTo(backgroundView);
        make.bottom.equalTo(backgroundView).offset(kScaleX(-50));
    }];
    
    // 竖着的分割线
    UIView *lineViewtwo = [[UIView alloc] init];
    lineViewtwo.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineViewtwo];
    [lineViewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5);
        make.bottom.equalTo(backgroundView).offset(kScaleX(-ghStatusCellMargin));
        make.top.equalTo(lineView.mas_bottom).offset(kScaleX(ghStatusCellMargin));
        make.centerX.equalTo(backgroundView.mas_centerX);
    }];
    
    // 提交的按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [submitBtn addTarget:self action:@selector(submitBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineViewtwo.mas_centerY);
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-50));
    }];
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineViewtwo.mas_centerY);
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(50));
    }];
}

#pragma mark -- 提交的响应事件
- (void)submitBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqSubmitBtnClike:moneyString:)]) {
        [self.delegate wqSubmitBtnClike:self moneyString:self.moneyTextField.text];
    }
}

#pragma mark -- 取消的响应事件
- (void)cancelBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqCancelBtn:)]) {
        [self.delegate wqCancelBtn:self];
    }
}

@end
