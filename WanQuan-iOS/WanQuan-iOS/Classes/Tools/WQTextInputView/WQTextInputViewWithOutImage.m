//
//  WQTextInputViewWithOutImage.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/6.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTextInputViewWithOutImage.h"

@interface WQTextInputViewWithOutImage() <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputBackGround;


@end

@implementation WQTextInputViewWithOutImage

- (void)awakeFromNib {
    [super awakeFromNib];
    _inputtextView.delegate = self;
    _inputtextView.textContainerInset = UIEdgeInsetsMake(6, 5, 4, 5);
    _inputBackGround.layer.cornerRadius = 5;
    _inputBackGround.layer.borderWidth = 0.5;
    _inputBackGround.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _inputBackGround.layer.masksToBounds = YES;
    
    [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                           forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:WQ_LIGHT_PURPLE]
                           forState:UIControlStateNormal];
    _sendButton.enabled = NO;
    _sendButton.layer.cornerRadius = 2;
    _sendButton.layer.masksToBounds = YES;
    _sendButton.layer.borderWidth = .5;
    _sendButton.layer.borderColor = HEX(0x999999).CGColor;
    
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
//    _inputtextView.inputAccessoryView = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(___textViewTextChanged:) name:UITextViewTextDidChangeNotification
                                               object:_inputtextView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(___textViewTextEndEditing:) name:UITextViewTextDidEndEditingNotification
                                               object:_inputtextView];
    [_inputtextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

    
}

- (void)___textViewTextChanged:(NSNotification *)noti {
    CGFloat maxHeight = 110;
    if (noti.object == _inputtextView) {
        if (!_inputtextView.text.length) {
            _sendButton.enabled = NO;
        } else {
            _sendButton.enabled = YES;
        }
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
        [[NSNotificationCenter defaultCenter] postNotificationName:WQUpdateConstraints object:self];
        _sendButton.enabled = [_inputtextView.text isVisibleString];
    }
}

- (void)___textViewTextEndEditing:(NSNotification *)noti {
      if (noti.object == _inputtextView) {
          if (!_inputtextView.text.length) {
              _inputHeight.constant = 30;
          }
      }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"111");
}

- (IBAction)sendMessage:(id)sender {
    if (_sendButton.enabled == NO) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQTextInputViewWithOutImage:sendComment:)]) {
        [self.delegate WQTextInputViewWithOutImage:self sendComment:_sendButton];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _inputtextView) {
        if (![change[NSKeyValueChangeNewKey] length]) {
            _inputHeight.constant = 30;
        }
    }
}

-(void)dealloc {
    [_inputtextView removeObserver:self forKeyPath:@"text"];
}
         
@end
