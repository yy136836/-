//
//  UILabel+WQLinkTapAction.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/22.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "UILabel+WQLinkTapAction.h"

@implementation UILabel (WQLinkTapAction)

- (void)setTextWithLinkAttribute:(NSString *)text {
    self.attributedText = [self subStr:text];
}

- (NSMutableAttributedString *)subStr:(NSString *)string {
    NSError *error;
    
    // 识别url
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr                             options:NSRegularExpressionCaseInsensitive                           error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *rangeArr = [[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    self.linkArray = arr;
    
    NSString *subStr = string;
    for (NSString *str in arr) {
        [rangeArr addObject:[self rangesOfString:str inString:subStr]];
    }
    
    UIFont *font = self.font;
    NSMutableAttributedString *attributedText;
    
    attributedText = [[NSMutableAttributedString alloc] initWithString:subStr attributes:@{NSFontAttributeName : font}];

    for(NSValue *value in rangeArr) {
        NSInteger index = [rangeArr indexOfObject:value];
        NSRange range = [value rangeValue];
        //[attributedText addAttribute:NSLinkAttributeName value:[NSURL URLWithString:[arr objectAtIndex:index]] range:range];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x5288d8] range:range];
        if ([self.type isEqualToString:@"环信"]) {
            [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffbd1d] range:range];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = 5;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedText;
}

// 获取查找字符串在母串中的NSRange
- (NSValue *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    if ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    
    return [NSValue valueWithRange:range];
}

- (void)setLinkArray:(NSMutableArray *)linkArray {
    objc_setAssociatedObject(self, @"linkArray", linkArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)linkArray {
    return objc_getAssociatedObject(self, @"linkArray");
}

- (void)setType:(NSString *)type {
    objc_setAssociatedObject(self, @"type", type, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)type {
    return objc_getAssociatedObject(self, @"type");
}

@end
