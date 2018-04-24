//
//  YYTextView+WQLinkCheck.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "YYTextView+WQLinkCheck.h"

@implementation YYTextView (WQLinkCheck)


+ (void)load {
    
    Method method1 = class_getInstanceMethod(self, @selector(setAttributedText:));
    Method method2 = class_getInstanceMethod(self, @selector(WQ_setAttributedText:));
    
    
    
    
    method_exchangeImplementations(method1, method2);
    //    method_exchangeImplementations(method3, method4);
    
    
    
}

- (void)setText:(NSString *)text {
    [self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self.font}]];
}

- (void)WQ_setAttributedText:(NSAttributedString *)attributedText {
    
    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    if ([attributedText isKindOfClass:[NSString class]]) {
        attributedText = [[NSAttributedString alloc] initWithString:(NSString *)attributedText];
    }
    
    NSMutableAttributedString * strM = attributedText.mutableCopy;
    
    NSArray * arr =  [detector matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
    
    for (NSTextCheckingResult * result in arr) {
        if (result.resultType == NSTextCheckingTypeLink) {
            
            [strM addAttribute:NSForegroundColorAttributeName value:LINK_COLOR range:result.range];
            [strM yy_setTextHighlightRange:result.range color:LINK_COLOR backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [[UIApplication sharedApplication] openURL:result.URL];
            }];
        }
    }
    
    [self WQ_setAttributedText:strM];
    
    
}




@end
