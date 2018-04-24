//
//  WQTextInputView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTextInputView.h"

@interface WQTextInputView ()
@property (weak, nonatomic) IBOutlet UIImageView *inputBackGround;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageBottom;



@end

@implementation WQTextInputView

- (void)awakeFromNib  {
    [super awakeFromNib];
//    UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    _inputtextView.textContainerInset = UIEdgeInsetsMake(6, 5, 4, 5);
    _inputBackGround.layer.cornerRadius = 5;
    _inputBackGround.layer.borderWidth = 0.5;
    _inputBackGround.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _inputBackGround.layer.masksToBounds = YES;
    _addPicImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageOnTap)];
    [_addPicImageView addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    _deleteImageButton.hidden = YES;
    
    
    [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                           forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:WQ_LIGHT_PURPLE]
                           forState:UIControlStateNormal];
    _sendButton.layer.cornerRadius = 2;
    _sendButton.layer.masksToBounds = YES;
    _sendButton.layer.borderWidth = .5;
    _sendButton.layer.borderColor = HEX(0x999999).CGColor;
    
    _sendButton.hidden = YES;
    _sendButton.enabled = NO;
    
    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x878787]};
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"comment_pinglun"];
    attachment.bounds = CGRectMake(0, 0, 16, 16);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:text];

    
    
    [_inputtextView setValue:attM forKey:@"attributedPlaceholder"];
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(___textViewTextChanged:) name:UITextViewTextDidChangeNotification
                                               object:_inputtextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(___textViewDidBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:_inputtextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(___textViewDidEndEdit:) name:UITextViewTextDidEndEditingNotification object:_inputtextView];
}

- (void)___textViewTextChanged:(NSNotification *)noti {
    CGFloat maxHeight = 110;
    if (noti.object == _inputtextView) {
        CGFloat fixedWidth = _inputtextView.frame.size.width;
        CGSize newSize = [_inputtextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = _inputtextView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        if (newFrame.size.height > maxHeight) {
            newFrame.size.height = maxHeight;
            _inputtextView.scrollEnabled = YES;
        } else {
            newFrame.size.height = newFrame.size.height;
            _inputtextView.scrollEnabled = NO;
        }
        _inputHeight.constant = newFrame.size.height;
    }
}

- (void)___textViewDidBeginEdit:(NSNotification *)noti {
    
    if (noti.object == _inputtextView) {
        
        [UIView animateWithDuration:1 animations:^{
            _addImageBottom.constant = 7;
            _inputViewBottomSpace.constant = 40;
            _inputViewLeadingSpace.constant = -22;
            _sendButton.hidden = NO;
        }];
        
    }
}
- (void)___textViewDidEndEdit:(NSNotification *)noti {
    
    if (noti.object == _inputtextView) {
//        _addImageBottom.constant =
        [UIView animateWithDuration:1 animations:^{
            _inputViewBottomSpace.constant = 10;
            _inputViewLeadingSpace.constant = 10;
            
            _addImageBottom.constant = 12;
            _sendButton.hidden = YES;
        }];

    }
}

- (IBAction)sendMessage:(id)sender {
    if (_sendButton.enabled == NO) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQTextInputView:sendButtonClicked:)]) {
        [self.delegate WQTextInputView:self sendButtonClicked:sender];
    }
}

- (IBAction)deleteImageButtonOnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQTextInputView:deleteImageButtonOnclick:)]) {
        [self.delegate WQTextInputView:self deleteImageButtonOnclick:sender];
    }
}
- (void)addImageOnTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQTextInputView:addImageViewOnTap:)]) {
        [self.delegate WQTextInputView:self addImageViewOnTap:self.addPicImageView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////             [self.inputtextView becomeFirstResponder];
//        });
       
    }
}


@end
