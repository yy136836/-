//
//  UILabel+Addition.m
//  gh_load
//
//  Created by gh_load on 16/6/24.
//  Copyright © 2016年 gh_load. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (instancetype)labelWithText:(NSString*)text andTextColor:(UIColor*)textColor andFontSize:(CGFloat)fontSize {
    UILabel* label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label sizeToFit];
    return label;
}

@end
