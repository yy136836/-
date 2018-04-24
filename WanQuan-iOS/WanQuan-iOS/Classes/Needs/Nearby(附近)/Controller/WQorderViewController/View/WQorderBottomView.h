//
//  WQorderBottomView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQorderBottomView;

@protocol WQorderBottomViewDelegate <NSObject>

- (void)WQorderBottomView:(WQorderBottomView *)orderBottomView askBtnClike:(UIButton *)askBtn;
- (void)WQorderBottomView:(WQorderBottomView *)orderBottomView helpBtnClike:(UIButton *)helpBtn;

@end

@interface WQorderBottomView : UIView

@property (nonatomic, weak) id<WQorderBottomViewDelegate>delegate;
@property (nonatomic, strong) UIButton *askBtn;
@property (nonatomic, strong) UIButton *helpBtn;
@end
