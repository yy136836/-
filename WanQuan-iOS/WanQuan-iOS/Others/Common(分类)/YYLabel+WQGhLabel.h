//
//  YYLabel+WQGhLabel.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/6.
//  Copyright © 2017年 WQ. All rights reserved.
//   基本没用

#import <YYText/YYText.h>

@interface YYLabel (WQGhLabel)

/**
 *  改变行间距
 */
- (void)changeLineSpaceForLabel:(YYLabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceForLabel:(YYLabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabel:(YYLabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
