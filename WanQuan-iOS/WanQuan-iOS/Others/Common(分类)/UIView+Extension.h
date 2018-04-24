//
//  UIView+Extension.h
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 wkj. All rights reserved.
//  基本没用

#import <UIKit/UIKit.h>

@interface UIView (Extension)
/**
 *  UIView的x
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  UIView的y
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  UIView最大的x
 */
@property (nonatomic, assign) CGFloat maxX;
/**
 *  UIView最大的y
 */
@property (nonatomic, assign) CGFloat maxY;
/**
 *  UIView中心x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  UIView中心y
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  UIView的宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  UIView的高
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  UIView的尺寸
 */
@property (nonatomic, assign) CGSize size;

/**
 *  当前view的controller
 *
 *  @return UIViewController
 */
- (UIViewController *)viewController;

@end

#pragma mark -- UIView的动画扩展
@interface UIView (Animation)

/**
 *  view的缩放动画
 *
 *  @param scaleValue 从大到小动画
 */
-(void)scaleAnimationWithScale:(CGFloat)scaleValue;

@end
