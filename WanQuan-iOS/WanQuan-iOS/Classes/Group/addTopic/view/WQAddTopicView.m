//
//  WQAddTopicView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddTopicView.h"

@interface WQAddTopicView ()<UITextViewDelegate, UITextFieldDelegate>

@end




@implementation WQAddTopicView

- (void)awakeFromNib {
    [super awakeFromNib];

    
//    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
//                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x999999]};
    
    // 图片文本
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"wodeyoushi"];
//    attachment.bounds = CGRectMake(0, 0, 15, 15);
//    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
//    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"请在此输入主题内容" attributes:titleDict];
//    // 合并文字
//    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
//    [attM appendAttributedString:text];
//    _cottentTextView.attributedPlaceholder = attM;
//    
//    _titleField.delegate = self;
//    _cottentTextView.delegate = self;
//    
//    UIToolbar * bar = [[UIToolbar alloc] init];
//    bar.frame = CGRectMake(0, 0, kScreenWidth, 44);
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneOnclick)];
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x5d2a89]} forState:UIControlStateNormal];
//    bar.items = @[item];
//
//    _titleField.inputAccessoryView = bar;
//    _cottentTextView.inputAccessoryView = bar;
    
    [self.titleField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    self.cottentTextView.placeholder = @"请在此输入主题";
    self.cottentTextView.placeholderColor = [UIColor colorWithHex:0x999999];
    self.cottentTextView.textColor = [UIColor colorWithHex:0x333333];
    self.cottentTextView.font = [UIFont systemFontOfSize:16];
    
    
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    toobar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(endEdit)];
    
    toobar.items =@[item];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:WQ_LIGHT_PURPLE}
                        forState:UIControlStateNormal];
    
    self.titleField.inputAccessoryView = toobar;
    self.cottentTextView.inputAccessoryView = toobar;
}

- (void)doneOnclick {
    [self.viewController.view endEditing:YES];
}

- (void)endEdit {
    [self endEditing:YES];
}
@end
