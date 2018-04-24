//
//  YYLabel+WQLinkCheck.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "YYLabel+WQLinkCheck.h"
#import <objc/runtime.h>


NSString * longPressstring;
@implementation YYLabel (WQLinkCheck)
+ (void)load {
    
    Method method1 = class_getInstanceMethod(self, @selector(setAttributedText:));
    Method method2 = class_getInstanceMethod(self, @selector(WQ_setAttributedText:));
    
    method_exchangeImplementations(method1, method2);
}

- (void)setText:(NSString *)text {
    
    if (text.length == 0) {
        return;
    }
    [self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self.font}]];
}

- (void)WQ_setAttributedText:(NSAttributedString *)attributedText {

    __weak typeof(self) weakself = self;
    
    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    if ([attributedText isKindOfClass:[NSString class]]) {
        attributedText = [[NSAttributedString alloc] initWithString:(NSString *)attributedText];
    }
    
    NSMutableAttributedString * strM = attributedText.mutableCopy;

    [strM yy_setTextHighlightRange:NSMakeRange(0, strM.length)
                             color:nil
                   backgroundColor:nil
                          userInfo:nil
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             
                         }
                   longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             UIMenuController * menu = [UIMenuController sharedMenuController];
                             [menu setTargetRect:rect inView:weakself];
                             UIMenuItem * item = [[UIMenuItem alloc] initWithTitle:@"复制全文"
                                                                            action:@selector(copyAll:)];
                             longPressstring =  [text.string substringWithRange:range];
                             menu.menuItems = @[item];
                             [weakself becomeFirstResponder];
                             [menu setMenuVisible:YES animated:YES];
                         }];
    
    [self WQ_setAttributedText:strM];
    
    
    
    NSArray * arr =  [detector matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
    
    
    for (NSTextCheckingResult * result in arr) {
        if (result.resultType == NSTextCheckingTypeLink) {
            [strM addAttribute:NSLinkAttributeName value:result.URL range:result.range];
            
            
            [strM addAttribute:NSForegroundColorAttributeName value:LINK_COLOR range:result.range];
            
            
            [strM yy_setTextHighlightRange:result.range
                                     color:nil
                           backgroundColor:nil
                                  userInfo:nil
                                 tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                     [[UIApplication sharedApplication] openURL:result.URL];
                                 }
                           longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                               UIMenuController * menu = [UIMenuController sharedMenuController];
                               [menu setTargetRect:rect inView:weakself];
                               UIMenuItem * item = [[UIMenuItem alloc] initWithTitle:@"复制网址"
                                                                              action:@selector(copyURL:)];
                               longPressstring =  [text.string substringWithRange:range];
                               menu.menuItems = @[item];
                               [weakself becomeFirstResponder];
                               [menu setMenuVisible:YES animated:YES];
                           }];
        }
    }
    [self WQ_setAttributedText:strM];
}


- (void)copyURL:(UIMenuController *)menu {
    
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = longPressstring;
}

- (void)copyAll:(UIMenuController *)menu {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = longPressstring;
}


-(BOOL)canBecomeFirstResponder {
    return true;
}

//监听自己的定义事件，是 return YES；  否 return NO 即移除系统；
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(copyURL:) || action == @selector(copyAll:)) {
        return YES;
    }
    return NO;
}


@end
