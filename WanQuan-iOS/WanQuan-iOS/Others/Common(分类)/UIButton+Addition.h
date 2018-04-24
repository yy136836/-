//
//  UIButton+Addition.h
//  gh_load
//
//  Created by gh_load on 16/7/19.
//  Copyright © 2016年 gh_load. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^addActionBlock)( UIButton * _Nullable sender);

@interface UIButton (Addition)

+ (instancetype)setNormalTitle:(NSString *)normalTitle andNormalColor:(UIColor *)color andFont:(CGFloat)font;

+ (instancetype)setHighlightedTitle:(NSString *)highlightedTitle andHighlightedColor:(UIColor *)color andFont:(CGFloat)font;

- (void)addClickAction:(nullable addActionBlock)addAction;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (void)setEnlargeEdge:(CGFloat) size;

@end
