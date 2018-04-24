//
//  WQmodifyWorkTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmodifyWorkTableViewCell.h"
#import "WQTwoUserProfileModel.h"

@interface WQmodifyWorkTableViewCell()<UITextFieldDelegate>

@end

@implementation WQmodifyWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [self.kaishiTimeBtn addClickAction:^(UIButton * _Nullable sender) {
        if ([self.delegate respondsToSelector:@selector(wqkaishishijianBtnClikeDelegate:)]) {
            [self.delegate wqkaishishijianBtnClikeDelegate:self];
        }
    }];
    [self.jieshuTimeBtn addClickAction:^(UIButton * _Nullable sender) {
        if ([self.delegate respondsToSelector:@selector(wqjieshushijianBtlClikeDelegata:)]) {
            [self.delegate wqjieshushijianBtlClikeDelegata:self];
        }
    }];
}

- (void)textFieldDidEndEditingNotification:(NSNotification *)sender {
    [self textFieldDidEndEditing:self.gongsimingcheng];
    [self textFieldDidEndEditing:self.kaishishijian];
    [self textFieldDidEndEditing:self.jiesushijian];
    [self textFieldDidEndEditing:self.zhiweimingcheng];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.gongsimingcheng endEditing:YES];
    [self.kaishishijian endEditing:YES];
    [self.jiesushijian endEditing:YES];
    [self.zhiweimingcheng endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.contentBlock) {
        self.contentBlock(textField.text);
    }
}

#pragma make - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
