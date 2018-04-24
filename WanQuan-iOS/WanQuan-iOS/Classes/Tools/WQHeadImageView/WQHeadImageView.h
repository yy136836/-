//
//  WQHeadImageView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^Tapaction)(void);

/**
 头像,因为很多地方用到头像而且点击的行为很接近所以抽出作为一个新的控件
 */
@interface WQHeadImageView : UIImageView

/**
 当前用户是否是实名
 */
@property (nonatomic, assign, getter=isTureName) BOOL tureName;

/**
 当前用户的 userid
 */
@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) Tapaction tapaction;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage NS_UNAVAILABLE;

@end
