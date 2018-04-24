//
//  WQPopupWindowEncourageView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/31.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPopupWindowEncourageView;

@protocol WQPopupWindowEncourageViewDelegate <NSObject>

/**
 提交的响应事件

 @param encourageView self
 @param moneyString 鼓励金额
 */
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString;

/**
 取消的响应事件

 @param encourageView self
 */
- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView;
@end

@interface WQPopupWindowEncourageView : UIView

@property (nonatomic, weak) id <WQPopupWindowEncourageViewDelegate> delegate;

/**
 输入的金额
 */
@property (nonatomic, strong) UITextField *moneyTextField;

@end
