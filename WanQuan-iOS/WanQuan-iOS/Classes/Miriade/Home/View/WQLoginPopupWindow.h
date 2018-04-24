//
//  WQLoginPopupWindow.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLoginPopupWindow;

@protocol WQLoginPopupWindowDelegate <NSObject>
// 登录的点击事件
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow;
// 注册的点击事件
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow;
// 半透明区域点击
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow;
@end

@interface WQLoginPopupWindow : UIView

@property (nonatomic, weak) id <WQLoginPopupWindowDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;

@end
