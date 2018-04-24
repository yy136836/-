//
//  UITextField+WQEmojiForbid.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UITextField+WQEmojiForbid.h"

@implementation UITextField (WQEmojiForbid)
//将 textview textfield 的禁止 emoji 处理都放在这里



+ (void)load {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(____textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(____textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}


/**
 当文字改变时获得通知去掉 emoji

 @param aNotification UITextFieldTextDidChangeNotification
 */
+ (void)____textChanged:(NSNotification*)aNotification {
    UITextField * textField = aNotification.object;
    NSString * text = textField.text;
    if ([self stringContainsEmoji:text]) {
        [SVProgressHUD showErrorWithStatus:@"暂时不支持聊天表情"];
        [SVProgressHUD dismissWithDelay:1];
        
        [self deleteEmoji:textField];
    }
    
    
    
    
}


+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


+ (void)deleteEmoji:(UITextField *)field {
    
    NSString * newStr = @"";
    NSString *text = field.text;
    if (text.length>0) {
        
        if (text.length >3) {
            if ([self stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([self stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([self stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else  if ([self stringContainsEmoji:[text substringFromIndex:text.length-4]]) {
                newStr=[text substringToIndex:text.length-4];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        }else if (text.length >2) {
            
            if ([self stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([self stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([self stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
        }else   if (text.length >1) {
            if ([self stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([self stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
        }
        field.text = newStr;
    }
}


@end
