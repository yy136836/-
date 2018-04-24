//
//  WQmessageHomeTopView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQslidingView;

@interface WQmessageHomeTopView : UIView

@property (nonatomic, strong) WQslidingView *slidingView;
@property (nonatomic, assign) CGFloat btnCGfloat;
@property (nonatomic, strong) UIButton *systemMessageBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) void (^systemMessageBtnClikeBlock)(NSInteger);

- (void)reloadSlodingViewLocation:(CGFloat)offsetX;
@end
