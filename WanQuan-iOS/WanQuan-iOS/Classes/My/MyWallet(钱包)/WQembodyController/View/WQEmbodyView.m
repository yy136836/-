//
//  WQEmbodyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/1.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEmbodyView.h"
#import "WQLineView.h"

@implementation WQEmbodyView {
    // 支付宝账号的label
    UILabel *accountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

#pragma mark -- 初始化View
- (void)setupView {
    // 账号
    UITextField *accountTextField = [[UITextField alloc] init];
    self.accountTextField = accountTextField;
    [self addSubview:accountTextField];
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        make.top.right.equalTo(self);
        make.height.offset(kScaleX(55));
    }];
    
    // 支付宝账号的label
    accountLabel = [UILabel labelWithText:@"支付宝账号:" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    accountTextField.leftView = accountLabel;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 分割线
    WQLineView *lineView = [[WQLineView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self);
        make.top.equalTo(accountTextField.mas_bottom);
    }];
    
    // 姓名
    UITextField *nameTextField = [[UITextField alloc] init];
    self.nameTextField = nameTextField;
    [self addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(self);
        make.height.offset(kScaleX(55));
        make.left.equalTo(accountTextField.mas_left);
    }];
    
    // 收款人姓名的label
    UILabel *nameLabel = [UILabel labelWithText:@"收款人姓名:" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    nameTextField.leftView = nameLabel;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 宽的分割线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(kScaleX(ghStatusCellMargin));
        make.top.equalTo(nameTextField.mas_bottom);
    }];
    
    // 提现金额的Label
    UILabel *embodyLabel = [UILabel labelWithText:@"提现金额 (元)" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:15];
    [self addSubview:embodyLabel];
    [embodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
    }];
    
    // 人民币符号的label
    UILabel *renminbiLabel = [UILabel labelWithText:@"¥" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:48];
    [self addSubview:renminbiLabel];
    [renminbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScaleY(30));
        make.left.equalTo(embodyLabel.mas_left);
        make.top.equalTo(embodyLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 提现金额输入框
    UITextField *embodyTextField = [[UITextField alloc] init];
    self.embodyTextField = embodyTextField;
    [self addSubview:embodyTextField];
    [embodyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(renminbiLabel.mas_centerY);
        make.left.equalTo(renminbiLabel.mas_right).offset(kScaleY(5));
        make.right.equalTo(self);
    }];
    
    // 人民币符号下的分割线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.equalTo(self);
        make.top.equalTo(renminbiLabel.mas_bottom);
    }];
    
    // 可用余额
    UILabel *availableBalanceLabel = [UILabel labelWithText:@"可用余额" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    self.availableBalanceLabel = availableBalanceLabel;
    [self addSubview:availableBalanceLabel];
    [availableBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(renminbiLabel.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(kScaleX(-8));
    }];

    // 提现说明按钮
    UIButton *descriptionBtn = [[UIButton alloc] init];
    descriptionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [descriptionBtn addTarget:self action:@selector(descriptionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [descriptionBtn setTitle:@"• 提现说明" forState:UIControlStateNormal];
    [descriptionBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
    [self addSubview:descriptionBtn];
    [descriptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
        make.centerY.equalTo(availableBalanceLabel.mas_centerY);
    }];
}

- (void)setState:(NSString *)state {
    _state = state;
    
    if ([state isEqualToString:@"微信"]) {
        //self.nameTextField.hidden = YES;
        accountLabel.hidden = YES;
        self.accountTextField.hidden = YES;
        [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.right.equalTo(self);
            make.height.offset(kScaleX(55));
        }];
    }
}

#pragma mark -- 提现说明的响应事件
- (void)descriptionBtnClick {
    if ([self.delegate respondsToSelector:@selector(wqDescriptionBtnClick:)]) {
        [self.delegate wqDescriptionBtnClick:self];
    }
}

@end
