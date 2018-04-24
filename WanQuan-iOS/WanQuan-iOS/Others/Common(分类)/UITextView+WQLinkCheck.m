//
//  UITextView+WQLinkCheck.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UITextView+WQLinkCheck.h"

@implementation UITextView (WQLinkCheck)


//- (void)setText:(NSString *)text {
//    [self setAttributedText:[[NSMutableAttributedString alloc] initWithString:text]];
//}
//
//- (void)setAttributedText:(NSAttributedString *)attributedText {
//    
//    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
//    
//    NSMutableAttributedString * strM = attributedText.mutableCopy;
//    
//    NSArray * arr =  [detector matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
//    
//    for (NSTextCheckingResult * result in arr) {
//        if (result.resultType == NSTextCheckingTypeLink) {
//            [strM addAttribute:NSLinkAttributeName value:result.URL range:result.range];
//        }
//    }
//    
//    [self setValue:strM forKey:attributedText];
//    
//}

@end
