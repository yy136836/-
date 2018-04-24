//
//  WQfeedbackView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQfeedbackView.h"
#import "WQTextField.h"

@interface WQfeedbackView()<UITextViewDelegate>

@property (nonatomic, strong) UIView *lineView;

@end

@implementation WQfeedbackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma make - 初始化UI
- (void)setupUI {
    [self addSubview:self.feedbackTextView];
    [self addSubview:self.titleTextField];
    [self addSubview:self.lineView];
    
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        make.height.offset(51);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTextField.mas_bottom);
        make.left.right.equalTo(self);
        make.height.offset(0.5);
    }];
    
    [_feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        make.height.offset(kScreenHeight / 3);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_feedbackTextView endEditing:YES];
    [_titleTextField endEditing:YES];
}

#pragma make - 懒加载
- (UITextView *)feedbackTextView {
    if (!_feedbackTextView) {
        _feedbackTextView = [[UITextView alloc]init];
        _feedbackTextView.placeholder = @"请输入您要反馈的内容";
        _feedbackTextView.placeholderColor = [UIColor colorWithHex:0xb2b2b2];
        _feedbackTextView.delegate = self;
        [_feedbackTextView setFont:[UIFont systemFontOfSize:15]];
        _feedbackTextView.backgroundColor = [UIColor whiteColor];
    }
    return _feedbackTextView;
}
- (WQTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[WQTextField alloc]init];
        _titleTextField.placeholder = @" 请输入您的标题";
        [_titleTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        [_titleTextField setValue:[UIColor colorWithHex:0xb2b2b2] forKeyPath:@"_placeholderLabel.textColor"];
        _titleTextField.font = [UIFont systemFontOfSize:16];
        _titleTextField.backgroundColor = [UIColor whiteColor];
    }
    return _titleTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _lineView;
}

@end
