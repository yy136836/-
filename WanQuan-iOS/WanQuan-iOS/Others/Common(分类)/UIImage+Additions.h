//
//  UIImage+Additions.h
//  gh_load
//
//  Created by gh_load on 16/2/24.
//  Copyright © 2016年 gh_load. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)tintImageWithColor:(UIColor *)tintColor;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)getScreenSnap;
- (UIImage *)scaleToWidth:(CGFloat)width;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
