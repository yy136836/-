//
//  UILabel+WQLinkTapAction.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/22.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WQLinkTapAction)

/**
 链接集合
 */
@property (nonatomic, strong) NSMutableArray *linkArray;

@property (nonatomic, copy) NSString *type;

/**
 识别链接

 @param text text
 */
- (void)setTextWithLinkAttribute:(NSString *)text;

@end
