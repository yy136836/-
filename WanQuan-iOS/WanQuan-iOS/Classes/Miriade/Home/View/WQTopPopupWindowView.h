//
//  WQTopPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQTopPopupWindowView;

@protocol WQTopPopupWindowViewDelegate <NSObject>

/**
 我的动态

 @param topPopupWindowView
 */
- (void)dynamicBtnClickTopPopupWindowView:(WQTopPopupWindowView *)topPopupWindowView;

/**
 // 我参与的动态

 @param topPopupWindowView
 */
- (void)participateBtnClickTopPopupWindowView:(WQTopPopupWindowView *)topPopupWindowView;
@end

@interface WQTopPopupWindowView : UIView

@property (nonatomic, weak) id <WQTopPopupWindowViewDelegate> delegate;

@end
