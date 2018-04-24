//
//  WQCommentsInputView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentsInputView.h"

@interface WQCommentsInputView () <UITextViewDelegate>

@end

@implementation WQCommentsInputView  

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(___textViewTextChanged:) name:UITextViewTextDidChangeNotification
                                                   object:self.commentsTextView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 顶部分隔线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.top.equalTo(self);
    }];
    
    
    // 评论的输入框
    UITextView *commentsTextView = [[UITextView alloc] init];
    self.commentsTextView = commentsTextView;
    commentsTextView.placeholder = @"评论";
//    commentsTextField.placeholder = @"          评论";
//    commentsTextField.layer.cornerRadius = 5;
//    commentsTextField.layer.masksToBounds = YES;
    commentsTextView.delegate = self;
    //commentsTextField.borderStyle = UITextBorderStyleRoundedRect;
//    commentsTextField.layer.borderWidth = 1.0f;
    commentsTextView.returnKeyType = UIReturnKeySend;
    //commentsTextField.layer.borderColor = [UIColor colorWithHex:0xcbcbcb].CGColor;
    commentsTextView.layer.cornerRadius = 5;
    [commentsTextView setFont:[UIFont systemFontOfSize:15]];
    commentsTextView.layer.borderWidth = 0.5;
    commentsTextView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    commentsTextView.layer.masksToBounds = YES;
//    [commentsTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//    [commentsTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x999999]};
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"wodeyoushi"];
    attachment.bounds = CGRectMake(0, 0, 15, 15);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:text];
    
    
    
    [self addSubview:commentsTextView];
    [commentsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(ghStatusCellMargin);
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.height.offset(40);
    }];
    
    // 书写图标
//    UIImageView *writingTwoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodeyoushi"]];
//    self.writingTwoImageView = writingTwoImageView;
//    [commentsTextField addSubview:writingTwoImageView];
//    [writingTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(17, 17));
//        make.left.equalTo(commentsTextField.mas_left).offset(ghStatusCellMargin);
//        make.top.equalTo(commentsTextField.mas_top).offset(6);
//    }];
//    [self.commentsTextField addObserver:self forKeyPath:@"placeholder" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delagate respondsToSelector:@selector(wqStartEditing:)]) {
        [self.delagate wqStartEditing:self];
    }
}

#pragma mark -- textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([textView.text isEqualToString:@""]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请填写内容" preferredStyle:UIAlertControllerStyleAlert];
            
            [self.viewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        if (textView.text.length > 100) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请控制评论字数少于100字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self.viewController presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        
        if ([self.delagate respondsToSelector:@selector(wqCommentsTextField:commentsContentString:)]) {
            [self.delagate wqCommentsTextField:self commentsContentString:self.commentsTextView.text];
        }
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    
    return YES;
}

//结束编辑
//-(void)textViewDidEndEditing:(UITextView *)textView {
//    self.commentsTextView.text = @"";
//    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
//                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x999999]};
//    // 图片文本
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"wodeyoushi"];
//    attachment.bounds = CGRectMake(0, 0, 13, 13);
//    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
//    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
//    // 合并文字
//    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
//    [attM appendAttributedString:text];
//    self.commentsTextView.attributedPlaceholder = attM;
//}

- (void)___textViewTextChanged:(NSNotification *)noti {
    CGFloat maxHeight = 110;
    if (noti.object == self.commentsTextView) {
        CGFloat fixedWidth = self.commentsTextView.frame.size.width;
        CGSize newSize = [self.commentsTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.commentsTextView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        if (newFrame.size.height > maxHeight) {
            newFrame.size.height = maxHeight;
            self.commentsTextView.scrollEnabled = YES;
        } else {
            newFrame.size.height = newFrame.size.height;
            self.commentsTextView.scrollEnabled = NO;
        }
        if (self.wqChangeHeightBlock) {
            self.wqChangeHeightBlock(newFrame.size.height);
        }
        [self.commentsTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(newFrame.size.height);
        }];
    }
}

//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ((![self.commentsTextField.placeholder hasPrefix:@" " ])|| self.commentsTextField.text.length){
//        _writingTwoImageView.hidden = YES;
//    } else {
//        _writingTwoImageView.hidden = NO;
//    }
//}
//
//-(void)dealloc {
//    [self.commentsTextField removeObserver:self forKeyPath:@"placeholder"];
//}
@end
