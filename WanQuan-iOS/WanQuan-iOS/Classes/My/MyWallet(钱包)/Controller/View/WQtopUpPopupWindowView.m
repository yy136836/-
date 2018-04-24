//
//  WQtopUpPopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQtopUpPopupWindowView.h"

@interface WQtopUpPopupWindowView()
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *renminbifuhao;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView *verticalLineView;
@end

@implementation WQtopUpPopupWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
    }
    return self;
}

#pragma make - 初始化UI
- (void)setupUI {
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(kScreenHeight / 8 + 90);
        make.height.offset(142);
    }];
    
    [backgroundView addSubview:self.tagLabel];
    [backgroundView addSubview:self.renminbifuhao];
    [backgroundView addSubview:self.moneyTextField];
    [backgroundView addSubview:self.lineView];
    [backgroundView addSubview:self.verticalLineView];
    [backgroundView addSubview:self.returnBtn];
    [backgroundView addSubview:self.submitBtn];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_top).offset(15);
        make.left.equalTo(backgroundView.mas_left).offset(29);
    }];
    [_renminbifuhao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tagLabel.mas_left);
        make.top.equalTo(_tagLabel.mas_bottom).offset(10);
        make.width.offset(24);
    }];
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_renminbifuhao.mas_right).offset(18);
        make.centerY.equalTo(_renminbifuhao.mas_centerY);
        make.right.equalTo(backgroundView.mas_right).offset(-15);
        make.height.offset(ghCellHeight);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-47);
        make.left.right.equalTo(backgroundView);
    }];
    [_verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(0.5, 28));
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
    }];
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verticalLineView.mas_centerY);
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(75));
    }];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verticalLineView.mas_centerY);
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-75));
    }];
}

// 返回的响应事件
- (void)returnBtnClike {
    [self.moneyTextField resignFirstResponder];
    if (self.returnBtnClikeBlock) {
        self.returnBtnClikeBlock();
    }
}

// 提交的响应事件
- (void)submitBtnClike {
    [self.moneyTextField resignFirstResponder];
    if (self.submitBtnClikeBlock) {
        self.submitBtnClikeBlock(self.moneyTextField.text);
    }
}

#pragma make - 懒加载
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithText:@"充值金额 (元)" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:13];
    }
    return _tagLabel;
}
- (UILabel *)renminbifuhao {
    if (!_renminbifuhao) {
        _renminbifuhao = [UILabel labelWithText:@"¥" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:40];
    }
    return _renminbifuhao;
}
- (UITextField *)moneyTextField {
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.layer.borderWidth = .0f;
        _moneyTextField.returnKeyType = UIReturnKeyDone;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.placeholder = @"请输入金额";
    }
    return _moneyTextField;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _lineView;
}
- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc] init];
        [_returnBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        _returnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_returnBtn addTarget:self action:@selector(returnBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_submitBtn addTarget:self action:@selector(submitBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _verticalLineView;
}

@end
