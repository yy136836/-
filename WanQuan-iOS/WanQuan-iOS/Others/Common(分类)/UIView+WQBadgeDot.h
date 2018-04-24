//
//  UIView+WQBadgeDot.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 该类仅仅为了在某些视图上面显示红点
 */
@interface UIView (WQBadgeDot)


/**
 该属性只允许设置 badge 的一些属性而不建议直接设置 badge
 */
- (void)showDotBadge;
- (void)hideDotBadge;

@end
