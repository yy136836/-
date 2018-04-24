//
//  WQCommentsView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentsView.h"
#import "WQTextField.h"

@interface WQCommentsView () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *writingTwoImageView;;

@end

@implementation WQCommentsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 顶部分隔线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.top.equalTo(self);
    }];
    
    
    // 评论的输入框
    WQTextField *commentsTextField = [[WQTextField alloc] initWithTitleType:zhaoren];
    self.commentsTextField = commentsTextField;
    commentsTextField.placeholder = @"          评论";
    commentsTextField.layer.cornerRadius = 5;
    commentsTextField.layer.masksToBounds = YES;
    commentsTextField.delegate = self;
    commentsTextField.layer.borderWidth = 1.0f;
    commentsTextField.returnKeyType = UIReturnKeySend;
    commentsTextField.layer.borderColor = [UIColor colorWithHex:0xcbcbcb].CGColor;
    [commentsTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [commentsTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self addSubview:commentsTextField];
    [commentsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.offset(30);
    }];
    
    // 书写图标
    UIImageView *writingTwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
    self.writingTwoImageView = writingTwoImageView;
    [commentsTextField addSubview:writingTwoImageView];
    [writingTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.left.equalTo(commentsTextField.mas_left).offset(ghStatusCellMargin);
        make.top.equalTo(commentsTextField.mas_top).offset(6);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请填写内容" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return YES;
    }
    if (textField.text.length > 100) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请控制评论字数少于100字" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(wqCommentsTextField:commentsContentString:)]) {
        [self.delegate wqCommentsTextField:self commentsContentString:textField.text];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textField.text];
    [changedString replaceCharactersInRange:range withString:string];
    
    if (changedString.length != 0) {
        self.writingTwoImageView.hidden = YES;
    }else{
        self.writingTwoImageView.hidden = NO;
    }
    
    return YES;
}

@end
