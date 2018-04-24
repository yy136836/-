//
//  WQShowGroupInputView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQShowGroupInputView.h"

@implementation WQShowGroupInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPopupWindow];
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4];
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
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(kScreenHeight / 8 + 90);
        make.height.offset(142);
    }];
    
    // 输入框
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [textView setFont:[UIFont systemFontOfSize:14]];
    textView.placeholder = @"请填写转发内容!";
    [backgroundView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(backgroundView);
        make.height.offset(100);
    }];
    
    // 按钮中间的分割线
    UIView *centerLineView = [[UIView alloc] init];
    centerLineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [backgroundView addSubview:centerLineView];
    [centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(0.5, 28));
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
    }];
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn addTarget:self action:@selector(cancelBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView.mas_left).offset(kScaleY(75));
        make.centerY.equalTo(centerLineView.mas_centerY);
    }];
    
    // 提交
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [submitBtn addTarget:self action:@selector(submitBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView.mas_right).offset(kScaleY(-75));
        make.centerY.equalTo(centerLineView.mas_centerY);
    }];
    
    // 分割线
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [backgroundView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.equalTo(backgroundView);
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-47);
    }];
}

// 取消
- (void)cancelBtnClike {
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(wqCancelBtnClike:)]) {
        [self.delegate wqCancelBtnClike:self];
    }
}
// 提交
- (void)submitBtnClike {
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(wqSubmitBtnClike:)]) {
        [self.delegate wqSubmitBtnClike:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
