//
//  WQmodifyEducationTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQmodifyEducationTableViewCell.h"

@interface WQmodifyEducationTableViewCell()<UITextFieldDelegate>

@end

@implementation WQmodifyEducationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    for (UITextField * field in self.contentView.subviews) {
        if ([field isKindOfClass:[UITextField class]]) {
            field.delegate = self;
        }
    }
}
- (IBAction)admissionTimeBtnClike:(id)sender {
    if ([self.delegata respondsToSelector:@selector(wqkaishishijianBtnClikeDelegate:)]) {
        [self.delegata wqkaishishijianBtnClikeDelegate:self];
    }
}
- (IBAction)theEndOfTimeBtnClike:(id)sender {
    if ([self.delegata respondsToSelector:@selector(wqjieshushijianBtlClikeDelegata:)]) {
        [self.delegata wqjieshushijianBtlClikeDelegata:self];
    }
}

- (void)textFieldDidEndEditingNotification:(NSNotification *)sender {
    [self textFieldDidEndEditing:self.schoolTextField];
    [self textFieldDidEndEditing:self.enteringSchoolTextField];
    [self textFieldDidEndEditing:self.graduateTextField];
    [self textFieldDidEndEditing:self.specialtyTextField];
    //[self textFieldDidEndEditing:self.degreesTextField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.schoolTextField endEditing:YES];
    [self.enteringSchoolTextField endEditing:YES];
    [self.graduateTextField endEditing:YES];
    [self.specialtyTextField endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.contentBlock) {
        self.contentBlock(textField.text);
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    for (UITextField * field in self.contentView.subviews) {
        if ([field isKindOfClass:[UITextField class]]) {
            if (field != textField) {
                [field resignFirstResponder];
            }
        }
    }
}

- (IBAction)aDegreeInBtnClike:(id)sender {
    if (self.aDegreeInBtnClikeBlock) {
        self.aDegreeInBtnClikeBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma make - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
